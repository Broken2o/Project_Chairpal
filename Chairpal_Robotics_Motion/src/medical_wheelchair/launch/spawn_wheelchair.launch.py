import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, ExecuteProcess, GroupAction, OpaqueFunction, TimerAction
from launch.conditions import IfCondition
from launch_ros.actions import Node
from launch_ros.parameter_descriptions import ParameterValue
from launch.actions import IncludeLaunchDescription
from launch.substitutions import Command, PathJoinSubstitution, FindExecutable
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch_ros.substitutions import FindPackageShare
from launch.substitutions import LaunchConfiguration


def launch_setup(context, *args, **kwargs):
    pkg_share = get_package_share_directory('medical_wheelchair')
    world_file = context.perform_substitution(LaunchConfiguration('world'))
    world_path = os.path.join(pkg_share, 'worlds', world_file)
    headless = context.perform_substitution(LaunchConfiguration('headless'))
    if headless == 'true':
        gz_args = f'-s -r {world_path}'
    else:
        gz_args = f'-r {world_path}'

    spawn_cmd = Node(
        package='ros_gz_sim',
        executable='create',
        arguments=[
            '-name', 'wheelchair',
            '-topic', 'robot_description',
            '-x', '0', '-y', '0', '-z', '0.1'
        ],
        output='screen'
    )

    return [
        Node(
            package='robot_state_publisher',
            executable='robot_state_publisher',
            name='robot_state_publisher',
            output='screen',
            parameters=[
                {'use_sim_time': True},
                {
                    'robot_description': ParameterValue(
                        Command([
                            FindExecutable(name='xacro'),
                            ' ',
                            PathJoinSubstitution([
                                FindPackageShare('medical_wheelchair'),
                                'urdf',
                                'wheelchair.xacro'
                            ]),
                        ]),
                        value_type=str,
                    ),
                },
            ]
        ),

        IncludeLaunchDescription(
            PythonLaunchDescriptionSource([
                PathJoinSubstitution([
                    FindPackageShare('ros_gz_sim'),
                    'launch',
                    'gz_sim.launch.py'
                ])
            ]),
            launch_arguments={
                'gz_args': gz_args,
            }.items()
        ),

        Node(
            package='ros_gz_bridge',
            executable='parameter_bridge',
            arguments=[
                '/clock@rosgraph_msgs/msg/Clock[gz.msgs.Clock',
                '/scan@sensor_msgs/msg/LaserScan[gz.msgs.LaserScan',
                '/joint_states@sensor_msgs/msg/JointState[gz.msgs.Model',
                '/cmd_vel@geometry_msgs/msg/Twist@gz.msgs.Twist',
                '/cmd_front_left_steer@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_front_right_steer@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_rear_left_steer@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_rear_right_steer@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_front_left_wheel@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_front_right_wheel@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_middle_left_wheel@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_middle_right_wheel@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_rear_left_wheel@std_msgs/msg/Float64]gz.msgs.Double',
                '/cmd_rear_right_wheel@std_msgs/msg/Float64]gz.msgs.Double',
                '/camera/image@sensor_msgs/msg/Image[gz.msgs.Image',
                '/camera/depth_image@sensor_msgs/msg/Image[gz.msgs.Image',
                '/camera/points@sensor_msgs/msg/PointCloud2[gz.msgs.PointCloudPacked',
                '/camera/camera_info@sensor_msgs/msg/CameraInfo[gz.msgs.CameraInfo',
                '/imu@sensor_msgs/msg/Imu[gz.msgs.IMU',
            ],
            parameters=[{'use_sim_time': True}],
            output='screen'
        ),

        Node(
            package='medical_wheelchair',
            executable='wheelchair_controller',
            name='wheelchair_controller',
            output='screen',
            parameters=[{'use_sim_time': True}]
        ),

        Node(
            package='medical_wheelchair',
            executable='scan_republisher',
            name='scan_republisher',
            output='screen',
            parameters=[{
                'use_sim_time': True,
                'input_topic': '/scan',
                'output_topic': '/scan_fixed',
                'frame_id': 'lidar_link',
                'strip_prefix': 'wheelchair/',
            }],
        ),

        TimerAction(
            period=5.0,
            actions=[spawn_cmd]
        ),

        GroupAction(
            condition=IfCondition(LaunchConfiguration('use_rviz')),
            actions=[
                TimerAction(
                    period=3.0,
                    actions=[
                        ExecuteProcess(
                            cmd=[
                                'rviz2', '-d',
                                PathJoinSubstitution([
                                    FindPackageShare('medical_wheelchair'),
                                    'rviz',
                                    'medical_wheelchair.rviz'
                                ]),
                                '--ros-args', '-p', 'use_sim_time:=true'
                            ],
                            output='screen'
                        )
                    ]
                ),
            ]
        ),

        Node(
            package='medical_wheelchair',
            executable='decision_manager',
            name='decision_manager',
            output='screen',
            parameters=[{'use_sim_time': True}]
        ),

        GroupAction(
            condition=IfCondition(LaunchConfiguration('use_vision')),
            actions=[
                ExecuteProcess(
                    cmd=[
                        'bash', '-c',
                        'source /opt/ros/humble/setup.bash && '
                        'source /home/ayadiab/chair_ws/install/setup.bash && '
                        'python3 /home/ayadiab/chair_ws/src/medical_wheelchair/medical_wheelchair/vision_node.py'
                    ],
                    output='screen'
                ),
            ]
        ),
    ]


def generate_launch_description():
    return LaunchDescription([
        DeclareLaunchArgument(
            'world',
            default_value='empty_with_sensors.sdf',
            description='World file inside share/medical_wheelchair/worlds/',
        ),
        DeclareLaunchArgument(
            'use_rviz',
            default_value='false',
            description='If true, opens RViz (heavy on weak GPUs).',
        ),
        DeclareLaunchArgument(
            'use_vision',
            default_value='false',
            description='If true, runs YOLO vision_node (very CPU/GPU heavy).',
        ),
        DeclareLaunchArgument(
            'headless',
            default_value='false',
            description='If true, runs gz sim server only (-s) without GUI (use when display hangs).',
        ),
        OpaqueFunction(function=launch_setup),
    ])
