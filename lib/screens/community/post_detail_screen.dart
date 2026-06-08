import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/post_model.dart';
import '../../providers/community_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/community/post_card.dart';
import '../../widgets/common/user_avatar.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Fetch comments immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().fetchComments(widget.post.id);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      await context.read<CommunityProvider>().addComment(widget.post.id, text);
      if (!mounted) return;
      _commentController.clear();
      FocusScope.of(context).unfocus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post comment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.userModel;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        title: const Text('Post'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.gutter),
                    child: PostCard(
                      post: widget.post,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppConstants.gutter,
                      AppConstants.stackMd,
                      AppConstants.gutter,
                      AppConstants.stackSm,
                    ),
                    child: Text(
                      'Comments',
                      style: AppTextStyles.bodyLg,
                    ),
                  ),
                ),
                Consumer<CommunityProvider>(
                  builder: (context, provider, child) {
                    final comments = provider.comments;
                    
                    if (provider.isLoadingForum && comments.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppConstants.sectionGap),
                            child: CircularProgressIndicator(color: AppColors.accentNeon),
                          ),
                        ),
                      );
                    }

                    if (comments.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppConstants.sectionGap),
                            child: Text(
                              'No comments yet. Be the first to reply!',
                              style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final comment = comments[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.gutter,
                              vertical: AppConstants.stackSm,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserAvatar(
                                  username: comment.username,
                                  imageUrl: comment.userProfilePicUrl.isNotEmpty ? comment.userProfilePicUrl : null,
                                  size: 32,
                                ),
                                const SizedBox(width: AppConstants.stackSm),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundSurface,
                                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              comment.username,
                                              style: AppTextStyles.labelMd.copyWith(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              timeago.format(comment.createdAt),
                                              style: AppTextStyles.labelSm.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comment.content,
                                          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: comments.length,
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.sectionGap),
                ),
              ],
            ),
          ),
          
          // Bottom Comment Input
          if (user != null)
            Container(
              padding: const EdgeInsets.all(AppConstants.stackSm),
              decoration: const BoxDecoration(
                color: AppColors.backgroundSurface,
                border: Border(top: BorderSide(color: AppColors.backgroundPrimary)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    UserAvatar(
                      username: user.username,
                      imageUrl: user.profilePicUrl.isNotEmpty ? user.profilePicUrl : null,
                      size: 36,
                    ),
                    const SizedBox(width: AppConstants.stackSm),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppColors.backgroundPrimary,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.stackSm),
                    _isSubmitting
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: AppColors.accentNeon, strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send, color: AppColors.accentNeon),
                            onPressed: _submitComment,
                          ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
