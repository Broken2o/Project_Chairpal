"""
nav_with_slam.launch.py
-----------------------
Unified launch: Gazebo simulation + SLAM Toolbox + Nav2 (A* planner + DWB controller).
Usage:
  ros2 launch medical_wheelchair nav_with_slam.launch.py
  ros2 launch medical_wheelchair nav_with_slam.launch.py use_rviz:=true world:=empty_with_sensors.sdf
"""
import os

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import (
    DeclareLaunchArgument,
    IncludeLaunchDescription,
    TimerAction,
)
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration, PathJoinSubstitution
from launch_ros.substitutions import FindPackageShare


def generate_launch_description():
    pkg_share = FindPackageShare('medical_wheelchair')
    nav2_params = PathJoinSubstitution([pkg_share, 'config', 'nav2_params.yaml'])

    # ── Arguments ────────────────────────────────────────────────────────────
    world_arg = DeclareLaunchArgument(
        'world',
        default_value='empty_with_sensors.sdf',
        description='World file inside share/medical_wheelchair/worlds/',
    )
    use_rviz_arg = DeclareLaunchArgument(
        'use_rviz',
        default_value='false',
        description='Open RViz2 with the wheelchair config',
    )
    headless_arg = DeclareLaunchArgument(
        'headless',
        default_value='false',
        description='Run Gazebo headless (no GUI)',
    )

    # ── 1. Simulation (Gazebo + robot + bridge + controller + decision_manager)
    simulation_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource([
            PathJoinSubstitution([pkg_share, 'launch', 'spawn_wheelchair.launch.py'])
        ]),
        launch_arguments={
            'world':     LaunchConfiguration('world'),
            'use_rviz':  LaunchConfiguration('use_rviz'),
            'use_vision': 'false',
            'headless':  LaunchConfiguration('headless'),
        }.items(),
    )

    # ── 2. Nav2 + SLAM (delayed to let Gazebo & robot fully spawn first) ────
    nav2_slam_launch = TimerAction(
        period=8.0,
        actions=[
            IncludeLaunchDescription(
                PythonLaunchDescriptionSource([
                    PathJoinSubstitution([pkg_share, 'launch', 'nav2_amcl.launch.py'])
                ]),
                launch_arguments={
                    'slam':        'True',         # Changed to True to use SLAM dynamically
                    'params_file': nav2_params,
                    'use_sim_time': 'true',
                    'autostart':   'true',
                }.items(),
            )
        ],
    )

    return LaunchDescription([
        world_arg,
        use_rviz_arg,
        headless_arg,
        simulation_launch,
        nav2_slam_launch,
    ])
