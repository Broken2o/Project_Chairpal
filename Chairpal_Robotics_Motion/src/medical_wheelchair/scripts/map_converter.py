#!/usr/bin/env python3
import cv2
import yaml
import os
import argparse

def convert_image_to_map(image_path, output_dir, resolution=0.05):
    """
    Converts a floor plan image into a ROS 2 compatible Occupancy Grid (.pgm + .yaml)
    This script assumes the input image has dark lines for walls and white space for unhindered motion.
    """
    if not os.path.exists(image_path):
        print(f"Error: Image {image_path} not found.")
        return False

    # Load image in grayscale
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    if img is None:
        print("Error: Could not read the image.")
        return False

    # Apply threshold to simplify image
    # Assuming walls are dark (lines) and free space is white.
    # Below 128 becomes 0 (Black/Obstacle), above 128 becomes 254 (White/Free)
    # Nav2 usually treats 254 as perfectly free.
    _, thresh_img = cv2.threshold(img, 128, 254, cv2.THRESH_BINARY)
    
    # Optional: Add borders to the map to ensure the planner doesn't escape out of the image dimensions
    cv2.rectangle(thresh_img, (0, 0), (thresh_img.shape[1]-1, thresh_img.shape[0]-1), 0, 2)

    # Save PGM image (For ROS 2)
    base_name = "active_map"
    pgm_path = os.path.join(output_dir, f"{base_name}.pgm")
    cv2.imwrite(pgm_path, thresh_img)

    # Save PNG image (For easy viewing by the user)
    png_path = os.path.join(output_dir, f"{base_name}_preview.png")
    cv2.imwrite(png_path, thresh_img)

    # Calculate origin (usually meaning that the center of the image is at (0,0) in ROS world coordinates)
    height, width = thresh_img.shape
    origin_x = -(width * resolution) / 2.0
    origin_y = -(height * resolution) / 2.0

    # Write YAML file required by nav2_map_server
    yaml_path = os.path.join(output_dir, f"{base_name}.yaml")
    map_yaml = {
        'image': f"{base_name}.pgm",
        'mode': 'trinary',
        'resolution': resolution,
        'origin': [origin_x, origin_y, 0.0],
        'negate': 0,
        'occupied_thresh': 0.65,
        'free_thresh': 0.25
    }

    with open(yaml_path, 'w') as f:
        yaml.dump(map_yaml, f, default_flow_style=False, sort_keys=False)

    print(f"✅ Success! Map files generated:")
    print(f"  - {pgm_path}")
    print(f"  - {yaml_path}")
    return True

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Convert Floor Plan Image to ROS 2 Map format.")
    parser.add_argument('--image', required=True, help='Path to the input floor plan image (png, jpg, etc.)')
    parser.add_argument('--out', default='.', help='Output directory for the .pgm and .yaml files')
    parser.add_argument('--res', type=float, default=0.05, help='Resolution (meters/pixel). Default 0.05')
    
    args = parser.parse_args()
    
    # Ensure output directory exists
    os.makedirs(args.out, exist_ok=True)
    
    convert_image_to_map(args.image, args.out, args.res)
