#!/usr/bin/env python3
"""
send_goal.py  –  Send a NavigateToPose goal to Nav2.

Usage:
  ros2 run medical_wheelchair send_goal <x> <y> [yaw_deg]

Examples:
  ros2 run medical_wheelchair send_goal 2.0 0.0          # 2 m forward, any heading
  ros2 run medical_wheelchair send_goal 1.0 1.0 90       # 1m right-forward, face left
  ros2 run medical_wheelchair send_goal 0.0 0.0 0        # return to origin
"""

import sys
import math
import rclpy
from rclpy.node import Node
from rclpy.action import ActionClient
from nav2_msgs.action import NavigateToPose
from geometry_msgs.msg import PoseStamped


class GoalSender(Node):
    def __init__(self):
        super().__init__('goal_sender')
        self._client = ActionClient(self, NavigateToPose, 'navigate_to_pose')
        self._goal_done = False

    def send_goal(self, x: float, y: float, yaw_deg: float = 0.0):
        self.get_logger().info(
            f'Waiting for Nav2 navigate_to_pose action server...'
        )
        if not self._client.wait_for_server(timeout_sec=15.0):
            self.get_logger().error(
                'Nav2 action server not available after 15 s. '
                'Is nav2_amcl.launch.py running?'
            )
            self._goal_done = True
            return

        goal_msg = NavigateToPose.Goal()

        pose = PoseStamped()
        pose.header.frame_id = 'map'
        pose.header.stamp = self.get_clock().now().to_msg()
        pose.pose.position.x = x
        pose.pose.position.y = y
        pose.pose.position.z = 0.0

        yaw_rad = math.radians(yaw_deg)
        pose.pose.orientation.z = math.sin(yaw_rad / 2.0)
        pose.pose.orientation.w = math.cos(yaw_rad / 2.0)

        goal_msg.pose = pose

        self.get_logger().info(
            f'Sending goal → x={x:.2f}, y={y:.2f}, yaw={yaw_deg:.1f}°'
        )
        self._send_future = self._client.send_goal_async(
            goal_msg,
            feedback_callback=self._feedback_callback,
        )
        self._send_future.add_done_callback(self._goal_response_callback)

    def _goal_response_callback(self, future):
        goal_handle = future.result()
        if not goal_handle.accepted:
            self.get_logger().error('❌  Goal was REJECTED by Nav2.')
            self._goal_done = True
            return

        self.get_logger().info('✅  Goal accepted. Navigating…')
        self._result_future = goal_handle.get_result_async()
        self._result_future.add_done_callback(self._result_callback)

    def _feedback_callback(self, feedback_msg):
        dist = feedback_msg.feedback.distance_remaining
        self.get_logger().info(
            f'   Distance remaining: {dist:.2f} m', throttle_duration_sec=1.0
        )

    def _result_callback(self, future):
        from action_msgs.msg import GoalStatus
        result = future.result()
        status = result.status
        if status == GoalStatus.STATUS_SUCCEEDED:
            self.get_logger().info('🎉  Goal REACHED successfully!')
        elif status == GoalStatus.STATUS_CANCELED:
            self.get_logger().warn('⚠️  Goal was CANCELED.')
        else:
            self.get_logger().error(f'💥  Goal ABORTED (status={status}).')
        self._goal_done = True


def main(args=None):
    rclpy.init(args=args)

    argv = sys.argv[1:]  # strip the ros2-injected args
    if len(argv) < 2:
        print(__doc__)
        print('ERROR: provide at least x and y arguments.')
        sys.exit(1)

    try:
        x       = float(argv[0])
        y       = float(argv[1])
        yaw_deg = float(argv[2]) if len(argv) >= 3 else 0.0
    except ValueError:
        print('ERROR: x, y, yaw must be numbers.')
        sys.exit(1)

    node = GoalSender()
    node.send_goal(x, y, yaw_deg)

    while rclpy.ok() and not node._goal_done:
        rclpy.spin_once(node, timeout_sec=0.1)

    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
