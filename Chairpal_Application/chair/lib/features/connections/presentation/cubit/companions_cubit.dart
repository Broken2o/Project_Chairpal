import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/connection_entity.dart';
import '../../domain/usecases/get_pending_connections_usecase.dart';
import '../../domain/usecases/get_connected_companions_usecase.dart';
import '../../domain/usecases/handle_connection_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';

abstract class CompanionsState {}

class CompanionsInitial extends CompanionsState {}
class CompanionsLoading extends CompanionsState {}
class CompanionsLoaded extends CompanionsState {
  final List<User> companions;
  final List<ConnectionEntity> pendingRequests;

  CompanionsLoaded({required this.companions, required this.pendingRequests});
}
class CompanionsError extends CompanionsState {
  final String message;
  CompanionsError(this.message);
}

class CompanionsCubit extends Cubit<CompanionsState> {
  final GetPendingConnectionsUseCase getPendingConnectionsUseCase;
  final GetConnectedCompanionsUseCase getConnectedCompanionsUseCase;
  final HandleConnectionUseCase handleConnectionUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;

  CompanionsCubit({
    required this.getPendingConnectionsUseCase,
    required this.getConnectedCompanionsUseCase,
    required this.handleConnectionUseCase,
    required this.removeConnectionUseCase,
  }) : super(CompanionsInitial());

  Future<void> fetchCompanions() async {
    emit(CompanionsLoading());
    try {
      final companionsResult = await getConnectedCompanionsUseCase();
      final pendingResult = await getPendingConnectionsUseCase();

      List<User> companions = [];
      List<ConnectionEntity> pending = [];

      companionsResult.fold(
        (failure) => emit(CompanionsError(failure.message)),
        (data) => companions = data,
      );

      pendingResult.fold(
        (failure) {
          // ignore or handle
        },
        (data) => pending = data.where((c) => c.status == 'pending').toList(),
      );

      if (state is! CompanionsError) {
        emit(CompanionsLoaded(companions: companions, pendingRequests: pending));
      }
    } catch (e) {
      emit(CompanionsError(e.toString()));
    }
  }

  Future<void> handleConnection(int connectionId, String action) async {
    final result = await handleConnectionUseCase(connectionId, action);
    result.fold(
      (failure) => emit(CompanionsError(failure.message)),
      (_) => fetchCompanions(), // Refresh lists
    );
  }

  Future<void> removeCompanion(int userId) async {
    final result = await removeConnectionUseCase(userId);
    result.fold(
      (failure) => emit(CompanionsError(failure.message)),
      (_) => fetchCompanions(), // Refresh lists
    );
  }
}
