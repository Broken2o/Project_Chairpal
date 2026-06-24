import 'dart:async';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:flutter/foundation.dart';

class ReverbService {
  static final ReverbService _instance = ReverbService._internal();

  factory ReverbService() => _instance;

  ReverbService._internal();

  PusherChannelsFlutter? _pusher;
  final _sosEventController = StreamController<dynamic>.broadcast();
  final _movementEventController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get sosStream => _sosEventController.stream;
  Stream<dynamic> get movementStream => _movementEventController.stream;

  bool _isConnecting = false;

  Future<void> connectToReverb(String userToken, int userId) async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      _pusher = PusherChannelsFlutter.getInstance();

      await _pusher!.init(
        apiKey: "6u9v9exow3pmm1fliknu", // From .env
        cluster: "mt1",
        authEndpoint: "https://chairpal-api.duckdns.org/broadcasting/auth",
        authParams: {
          'headers': {
            'Authorization': 'Bearer $userToken',
            'Accept': 'application/json'
          }
        },
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onEvent: _onEvent,
        onSubscriptionError: _onSubscriptionError,
        onDecryptionFailure: _onDecryptionFailure,
        onMemberAdded: _onMemberAdded,
        onMemberRemoved: _onMemberRemoved,
      );

      await _pusher!.connect();
      debugPrint("Connected to Reverb Successfully!");

      // Subscribe to SOS channel
      await _pusher!.subscribe(
        channelName: "private-user.$userId",
      );

    } catch (e) {
      debugPrint("REVERB CONNECTION ERROR: $e");
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> subscribeToWheelchair(int wheelchairId) async {
    if (_pusher == null) return;
    try {
      await _pusher!.subscribe(
        channelName: "private-wheelchair.$wheelchairId.location",
      );
    } catch (e) {
      debugPrint("ERROR subscribing to wheelchair: $e");
    }
  }

  void _onEvent(PusherEvent event) {
    debugPrint("onEvent: ${event.eventName}");
    if (event.eventName == "App\\Events\\SosTriggered") {
      debugPrint("🚨 SOS ALERT RECEIVED: ${event.data}");
      _sosEventController.add(event.data);
    } else if (event.eventName == "MovementUpdate") {
      debugPrint("📍 New Location: ${event.data}");
      _movementEventController.add(event.data);
    }
  }

  void _onConnectionStateChange(dynamic currentState, dynamic previousState) {
    debugPrint("Connection: $currentState");
  }

  void _onError(String message, int? code, dynamic e) {
    debugPrint("onError: $message code: $code exception: $e");
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    debugPrint("onSubscriptionSucceeded: $channelName data: $data");
  }

  void _onSubscriptionError(String message, dynamic e) {
    debugPrint("onSubscriptionError: $message Exception: $e");
  }

  void _onDecryptionFailure(String event, String reason) {
    debugPrint("onDecryptionFailure: $event reason: $reason");
  }

  void _onMemberAdded(String channelName, PusherMember member) {
    debugPrint("onMemberAdded: $channelName member: $member");
  }

  void _onMemberRemoved(String channelName, PusherMember member) {
    debugPrint("onMemberRemoved: $channelName member: $member");
  }

  Future<void> disconnect() async {
    if (_pusher != null) {
      await _pusher!.disconnect();
      _pusher = null;
    }
  }
}
