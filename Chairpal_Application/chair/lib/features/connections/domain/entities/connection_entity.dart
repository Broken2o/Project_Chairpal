import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class ConnectionEntity extends Equatable {
  final int id;
  final int? senderId;
  final int? receiverId;
  final String? connectionType;
  final String status;
  final User? sender;
  final User? receiver;

  const ConnectionEntity({
    required this.id,
    this.senderId,
    this.receiverId,
    this.connectionType,
    required this.status,
    this.sender,
    this.receiver,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        connectionType,
        status,
        sender,
        receiver,
      ];
}
