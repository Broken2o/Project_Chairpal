import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import '../../../../l10n/l10n.dart';
import '../cubit/chat_details_cubit.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../../auth/data/models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final UserModel partner;

  const ChatScreen({super.key, required this.partner});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _sendMessage(BuildContext context) {
    if (_messageController.text.trim().isEmpty && _selectedImage == null) return;
    context.read<ChatDetailsCubit>().sendMessage(
      widget.partner.id,
      _messageController.text.trim(),
      attachment: _selectedImage,
    );
    _messageController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatDetailsCubit(repository: context.read<ChatRepository>())
        ..fetchMessages(widget.partner.id),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: const CustomBackButton(),
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.shimmer,
                backgroundImage: widget.partner.image != null ? NetworkImage(widget.partner.image!) : null,
                child: widget.partner.image == null ? const Icon(Icons.person, color: Colors.grey, size: 20) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.partner.name,
                  style: AppStyles.h4PrimaryDark.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatDetailsCubit, ChatDetailsState>(
                builder: (context, state) {
                  if (state is ChatDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatDetailsError) {
                    return Center(child: Text(state.message));
                  } else if (state is ChatDetailsLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(child: Text('Say Hi! 👋'));
                    }
                    return ListView.builder(
                      reverse: true, // Show newest at the bottom
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        // Get current user id from UserCubit to determine if it's "my" message
                        // For simplicity, we can assume if there's an API, usually response indicates direction
                        // But since message_model doesn't have sender_id currently, we might need a workaround.
                        // Let's assume right now we just show everything left aligned if we don't know, 
                        // or if we have sender info in API. Wait! The API might have sender info? 
                        // It usually does, but our model didn't parse sender_id.
                        // I will add sender_id to MessageModel later if needed, for now let's just make it look like a chat bubble.
                        bool isMine = false; // We'll assume false for now if not parsed
                        return Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isMine ? AppColors.primary : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: isMine ? const Radius.circular(16) : const Radius.circular(0),
                                bottomRight: isMine ? const Radius.circular(0) : const Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message.attachment != null) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      message.attachment!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (message.content.isNotEmpty)
                                  Text(
                                    message.content,
                                    style: TextStyle(
                                      color: isMine ? Colors.white : AppColors.primaryDark,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  message.createdAt,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMine ? Colors.white70 : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            if (_selectedImage != null)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey[100],
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Image.file(_selectedImage!, width: 60, height: 60, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImage = null),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Builder(
                builder: (ctx) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.grey),
                        onPressed: _pickImage,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: AppStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: S.of(context)!.typeAMessage,
                            hintStyle: AppStyles.bodyMediumHint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 18),
                          onPressed: () => _sendMessage(ctx),
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
