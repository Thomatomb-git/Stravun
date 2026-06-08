import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/community_provider.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/community/post_card.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';

class ForumTab extends StatefulWidget {
  const ForumTab({super.key});

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<CommunityProvider>().loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<CommunityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingForum && provider.posts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accentNeon),
            );
          }

          if (provider.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: AppConstants.stackMd),
                  Text(
                    'No posts yet. Be the first to share!',
                    style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.accentNeon,
            backgroundColor: AppColors.backgroundSurface,
            onRefresh: () async {
              await provider.fetchPosts();
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(
                left: AppConstants.gutter,
                right: AppConstants.gutter,
                top: AppConstants.stackMd,
                bottom: 100, // Padding for FAB and Bottom Nav
              ),
              itemCount: provider.posts.length + (provider.hasMorePosts ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppConstants.stackLg),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.accentNeon),
                    ),
                  );
                }

                final post = provider.posts[index];
                return PostCard(
                  post: post,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostDetailScreen(post: post)),
                    );
                  },
              );
            },
          ),
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreatePostScreen()),
        );
      },
      backgroundColor: AppColors.accentNeon,
        foregroundColor: AppColors.backgroundPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
