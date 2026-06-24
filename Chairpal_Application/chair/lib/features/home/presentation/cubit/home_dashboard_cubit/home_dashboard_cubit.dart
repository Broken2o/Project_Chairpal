import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/get_user_dashboard_usecase.dart';
import 'home_dashboard_state.dart';

class HomeDashboardCubit extends Cubit<HomeDashboardState> {
  final GetUserDashboardUseCase _getUserDashboardUseCase;

  HomeDashboardCubit({required GetUserDashboardUseCase getUserDashboardUseCase})
      : _getUserDashboardUseCase = getUserDashboardUseCase,
        super(HomeDashboardInitial());

  Future<void> fetchDashboard(int userId, String role, {String? filter}) async {
    emit(HomeDashboardLoading());
    final result = await _getUserDashboardUseCase(userId, role, filter: filter);

    if (isClosed) return;
    if (result is ApiSuccess) {
      final data = result.data;
      if (role == 'doctor') {
        emit(DoctorDashboardLoaded(data));
      } else if (role == 'companion') {
        emit(CompanionDashboardLoaded(data));
      } else if (role == 'org-admin') {
        emit(AdminDashboardLoaded(data));
      } else {
        emit(HomeDashboardLoaded(data));
      }
    } else if (result is ApiError) {
      emit(HomeDashboardError(result.failure.message));
    }
  }
}
