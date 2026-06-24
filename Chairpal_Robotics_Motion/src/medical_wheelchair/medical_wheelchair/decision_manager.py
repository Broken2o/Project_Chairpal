#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from std_msgs.msg import String
import json
import time

class DecisionManager(Node):
    def __init__(self):
        super().__init__('decision_manager')

        # --- Subscribers (The 3 Sources of Movement) ---
        # 1. Autonomous Navigation (Lowest Priority)
        self.create_subscription(Twist, '/cmd_vel_nav', self.nav_callback, 10)
        # 2. Mobile App Buttons (Medium Priority)
        self.create_subscription(Twist, '/cmd_vel_app', self.app_callback, 10)
        # 3. Physical Joystick (Highest Priority)
        self.create_subscription(Twist, '/cmd_vel_joy', self.joy_callback, 10)

        # Vision for Obstacles/Stairs
        self.create_subscription(String, '/vision/detections', self.vision_callback, 10)

        # Publisher for final motor commands
        self.pub_cmd_vel = self.create_publisher(Twist, '/cmd_vel', 10)

        # --- Internal State & Timestamps for Priority Timeout ---
        self.stair_detected = False
        self.stair_timestamp = self.get_clock().now()
        
        self.last_joy_time = 0.0
        self.last_app_time = 0.0
        
        self.joy_msg = Twist()
        self.app_msg = Twist()
        self.nav_msg = Twist()

        # Decision Loop Timer (20Hz)
        self.create_timer(0.05, self.decision_loop)
        
        self.get_logger().info("Decision Manager (The Brain) started with Priority MUX.")

    def vision_callback(self, msg):
        try:
            detections = json.loads(msg.data)
            found_stairs = any(det.get('class') == 'stairs' for det in detections)
            if found_stairs:
                self.stair_detected = True
                self.stair_timestamp = self.get_clock().now()
            else:
                if (self.get_clock().now() - self.stair_timestamp).nanoseconds > 1e9:
                    self.stair_detected = False
        except:
            pass

    def joy_callback(self, msg):
        # If joystick has non-zero input, update timestamp to claim priority
        if abs(msg.linear.x) > 0.01 or abs(msg.angular.z) > 0.01:
            self.last_joy_time = time.time()
        self.joy_msg = msg

    def app_callback(self, msg):
        # If App has non-zero input, update timestamp to claim priority
        if abs(msg.linear.x) > 0.01 or abs(msg.angular.z) > 0.01:
            self.last_app_time = time.time()
        self.app_msg = msg

    def nav_callback(self, msg):
        self.nav_msg = msg

    def decision_loop(self):
        """ The MUX Logic: Physical Joy > App > Nav2 """
        now = time.time()
        final_msg = Twist()
        source = "Idle"
        publish_cmd = False

        # 1. Check Physical Joystick (Priority 1)
        # Timeout after 0.5 seconds of no joystick movement
        if (now - self.last_joy_time) < 0.5:
            final_msg = self.joy_msg
            source = "Physical Joystick"
            publish_cmd = True
        
        # 2. Check Mobile App (Priority 2)
        elif (now - self.last_app_time) < 0.5:
            final_msg = self.app_msg
            source = "Mobile App"
            publish_cmd = True
        
        # 3. Check Autonomous Nav (Priority 3)
        else:
            # Only use Nav2 if it's sending a real command (not idling zeros)
            if abs(self.nav_msg.linear.x) > 0.001 or abs(self.nav_msg.angular.z) > 0.001:
                final_msg = self.nav_msg
                source = "Nav2 Autonomous"
                publish_cmd = True

        # If nobody is commanding anything, DO NOT spam /cmd_vel with zeros.
        # This allows other tools (like keyboard teleop publishing directly to /cmd_vel) to work without fighting.
        if not publish_cmd:
            return

        # --- Safety Interception ---
        if self.stair_detected:
            # We allow small reverse if stairs are in front, but block forward
            if final_msg.linear.x > 0:
                final_msg.linear.x = 0.0
                final_msg.angular.z = 0.0
                self.get_logger().warn(f"Intercepting {source}: STAIRS detected!", throttle_duration_sec=2.0)

        self.pub_cmd_vel.publish(final_msg)


def main(args=None):
    rclpy.init(args=args)
    node = DecisionManager()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
