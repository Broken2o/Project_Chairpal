import os
from launch import LaunchDescription
from launch_ros.actions import Node
from launch_ros.parameter_descriptions import ParameterValue
from launch.substitutions import Command, FindExecutable, PathJoinSubstitution
from launch_ros.substitutions import FindPackageShare

def generate_launch_description():
    xacro_file = PathJoinSubstitution([
        FindPackageShare('medical_wheelchair'),
        'urdf',
        'wheelchair.xacro'
    ])

    return LaunchDescription([
        # Robot State Publisher
        Node(
            package='robot_state_publisher',
            executable='robot_state_publisher',
            name='robot_state_publisher',
            output='screen',
            parameters=[
                {
                    'robot_description': ParameterValue(
                        Command([FindExecutable(name='xacro'), ' ', xacro_file]),
                        value_type=str,
                    ),
                }
            ]
        ),
        # Joint State Publisher GUI (Sliders)
        Node(
            package='joint_state_publisher_gui',
            executable='joint_state_publisher_gui',
            name='joint_state_publisher_gui',
            output='screen'
        ),
        # RViz2
        Node(
            package='rviz2',
            executable='rviz2',
            name='rviz2',
            output='screen',
            # You could add your own rviz config here if you have one
            # arguments=['-d', os.path.join(pkg_share, 'rviz', 'config.rviz')]
        )
    ])
