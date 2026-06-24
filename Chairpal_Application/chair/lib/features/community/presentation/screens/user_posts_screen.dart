import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_styles.dart';
import '../../data/models/post_model.dart';
import '../widgets/post_card.dart';
import '../widgets/profile_action_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/community_repository.dart';
import '../cubit/user_posts_cubit.dart';
import '../cubit/friends_cubit.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/cubit/user_cubit/user_cubit.dart';
import '../../../auth/presentation/cubit/user_cubit/user_state.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';
import 'package:chair_pal/core/widgets/custom_snackbar.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

class UserPostsScreen extends StatefulWidget {
  final PostUser user;
  
  const UserPostsScreen({super.key, required this.user});

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserPostsCubit(
        repository: context.read<CommunityRepository>(),
      )..fetchUserPosts(widget.user.id),
      child: Builder(
        builder: (context) {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
               context.read<UserPostsCubit>().fetchMoreUserPosts(widget.user.id);
            }
          });
          return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldBackground,
            elevation: 0,
            leading: const CustomBackButton(),
            leadingWidth: 100,
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notes, color: AppColors.primaryDark, size: 28),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('1', style: AppStyles.badge),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await context.read<UserPostsCubit>().fetchUserPosts(widget.user.id);
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.shimmer,
                  child: ClipOval(
                    child: widget.user.image != null
                        ? Image.network(
                            widget.user.image!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 60, color: Colors.grey),
                          )
                        : const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.user.name,
                    style: AppStyles.h2PrimaryDark,
                ),
                const SizedBox(height: 16),
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                    final bool isMe = userState is UserLoaded && userState.user.id == widget.user.id;
                    if (isMe) return const SizedBox.shrink();
                    
                    return BlocBuilder<FriendsCubit, FriendsState>(
                      builder: (context, friendsState) {
                        String relationStatus = 'none';
                        if (friendsState is FriendsLoaded) {
                           relationStatus = context.read<FriendsCubit>().getRelationStatus(widget.user.id);
                        }
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ProfileActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          partner: UserModel(
                                            id: widget.user.id,
                                            name: widget.user.name,
                                            image: widget.user.image,
                                            username: '',
                                            email: '',
                                            role: '',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icons.chat_bubble_outline,
                                  label: S.of(context)!.messageButton,
                                  isPrimary: false,
                                ),
                              ),
                              if (relationStatus == 'none' || relationStatus == 'pending_received') ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ProfileActionButton(
                                    onPressed: () async {
                                      final result = await context.read<FriendsCubit>().sendFriendRequest(widget.user.id);
                                      if (context.mounted) {
                                        if (result != null) {
                                          CustomSnackBar.showSuccess(
                                            context: context, 
                                            message: S.of(context)!.friendRequestSentSuccess,
                                          );
                                        } else {
                                          CustomSnackBar.showError(
                                            context: context, 
                                            message: S.of(context)!.friendRequestSentFail,
                                          );
                                        }
                                      }
                                    },
                                    icon: Icons.person_add,
                                    label: S.of(context)!.addFriendButton,
                                    isPrimary: true,
                                  ),
                                ),
                              ] else if (relationStatus == 'pending_sent') ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ProfileActionButton(
                                    onPressed: () {},
                                    icon: Icons.access_time,
                                    label: S.of(context)!.pendingButton,
                                    isPrimary: true,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      S.of(context)!.postsTabTitle,
                      style: AppStyles.h3Primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<UserPostsCubit, UserPostsState>(
                  builder: (context, state) {
                    if (state is UserPostsLoading && context.read<UserPostsCubit>().state is! UserPostsLoaded) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is UserPostsError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(state.message),
                        ),
                      );
                    } else if (state is UserPostsLoaded) {
                      if (state.posts.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No posts yet'),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            ...state.posts.map((post) => PostCard(post: post)),
                            if (context.read<UserPostsCubit>().isFetchingMore)
                               const Padding(
                                 padding: EdgeInsets.all(16.0),
                                 child: Center(child: CircularProgressIndicator()),
                               )
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
      }),
    );
  }
}
