#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Image
from std_msgs.msg import String
from cv_bridge import CvBridge
import cv2
from ultralytics import YOLO
import numpy as np
import json

class VisionNode(Node):
    def __init__(self):
        super().__init__('vision_node')
        
        # Load YOLO model
        # Using the absolute path to the best.onnx file
        self.model_path = '/home/ubuntu/chair_ws/src/best.onnx'
        self.get_logger().info(f'Loading YOLO model from {self.model_path}...')
        try:
            self.model = YOLO(self.model_path, task='detect')
            self.get_logger().info('Model loaded successfully.')
        except Exception as e:
            self.get_logger().error(f'Failed to load model: {str(e)}')
            return

        self.bridge = CvBridge()
        self.is_processing = False  # Lock to skip frames
        self.last_inference_time = self.get_clock().now()
        self.inference_interval = 0.5 # 2 FPS - adjust as needed (0.2 = 5 FPS)
        
        # Subscriber to camera image - using direct Ignition namespaced topic
        self.subscription = self.create_subscription(
            Image,
            '/camera/image',
            self.image_callback,
            2  # Small queue to keep only fresh frames
        )
        
        # Publisher for annotated image
        self.publisher_ = self.create_publisher(Image, '/vision/annotated_image', 10)
        
        # Publisher for JSON detection data
        self.json_publisher_ = self.create_publisher(String, '/vision/detections', 10)
        
        self.get_logger().info('Vision Node started with frame-skipping optimization and JSON publishing.')

    def image_callback(self, msg):
        current_time = self.get_clock().now()
        elapsed = (current_time - self.last_inference_time).nanoseconds / 1e9
        
        # If we are already processing a frame OR it's too soon, skip
        if self.is_processing or elapsed < self.inference_interval:
            return

        try:
            self.is_processing = True
            start_time = self.get_clock().now()

            # Convert ROS Image to OpenCV
            cv_image = self.bridge.imgmsg_to_cv2(msg, desired_encoding='bgr8')
            
            # Run YOLO inference with optimized settings
            # imgsz=320 makes it much faster than default 640
            results = self.model(cv_image, conf=0.5, imgsz=320, verbose=False)
            
            # Extract detections into JSON format
            detections = []
            if len(results) > 0:
                result = results[0]
                names = result.names
                for box in result.boxes:
                    cls_id = int(box.cls[0].item())
                    label = names[cls_id] if names else str(cls_id)
                    conf = float(box.conf[0].item())
                    coords = box.xyxy[0].tolist()
                    
                    detections.append({
                        'class_id': cls_id,
                        'label': label,
                        'confidence': round(conf, 2),
                        'bbox': [round(c, 2) for c in coords]
                    })
            
            # Publish JSON data
            json_msg = String()
            json_msg.data = json.dumps(detections)
            self.json_publisher_.publish(json_msg)
            
            # Annotate
            annotated_frame = results[0].plot()
            
            # Convert back to ROS
            out_msg = self.bridge.cv2_to_imgmsg(annotated_frame, encoding='bgr8')
            out_msg.header = msg.header
            
            # Publish annotated image
            self.publisher_.publish(out_msg)
            
            # Log performance occasionally
            end_time = self.get_clock().now()
            duration = (end_time - start_time).nanoseconds / 1e6 # ms
            # self.get_logger().info(f'Inference took: {duration:.2f} ms', throttle_duration_sec=1.0)
            
        except Exception as e:
            self.get_logger().error(f'Error in image_callback: {str(e)}')
        finally:
            self.last_inference_time = self.get_clock().now()
            self.is_processing = False

def main(args=None):
    rclpy.init(args=args)
    node = VisionNode()
    if hasattr(node, 'model'):
        rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
