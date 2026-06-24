import '../../../data/models/user_dashboard_model.dart';
import '../../../data/models/doctor_dashboard_model.dart';
import '../../../data/models/admin_dashboard_model.dart';

abstract class HomeDashboardState {}

class HomeDashboardInitial extends HomeDashboardState {}

class HomeDashboardLoading extends HomeDashboardState {}

class HomeDashboardLoaded extends HomeDashboardState {
  final UserDashboardModel dashboard;

  HomeDashboardLoaded(this.dashboard);
}

class DoctorDashboardLoaded extends HomeDashboardState {
  final DoctorDashboardModel dashboard;

  DoctorDashboardLoaded(this.dashboard);
}

// Assuming Companion might use same model or different
class CompanionDashboardLoaded extends HomeDashboardState {
  final UserDashboardModel dashboard;

  CompanionDashboardLoaded(this.dashboard);
}

class AdminDashboardLoaded extends HomeDashboardState {
  final AdminDashboardModel dashboard;

  AdminDashboardLoaded(this.dashboard);
}

class HomeDashboardError extends HomeDashboardState {
  final String message;

  HomeDashboardError(this.message);
}
