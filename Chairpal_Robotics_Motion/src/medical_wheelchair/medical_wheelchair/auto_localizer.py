#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from std_srvs.srv import Empty as EmptySrv
from std_msgs.msg import Empty as EmptyMsg
from geometry_msgs.msg import Twist
import math

class AutoLocalizer(Node):
    def __init__(self):
        super().__init__('auto_localizer')
        
        # Subscribe to trigger from Flutter app
        self.sub = self.create_subscription(
            EmptyMsg,
            '/app/trigger_localization',
            self.trigger_callback,
            10)
            
        # Publisher to move the wheelchair
        self.cmd_pub = self.create_publisher(Twist, '/cmd_vel', 10)
        
        # Client for AMCL global localization
        self.amcl_client = self.create_client(EmptySrv, '/reinitialize_global_localization')
        
        self.spin_timer = None
        self.spin_start_time = 0.0
        
        self.get_logger().info('Auto Localizer ready. Waiting for trigger on /app/trigger_localization')

    def trigger_callback(self, msg):
        self.get_logger().info('Localization triggered via App/Terminal!')
        
        if not self.amcl_client.wait_for_service(timeout_sec=2.0):
            self.get_logger().warn('AMCL global localization service not available (nav2 might not be fully up)!')
            return
            
        request = EmptySrv.Request()
        future = self.amcl_client.call_async(request)
        future.add_done_callback(self.scatter_done_callback)

    def scatter_done_callback(self, future):
        self.get_logger().info('AMCL Particles scattered globally! Starting 360 recovery spin...')
        
        self.spin_start_time = self.get_clock().now().nanoseconds / 1e9
        
        # Timer at 10Hz to publish Twist
        self.spin_timer = self.create_timer(0.1, self.spin_timer_callback)

    def spin_timer_callback(self):
        twist = Twist()
        # Rotate speed: 0.5 radians per second
        twist.angular.z = 0.5  
        current_time = self.get_clock().now().nanoseconds / 1e9
        
        # Calculate duration for 360 degrees (2 * pi rad)
        duration_needed = (2 * math.pi) / twist.angular.z
        
        if (current_time - self.spin_start_time) < duration_needed:
            self.cmd_pub.publish(twist)
        else:
            self.get_logger().info('Spin complete. Wheelchair localization ready to receive goals!')
            # Stop the wheelchair
            twist.angular.z = 0.0
            self.cmd_pub.publish(twist)
            self.spin_timer.cancel()

def main(args=None):
    rclpy.init(args=args)
    node = AutoLocalizer()
    rclpy.spin(node)
    
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
