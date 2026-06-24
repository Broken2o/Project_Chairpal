import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import '../cubit/chats_cubit.dart';
import 'chat_screen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatsCubit>().fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        leading: const CustomBackButton(),
        centerTitle: true,
        title: Text(
          S.of(context)!.chatsTitle,
          style: AppStyles.h3PrimaryDark,
        ),
      ),
      body: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsError) {
            return Center(child: Text(state.message));
          } else if (state is ChatsLoaded) {
            if (state.chats.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context)!.noChatsYet,
                      style: AppStyles.h3PrimaryDark.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ChatsCubit>().fetchChats();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(24.0),
                itemCount: state.chats.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.shimmer,
                      backgroundImage: chat.partner.image != null ? NetworkImage(chat.partner.image!) : null,
                      child: chat.partner.image == null ? const Icon(Icons.person, color: Colors.grey) : null,
                    ),
                    title: Text(
                      chat.partner.name,
                      style: AppStyles.h4PrimaryDark.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        chat.lastMessage?.content ?? '',
                        style: TextStyle(
                          color: chat.unreadCount > 0 ? AppColors.primaryDark : Colors.grey[600],
                          fontWeight: chat.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chat.lastMessage?.createdAt ?? '',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        if (chat.unreadCount > 0) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(partner: chat.partner),
                        ),
                      ).then((_) {
                        context.read<ChatsCubit>().fetchChats();
                      });
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
