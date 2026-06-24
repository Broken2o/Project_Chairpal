from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import PathJoinSubstitution
from launch_ros.actions import Node
from launch_ros.substitutions import FindPackageShare

def generate_launch_description():
    pkg_share = FindPackageShare('medical_wheelchair')

    # تشغيل الليدار والـ Static TF
    lidar_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            PathJoinSubstitution([pkg_share, 'launch', 'lidar_launch.py'])
        ])
    )

    # تشغيل الـ Serial Bridge (الربط مع الأردوينو)
    serial_bridge_node = Node(
        package='medical_wheelchair',
        executable='serial_bridge_node',
        name='serial_bridge_node',
        output='screen',
        parameters=[{'use_sim_time': False}]
    )

    return LaunchDescription([
        lidar_launch,
        serial_bridge_node
    ])
