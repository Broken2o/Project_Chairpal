import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/network/api_result.dart';
import '../../../domain/usecases/send_support_message_usecase.dart';
import 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final SendSupportMessageUseCase _sendSupportMessageUseCase;

  SupportCubit({required SendSupportMessageUseCase sendSupportMessageUseCase})
      : _sendSupportMessageUseCase = sendSupportMessageUseCase,
        super(SupportInitial());

  Future<void> sendSupportMessage(String message) async {
    if (message.trim().isEmpty) return;

    emit(SupportLoading());
    final result = await _sendSupportMessageUseCase(message);

    if (result is ApiSuccess) {
      emit(SupportSuccess());
    } else if (result is ApiError) {
      emit(SupportError(result.failure.message));
    }
  }
}
