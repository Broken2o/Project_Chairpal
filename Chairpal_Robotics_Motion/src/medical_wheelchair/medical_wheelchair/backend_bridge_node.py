#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
import json
import math

from std_msgs.msg import String
from nav_msgs.msg import Odometry
from geometry_msgs.msg import PoseWithCovarianceStamped
from action_msgs.msg import GoalStatusArray
from sensor_msgs.msg import BatteryState, Range, LaserScan
from diagnostic_msgs.msg import DiagnosticArray

class BackendBridgeNode(Node):
    def __init__(self):
        super().__init__('backend_bridge_node')
        
        # --- Publishers for Flutter ---
        self.status_pub = self.create_publisher(String, '/wheelchair/app_status', 10)
        self.events_pub = self.create_publisher(String, '/wheelchair/events', 10)
        
        # --- State Variables ---
        self.current_speed = 0.0
        self.current_x = 0.0
        self.current_y = 0.0
        self.current_theta = 0.0
        self.battery_percent = 100.0
        self.min_obstacle_distance = 999.0
        self.status = "idle"
        self.mode = "manual"
        
        # Cooldown: prevent the same event from spamming (10 seconds per event type)
        self.last_event_time = {}
        self.event_cooldown_sec = 10.0
        
        # --- Subscribers to ROS state ---
        self.create_subscription(Odometry, '/odom', self.odom_callback, 10)
        self.create_subscription(PoseWithCovarianceStamped, '/amcl_pose', self.pose_callback, 10)
        self.create_subscription(GoalStatusArray, '/navigate_to_pose/_action/status', self.nav_status_callback, 10)
        self.create_subscription(BatteryState, '/battery_state', self.battery_callback, 10)
        self.create_subscription(LaserScan, '/scan_fixed', self.scan_callback, 10)
        
        # --- Event Subscribers (Triggers immediate publish) ---
        self.create_subscription(Range, '/ultrasonic_front', self.ultrasonic_callback, 10)
        self.create_subscription(DiagnosticArray, '/diagnostics', self.diagnostics_callback, 10)

        # Timer to publish continuous state every 1 second
        self.timer = self.create_timer(1.0, self.timer_callback)
        self.get_logger().info("Backend Bridge Node has started. Aggregating data for Backend API.")

    def odom_callback(self, msg):
        # We assume cmd_vel might not always reflect actual speed if motors are struggling
        # Odom linear x is the most accurate reflection of forward speed
        self.current_speed = round(msg.twist.twist.linear.x, 2)
        if abs(self.current_speed) > 0.05 and self.status != "moving":
            self.status = "moving"
        elif abs(self.current_speed) <= 0.05 and self.status == "moving":
            self.status = "idle"
            
        # Fallback: Update position from odom if amcl is not active
        self.current_x = round(msg.pose.pose.position.x, 2)
        self.current_y = round(msg.pose.pose.position.y, 2)
        
        q = msg.pose.pose.orientation
        siny_cosp = 2 * (q.w * q.z + q.x * q.y)
        cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z)
        yaw = math.atan2(siny_cosp, cosy_cosp)
        self.current_theta = round(yaw, 2)

    def pose_callback(self, msg):
        self.current_x = round(msg.pose.pose.position.x, 2)
        self.current_y = round(msg.pose.pose.position.y, 2)
        
        # Extract yaw from quaternion
        q = msg.pose.pose.orientation
        siny_cosp = 2 * (q.w * q.z + q.x * q.y)
        cosy_cosp = 1 - 2 * (q.y * q.y + q.z * q.z)
        yaw = math.atan2(siny_cosp, cosy_cosp)
        self.current_theta = round(yaw, 2)

    def nav_status_callback(self, msg):
        if not msg.status_list:
            return
            
        last_status = msg.status_list[-1].status
        # Status IDs: 2 = EXECUTING, 4 = SUCCEEDED, 5 = CANCELED, 6 = ABORTED
        if last_status == 2:
            self.mode = "autonomous"
            self.status = "moving"
        elif last_status == 4:
            self.mode = "manual"
            self.status = "completed"
            self.publish_event("trip_completed", "low", "Wheelchair reached the destination successfully.")
        elif last_status == 6:
            self.mode = "manual"
            self.publish_event("trip_aborted", "high", "Navigation failed to reach the goal.")

    def battery_callback(self, msg):
        self.battery_percent = round(msg.percentage * 100 if msg.percentage <= 1.0 else msg.percentage, 1)

    def scan_callback(self, msg):
        # Calculate minimum distance from valid laser scan points
        valid_ranges = [r for r in msg.ranges if not math.isinf(r) and r > msg.range_min]
        if valid_ranges:
            self.min_obstacle_distance = round(min(valid_ranges) * 100, 1)  # Convert to cm
            
            # Fire an event if obstacle is critical risk (< 30 cm)
            if self.min_obstacle_distance < 30.0:
                severity = "critical" if self.min_obstacle_distance < 20.0 else "high"
                self.publish_event(
                    event_type="obstacle",
                    severity=severity,
                    message=f"Obstacle detected at {self.min_obstacle_distance} cm",
                    data={"distance_cm": self.min_obstacle_distance}
                )

    def ultrasonic_callback(self, msg):
        # Check if obstacle is too close (e.g. less than 0.3 meters)
        if msg.range < 0.3 and msg.range > msg.min_range:
            # Publish emergency event immediately
            self.publish_event(
                event_type="obstacle", 
                severity="critical", 
                message=f"Obstacle detected very close: {round(msg.range*100, 1)} cm!",
                data={"distance_cm": round(msg.range*100, 1)}
            )

    def diagnostics_callback(self, msg):
        for status in msg.status:
            # ROS 2 diagnostic status level is usually returned as bytes.
            level = ord(status.level) if isinstance(status.level, bytes) else status.level
            
            # If diagnostic level is ERROR (2) or STALE (3)
            if level >= 2:
                self.publish_event(
                    event_type="hardware_error", 
                    severity="high", 
                    message=f"Hardware Error in {status.name}: {status.message}"
                )

    def timer_callback(self):
        # 1. Update Movement State (POST /trip/movement/update)
        # Dummy trip_id until Flutter sends it
        trip_id = 10 
        
        movement_payload = {
            "trip_id": trip_id,
            "movement_status": self.status,
            "speed": self.current_speed,
            "position": {
                "x": self.current_x,
                "y": self.current_y
            },
            "theta": self.current_theta,
            "obstacle_detected": self.min_obstacle_distance < 50.0,
            "obstacle_distance": self.min_obstacle_distance,
            "risk_level": "critical" if self.min_obstacle_distance < 20.0 else ("high" if self.min_obstacle_distance < 50.0 else ("medium" if self.min_obstacle_distance < 100.0 else "low")),
            "mode": self.mode
        }
        
        # 2. Battery Telemetry (POST /telemetry/battery)
        battery_payload = {
            "wheelchair_id": 1,
            "battery": self.battery_percent
        }
        
        # --- SIMULATING HTTP POST TO BACKEND ---
        # TODO: Implement requests.post() here inside a threading.Thread
        # to prevent HTTP latency from blocking the ROS execution loop.
        self.get_logger().info("=== SIMULATING HTTP POST TO BACKEND ===")
        self.get_logger().info(f"[POST /trip/movement/update]\n{json.dumps(movement_payload, indent=2)}")
        # self.get_logger().info(f"[POST /telemetry/battery]\n{json.dumps(battery_payload, indent=2)}")
        
        # We still publish the ROS string for Flutter if needed
        msg = String()
        msg.data = json.dumps(movement_payload)
        self.status_pub.publish(msg)

    def publish_event(self, event_type, severity, message, data=None):
        # --- Cooldown Check: don't spam the same event ---
        now = self.get_clock().now().nanoseconds / 1e9
        last = self.last_event_time.get(event_type, 0)
        if now - last < self.event_cooldown_sec:
            return  # Too soon, skip this event
        self.last_event_time[event_type] = now
        
        trip_id = 10
        event_payload = {
            "trip_id": trip_id,
            "type": event_type,
            "severity": severity,
            "message": message,
            "data": data if data else {}
        }
        
        # --- SIMULATING HTTP POST TO BACKEND ---
        # TODO: Implement requests.post() here inside a threading.Thread
        # to prevent HTTP latency from blocking the ROS execution loop.
        self.get_logger().warn(f"=== SIMULATING EVENT POST ===")
        self.get_logger().warn(f"[POST /trip/events]\n{json.dumps(event_payload, indent=2)}")
        
        event_msg = String()
        event_msg.data = json.dumps(event_payload)
        self.events_pub.publish(event_msg)

def main(args=None):
    rclpy.init(args=args)
    node = BackendBridgeNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
