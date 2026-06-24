import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/ros_repository.dart';
import 'accessibility_state.dart';

class AccessibilityCubit extends Cubit<AccessibilityState> {
  final AccessibilityRepository _repository;
  StreamSubscription? _statusSubscription;

  AccessibilityCubit({required AccessibilityRepository repository})
      : _repository = repository,
        super(AccessibilityInitial()) {
    _statusSubscription = _repository.statusStream.listen((status) {
      emit(AccessibilityStatusUpdate(status: status));
    });
  }

  void connect(String url) {
    _repository.connect(url);
  }

  void moveForward() {
    _repository.publishVelocity(linearX: 1.0, angularZ: 0.0);
  }

  void moveBackward() {
    _repository.publishVelocity(linearX: -1.0, angularZ: 0.0);
  }

  void turnLeft() {
    _repository.publishVelocity(linearX: 0.0, angularZ: 0.5);
  }

  void turnRight() {
    _repository.publishVelocity(linearX: 0.0, angularZ: -0.5);
  }

  void stop() {
    _repository.publishVelocity(linearX: 0.0, angularZ: 0.0);
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    _repository.disconnect();
    return super.close();
  }
}
