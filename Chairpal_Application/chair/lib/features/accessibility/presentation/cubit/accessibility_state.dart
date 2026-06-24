import 'package:equatable/equatable.dart';
import '../../data/repositories/ros_repository.dart';

abstract class AccessibilityState extends Equatable {
  const AccessibilityState();

  @override
  List<Object?> get props => [];
}

class AccessibilityInitial extends AccessibilityState {}

class AccessibilityStatusUpdate extends AccessibilityState {
  final RosStatus status;
  final String? errorMessage;

  const AccessibilityStatusUpdate({required this.status, this.errorMessage});

  @override
  List<Object?> get props => [status, errorMessage];
}
