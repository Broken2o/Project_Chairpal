#!/usr/bin/env python3
"""
serial_bridge_node.py
---------------------
Function: Stable bridge between ROS 2 and Arduino via USB (Serial).
Provides smooth velocity scaling to overcome friction while maintaining variable control.
"""

import rclpy
from rclpy.node import Node

from geometry_msgs.msg import Twist
from nav_msgs.msg import Odometry
from sensor_msgs.msg import Imu, Range
from std_msgs.msg import Float32MultiArray

import serial
import threading
import math


# Configuration
SERIAL_PORT = '/dev/ttyUSB0'
BAUD_RATE = 115200

# Kinematic Dimensions
WHEEL_SEP = 0.34
X_FRONT = 0.26176
X_MID = 0.0
X_REAR = -0.19562
Y_LEFT = WHEEL_SEP / 2.0
Y_RIGHT = -WHEEL_SEP / 2.0

# Velocity Scaling Constants
MIN_START_OFFSET = 0.4
V_MAX_EXPECTED = 0.5


class SerialBridgeNode(Node):

    def __init__(self):
        super().__init__('serial_bridge_node')

        try:
            self.ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=0.1)
            self.get_logger().info(f"Serial port opened successfully: {SERIAL_PORT}")
        except serial.SerialException as e:
            self.get_logger().error(f"Failed to open serial port: {e}")
            self.ser = None

        # ROS 2 Subscriptions & Publishers
        self.create_subscription(Twist, '/cmd_vel', self.cmd_vel_callback, 10)

        self.pub_odom = self.create_publisher(Odometry, '/odom', 10)
        self.pub_imu = self.create_publisher(Imu, '/hardware/imu', 10)
        self.pub_ultrasonic = self.create_publisher(Range, '/ultrasonic_front', 10)
        self.pub_steer_fb = self.create_publisher(Float32MultiArray, '/hardware/steering_feedback', 10)

        # State
        self.last_cmd_msg = Twist()
        self.last_cmd_time = self.get_clock().now()
        self.last_zero_sent = False

        self.x = 0.0
        self.y = 0.0
        self.th = 0.0
        self.last_time = self.get_clock().now()

        # Timers & Threads
        self.command_timer = self.create_timer(0.1, self.command_heartbeat)

        self.read_thread = threading.Thread(target=self.read_serial_loop, daemon=True)
        self.read_thread.start()

        self.get_logger().info("Serial Bridge Node is active and synchronized.")

    # ---------------- Velocity Scaling ----------------
    def scale_velocity(self, v):
        abs_v = abs(v)

        if abs_v < 0.01:
            return 0.0

        v_scaled_abs = MIN_START_OFFSET + (abs_v / V_MAX_EXPECTED) * (1.0 - MIN_START_OFFSET)
        v_scaled = math.copysign(v_scaled_abs, v)

        return max(min(v_scaled, 1.0), -1.0)

    # ---------------- Serial Message Builder ----------------
    def build_serial_message(self, msg):
        v = msg.linear.x
        w = msg.angular.z

        v_scaled = self.scale_velocity(v)

        v_left = v_scaled - w * Y_LEFT
        v_right = v_scaled - w * Y_RIGHT

        if abs(w) < 0.01:
            return f"S:0.0,0.0,0.0,0.0|W:{v_left:.2f},{v_right:.2f}\n"

        if abs(w) >= 1e-4:
            R = v_scaled / w

            delta_fl = math.atan2(X_FRONT - X_MID, R - Y_LEFT)
            delta_fr = math.atan2(X_FRONT - X_MID, R - Y_RIGHT)
            delta_rl = math.atan2(X_REAR - X_MID, R - Y_LEFT)
            delta_rr = math.atan2(X_REAR - X_MID, R - Y_RIGHT)

            delta_fl = max(min(delta_fl, 0.785), -0.785)
            delta_fr = max(min(delta_fr, 0.785), -0.785)
            delta_rl = max(min(delta_rl, 0.785), -0.785)
            delta_rr = max(min(delta_rr, 0.785), -0.785)

            fl_deg = math.degrees(delta_fl)
            fr_deg = math.degrees(delta_fr)
            rl_deg = math.degrees(delta_rl)
            rr_deg = math.degrees(delta_rr)

            return f"S:{fl_deg:.1f},{fr_deg:.1f},{rl_deg:.1f},{rr_deg:.1f}|W:{v_left:.2f},{v_right:.2f}\n"

    # ---------------- Send ----------------
    def send_command(self, msg, log_sent=False):
        if self.ser is None or not self.ser.is_open:
            return

        serial_msg = self.build_serial_message(msg)

        try:
            self.ser.write(serial_msg.encode('utf-8'))
            if log_sent:
                self.get_logger().info(f"Serial: {serial_msg.strip()}")
        except serial.SerialException as e:
            self.get_logger().error(f"Serial write error: {e}")

    # ---------------- ROS Callback ----------------
    def cmd_vel_callback(self, msg):
        self.last_cmd_msg = msg
        self.last_cmd_time = self.get_clock().now()
        self.last_zero_sent = False
        self.send_command(msg, log_sent=True)

    # ---------------- Heartbeat ----------------
    def command_heartbeat(self):
        if self.ser is None or not self.ser.is_open:
            return

        age = (self.get_clock().now() - self.last_cmd_time).nanoseconds / 1e9

        if age <= 0.25:
            self.send_command(self.last_cmd_msg)
            return

        if not self.last_zero_sent:
            self.send_command(Twist())
            self.last_zero_sent = True

    # ---------------- Serial Reader ----------------
    def read_serial_loop(self):
        while rclpy.ok():

            if self.ser is None or not self.ser.is_open:
                continue

            try:
                line = self.ser.readline().decode('utf-8').strip()
                if not line:
                    continue

                segments = line.split('|')

                for seg in segments:
                    if ':' not in seg:
                        continue

                    prefix = seg[0]
                    values = seg[2:]

                    if prefix == 'E':
                        data = values.split(',')
                        if len(data) == 2:
                            self.update_odometry(float(data[0]), float(data[1]))

                    elif prefix == 'U':
                        self.publish_ultrasonic(float(values))

                    elif prefix == 'P':
                        data = values.split(',')
                        if len(data) == 4:
                            self.publish_steering_feedback([float(a) for a in data])

                    elif prefix == 'I':
                        data = values.split(',')
                        if len(data) == 3:
                            self.update_imu(float(data[0]), float(data[1]), float(data[2]))

            except Exception as e:
                self.get_logger().warn(f"Parse error: {e}")

    # ---------------- Odometry ----------------
    def update_odometry(self, v_left, v_right):
        current_time = self.get_clock().now()

        dt = (current_time - self.last_time).nanoseconds / 1e9
        if dt <= 0:
            return

        self.last_time = current_time

        v_robot = (v_left + v_right) / 2.0
        w_robot = (v_right - v_left) / WHEEL_SEP

        self.th += w_robot * dt
        self.x += v_robot * math.cos(self.th) * dt
        self.y += v_robot * math.sin(self.th) * dt

        odom = Odometry()
        odom.header.stamp = current_time.to_msg()
        odom.header.frame_id = "odom"
        odom.child_frame_id = "base_footprint"

        odom.pose.pose.position.x = self.x
        odom.pose.pose.position.y = self.y
        odom.pose.pose.orientation.z = math.sin(self.th / 2.0)
        odom.pose.pose.orientation.w = math.cos(self.th / 2.0)

        odom.twist.twist.linear.x = v_robot
        odom.twist.twist.angular.z = w_robot

        self.pub_odom.publish(odom)

    # ---------------- IMU ----------------
    def update_imu(self, roll_deg, pitch_deg, yaw_deg):
        imu_msg = Imu()
        imu_msg.header.stamp = self.get_clock().now().to_msg()
        imu_msg.header.frame_id = "imu_link"

        r = math.radians(roll_deg)
        p = math.radians(pitch_deg)
        y = math.radians(yaw_deg)

        cr, sr = math.cos(r/2), math.sin(r/2)
        cp, sp = math.cos(p/2), math.sin(p/2)
        cy, sy = math.cos(y/2), math.sin(y/2)

        imu_msg.orientation.x = sr * cp * cy - cr * sp * sy
        imu_msg.orientation.y = cr * sp * cy + sr * cp * sy
        imu_msg.orientation.z = cr * cp * sy - sr * sp * cy
        imu_msg.orientation.w = cr * cp * cy + sr * sp * sy

        self.pub_imu.publish(imu_msg)

    # ---------------- Ultrasonic ----------------
    def publish_ultrasonic(self, distance_cm):
        msg = Range()
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.header.frame_id = "ultrasonic_front_link"
        msg.radiation_type = Range.ULTRASOUND
        msg.field_of_view = 0.26
        msg.min_range = 0.02
        msg.max_range = 4.0
        msg.range = distance_cm / 100.0

        self.pub_ultrasonic.publish(msg)

    # ---------------- Steering Feedback ----------------
    def publish_steering_feedback(self, angles_deg):
        msg = Float32MultiArray()
        msg.data = angles_deg
        self.pub_steer_fb.publish(msg)


def main(args=None):
    rclpy.init(args=args)
    node = SerialBridgeNode()

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        if node.ser and node.ser.is_open:
            node.ser.close()
        node.destroy_node()
        rclpy.shutdown()


if __name__ == '__main__':
    main()