from launch import LaunchDescription
from launch_ros.actions import Node
from launch.substitutions import PathJoinSubstitution
from launch_ros.substitutions import FindPackageShare


def generate_launch_description():
    pkg_share = FindPackageShare('medical_wheelchair')

    ydlidar_params = PathJoinSubstitution([
        pkg_share,
        'config',
        'ydlidar_x2.yaml'
    ])

    lidar_node = Node(
        package='ydlidar_ros2_driver',
        executable='ydlidar_ros2_driver_node',
        name='ydlidar_ros2_driver_node',
        output='screen',
        emulate_tty=True,
        parameters=[ydlidar_params],
    )

    # Static TF: position of the lidar on the wheelchair frame.
    # NOTE: We do NOT apply pitch=pi here because reversion+inverted in
    # ydlidar_x2.yaml already correct the upside-down scan at driver level.
    # Applying another 180-degree flip here would double-invert the data.
    #
    # ⚠️  Tune the z value (0.3 m) to the actual mounting height of the
    #     lidar above the base_link origin on your physical wheelchair.
    #     x/y offsets default to 0 (centred); adjust if the lidar is off-centre.
    tf_node = Node(
        package='tf2_ros',
        executable='static_transform_publisher',
        name='lidar_tf',
        arguments=[
            # x      y    z       roll  pitch  yaw
            '0.23', '0', '0.21', '0',  '0',   '0',
            'base_link',   # parent frame
            'laser_frame'  # lidar child frame
        ],
    )

    return LaunchDescription([
        lidar_node,
        tf_node,
    ])
