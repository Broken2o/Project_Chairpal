import '../../domain/entities/connection_entity.dart';
import '../../../auth/data/models/user_model.dart';

class ConnectionModel extends ConnectionEntity {
  const ConnectionModel({
    required super.id,
    super.senderId,
    super.receiverId,
    super.connectionType,
    required super.status,
    super.sender,
    super.receiver,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      connectionType: json['connection_type'],
      status: json['status'] ?? 'accepted', // Default to accepted if missing (like in companions list)
      sender: json['sender'] != null ? UserModel.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null ? UserModel.fromJson(json['receiver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'connection_type': connectionType,
      'status': status,
      'sender': sender != null ? (sender as UserModel).toJson() : null,
      'receiver': receiver != null ? (receiver as UserModel).toJson() : null,
    };
  }
}
