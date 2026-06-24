import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../core/theme/app_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/community_cubit.dart';
import '../widgets/create_post_input.dart';
import '../widgets/post_card.dart';
import '../widgets/empty_posts_state.dart';
import '../../../chat/presentation/screens/chats_list_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<CommunityCubit>().fetchMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context)!.myCommunity,
          style: AppStyles.h3PrimaryDark,
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.forum_outlined, color: AppColors.primaryDark, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatsListScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8.w,
                top: 12.h,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '1',
                    style: AppStyles.badge,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CommunityCubit>().fetchPosts();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(24.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreatePostInput(),
              SizedBox(height: 32.h),
              Text(
                S.of(context)!.recommendedPosts,
                style: AppStyles.h3Primary,
              ),
              SizedBox(height: 16.h),
              BlocBuilder<CommunityCubit, CommunityState>(
                builder: (context, state) {
                  if (state is CommunityLoading && context.read<CommunityCubit>().state is! CommunityLoaded) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.r),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is CommunityError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.r),
                        child: Text(state.message),
                      ),
                    );
                  } else if (state is CommunityLoaded) {
                    if (state.posts.isEmpty) {
                      return const EmptyPostsState();
                    }
                    return Column(
                      children: [
                        ...state.posts.map((post) => PostCard(post: post)),
                        if (context.read<CommunityCubit>().isFetchingMore)
                          Padding(
                            padding: EdgeInsets.all(16.r),
                            child: const Center(child: CircularProgressIndicator()),
                          )
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
