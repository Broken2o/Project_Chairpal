import 'dart:async';
import 'dart:developer' as developer;
import '../../../../core/ros_utils/custom_ros.dart';

abstract class AccessibilityRepository {
  void connect(String url);
  void disconnect();
  void publishVelocity({double linearX = 0.0, double angularZ = 0.0});
  Stream<RosStatus> get statusStream;
  void dispose();
}

enum RosStatus { connected, disconnected, connecting, error }

class RosRepositoryImpl implements AccessibilityRepository {
  Ros? _ros;
  Topic? _cmdVelTopic;
  StreamSubscription? _statusSubscription;

  final _statusController = StreamController<RosStatus>.broadcast();

  @override
  Stream<RosStatus> get statusStream => _statusController.stream;

  @override
  void connect(String url) {
    if (_ros != null) {
      developer.log('Already connecting or connected.', name: 'RosRepository');
      return;
    }

    _statusController.add(RosStatus.connecting);

    _ros = Ros(
      url: url,
      headers: {
        'ngrok-skip-browser-warning': 'true',
        'Bypass-Tunnel-Reminder': 'true',
      },
    );

    _statusSubscription = _ros!.statusStream.listen((status) {
      switch (status) {
        case Status.connected:
          developer.log('ROS connected', name: 'RosRepository');
          _statusController.add(RosStatus.connected);
          _setupTopic();
          break;
        case Status.closed:
          developer.log('ROS connection closed', name: 'RosRepository');
          _statusController.add(RosStatus.disconnected);
          break;
        case Status.errored:
          developer.log('ROS error', name: 'RosRepository');
          _statusController.add(RosStatus.error);
          break;
        case Status.none:
          _statusController.add(RosStatus.disconnected);
          break;
        case Status.connecting:
          _statusController.add(RosStatus.connecting);
          break;
      }
    });

    _ros!.connect();
  }

  void _setupTopic() {
    final currentRos = _ros;
    if (currentRos == null) return;

    _cmdVelTopic = Topic(
      ros: currentRos,
      name: '/cmd_vel',
      type: 'geometry_msgs/Twist',
    );

    _cmdVelTopic!.advertise();
  }

  @override
  void disconnect() {
    _statusSubscription?.cancel();
    _statusSubscription = null;

    _cmdVelTopic?.unadvertise();
    _cmdVelTopic = null;

    _ros?.close();
    _ros = null;

    _statusController.add(RosStatus.disconnected);
  }

  @override
  void publishVelocity({double linearX = 0.0, double angularZ = 0.0}) {
    final currentTopic = _cmdVelTopic;
    if (_ros == null || currentTopic == null) {
      developer.log('Cannot publish: ROS not connected or topic not advertised', name: 'RosRepository');
      return;
    }

    final twist = {
      'linear': {'x': linearX, 'y': 0.0, 'z': 0.0},
      'angular': {'x': 0.0, 'y': 0.0, 'z': angularZ},
    };

    currentTopic.publish(twist);
    developer.log('Published velocity: linearX=$linearX, angularZ=$angularZ', name: 'RosRepository');
  }

  @override
  void dispose() {
    disconnect();
    _statusController.close();
  }
}