import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_pending_connections_usecase.dart';
import '../../domain/usecases/get_connected_companions_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';

abstract class CompanionStatusState {}

class CompanionStatusInitial extends CompanionStatusState {}
class CompanionStatusLoading extends CompanionStatusState {}
class CompanionStatusPending extends CompanionStatusState {}
class CompanionStatusAccepted extends CompanionStatusState {}
class CompanionStatusRejected extends CompanionStatusState {}
class CompanionStatusError extends CompanionStatusState {
  final String message;
  CompanionStatusError(this.message);
}
class CompanionStatusSendingRequest extends CompanionStatusState {}
class CompanionStatusRequestSuccess extends CompanionStatusState {
  final String message;
  CompanionStatusRequestSuccess(this.message);
}
class CompanionStatusRequestError extends CompanionStatusState {
  final String message;
  CompanionStatusRequestError(this.message);
}

class CompanionStatusCubit extends Cubit<CompanionStatusState> {
  final GetPendingConnectionsUseCase getPendingConnectionsUseCase;
  final GetConnectedCompanionsUseCase getConnectedCompanionsUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;

  CompanionStatusCubit({
    required this.getPendingConnectionsUseCase,
    required this.getConnectedCompanionsUseCase,
    required this.sendConnectionRequestUseCase,
  }) : super(CompanionStatusInitial());

  Future<void> fetchStatus() async {
    emit(CompanionStatusLoading());
    try {
      final pendingResult = await getPendingConnectionsUseCase();
      pendingResult.fold(
        (failure) => emit(CompanionStatusError(failure.message)),
        (connections) {
          if (connections.isEmpty) {
            emit(CompanionStatusRejected());
          } else {
            // Check status of first connection
            final connection = connections.first;
            if (connection.status == 'pending') {
              emit(CompanionStatusPending());
            } else {
              emit(CompanionStatusRejected());
            }
          }
        },
      );
    } catch (e) {
      emit(CompanionStatusError(e.toString()));
    }
  }

  Future<void> sendRequest(String targetUsername) async {
    emit(CompanionStatusSendingRequest());
    try {
      final result = await sendConnectionRequestUseCase(targetUsername);
      result.fold(
        (failure) {
          emit(CompanionStatusRequestError(failure.message));
          emit(CompanionStatusRejected());
        },
        (message) {
          emit(CompanionStatusRequestSuccess(message));
          // Fetch status again after successful request
          fetchStatus();
        },
      );
    } catch (e) {
      emit(CompanionStatusRequestError(e.toString()));
      emit(CompanionStatusRejected());
    }
  }
}
