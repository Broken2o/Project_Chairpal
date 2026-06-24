import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

/// Status enums.
enum Status { none, connecting, connected, closed, errored }

class Ros {
  Ros({this.url, this.headers}) {
    _statusController = StreamController<Status>.broadcast();
  }

  dynamic url;
  Map<String, dynamic>? headers;

  int subscribers = 0;
  int advertisers = 0;
  int publishers = 0;
  int serviceCallers = 0;

  int get ids => subscribers + advertisers + publishers + serviceCallers;

  WebSocketChannel? _channel;
  StreamSubscription? _channelListener;
  Stream<Map<String, dynamic>>? stream;
  late StreamController<Status> _statusController;

  Stream<Status> get statusStream => _statusController.stream;
  Status status = Status.none;

  void connect({dynamic url}) async {
    this.url = url ?? this.url;
    url ??= this.url;
    
    try {
      // print('Connecting to ROS at $url with headers: $headers');
      // Create custom WebSocket with headers
      final ws = await WebSocket.connect(
        url,
        headers: headers,
      );
      ws.pingInterval = const Duration(seconds: 5);
      
      _channel = IOWebSocketChannel(ws);

      stream = _channel!.stream.asBroadcastStream().map((raw) {
        // print('ROS Received: $raw');
        return json.decode(raw);
      });
      
      status = Status.connected;
      _statusController.add(status);

      _channelListener = stream!.listen((data) {
        // print('ROS Stream Data: $data');
        if (status != Status.connected) {
          status = Status.connected;
          _statusController.add(status);
        }
      }, onError: (error) {
        // print('ROS Stream Error: $error');
        status = Status.errored;
        _statusController.add(status);
      }, onDone: () {
        // print('ROS Stream Done (Closed)');
        status = Status.closed;
        _statusController.add(status);
      });
    } catch (e) {
      // print('ROS Connection Exception: $e');
      status = Status.errored;
      _statusController.add(status);
    }
  }

  Future<void> close([int? code, String? reason]) async {
    await _channelListener?.cancel();
    await _channel?.sink.close(code, reason);
    status = Status.closed;
    _statusController.add(status);
  }

  bool send(dynamic message) {
    if (status != Status.connected) return false;
    final toSend = (message is Map || message is List)
        ? json.encode(message)
        : message;
    _channel?.sink.add(toSend);
    return true;
  }

  String requestSubscriber(String name) {
    subscribers++;
    return 'subscribe:$name:${ids.toString()}';
  }

  String requestAdvertiser(String name) {
    advertisers++;
    return 'advertise:$name:${ids.toString()}';
  }

  String requestPublisher(String name) {
    publishers++;
    return 'publish:$name:${ids.toString()}';
  }

  String requestServiceCaller(String name) {
    serviceCallers++;
    return 'call_service:$name:${ids.toString()}';
  }
}

class Topic {
  Topic({
    required this.ros,
    required this.name,
    required this.type,
    this.reconnectOnClose = true,
  });

  Ros ros;
  String name;
  String type;
  String? subscribeId;
  String? advertiseId;
  bool reconnectOnClose;

  bool get isAdvertised => advertiseId != null;

  Future<void> publish(dynamic message) async {
    await advertise();
    ros.send({
      'op': 'publish',
      'topic': name,
      'id': ros.requestPublisher(name),
      'msg': message,
    });
  }

  Future<void> advertise() async {
    if (!isAdvertised) {
      advertiseId = ros.requestAdvertiser(name);
      ros.send({
        'op': 'advertise',
        'id': advertiseId,
        'type': type,
        'topic': name,
      });
    }
  }

  Future<void> unadvertise() async {
    if (isAdvertised) {
      ros.send({
        'op': 'unadvertise',
        'id': advertiseId,
        'topic': name,
      });
      advertiseId = null;
    }
  }
}
