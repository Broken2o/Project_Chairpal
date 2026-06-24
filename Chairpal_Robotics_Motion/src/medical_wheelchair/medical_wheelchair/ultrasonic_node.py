import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Range
import serial

class UltrasonicNode(Node):
    def __init__(self):
        super().__init__('ultrasonic_node')
        
        # Declare parameters
        self.declare_parameter('port', '/dev/ttyUSB0')
        self.declare_parameter('baudrate', 9600)
        
        port = self.get_parameter('port').value
        baudrate = self.get_parameter('baudrate').value
        
        self.publisher_ = self.create_publisher(Range, '/ultrasonic_front', 10)
        
        try:
            self.serial_port = serial.Serial(port, baudrate, timeout=1.0)
            self.get_logger().info(f'Successfully connected to Arduino on {port}')
        except serial.SerialException as e:
            self.get_logger().error(f'Failed to connect to Arduino: {e}')
            self.serial_port = None
            
        timer_period = 0.05  # 20 Hz
        self.timer = self.create_timer(timer_period, self.timer_callback)

    def timer_callback(self):
        if self.serial_port is None:
            return
            
        if self.serial_port.in_waiting > 0:
            try:
                # Expecting string like "30.5\n" for 30.5 cm
                line = self.serial_port.readline().decode('utf-8').strip()
                if line:
                    distance_cm = float(line)
                    distance_m = distance_cm / 100.0
                    
                    msg = Range()
                    msg.header.stamp = self.get_clock().now().to_msg()
                    msg.header.frame_id = 'ultrasonic_link'
                    msg.radiation_type = Range.ULTRASOUND
                    msg.field_of_view = 0.26 # ~15 degrees
                    msg.min_range = 0.02
                    msg.max_range = 4.0
                    msg.range = distance_m
                    
                    self.publisher_.publish(msg)
            except ValueError:
                self.get_logger().warn(f'Could not parse serial data: {line}')
            except Exception as e:
                self.get_logger().error(f'Error reading serial: {e}')

def main(args=None):
    rclpy.init(args=args)
    node = UltrasonicNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()
