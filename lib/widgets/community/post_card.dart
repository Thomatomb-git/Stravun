import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/post_model.dart';
import '../../providers/community_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../screens/run/run_summary_screen.dart';
import '../common/user_avatar.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final communityProvider = Provider.of<CommunityProvider>(context, listen: false);
    final isOwner = authProvider.userModel?.uid == post.userId;
    final isLiked = communityProvider.likedPostIds.contains(post.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.stackMd),
        padding: const EdgeInsets.all(AppConstants.gutter),
        decoration: BoxDecoration(
          color: AppColors.backgroundSurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                UserAvatar(
                  username: post.username,
                  imageUrl: post.userProfilePicUrl.isNotEmpty ? post.userProfilePicUrl : null,
                  size: 40,
                ),
                const SizedBox(width: AppConstants.stackSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        timeago.format(post.createdAt),
                        style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (isOwner)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                    color: AppColors.backgroundPrimary,
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog(context, communityProvider);
                      } else if (value == 'edit') {
                        _showEditDialog(context, communityProvider);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit', style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.stackMd),
            
            // Body
            if (post.content.isNotEmpty)
              Text(
                post.content,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
              ),
            
            // Media (Placeholder for images/videos)
            if (post.mediaUrls.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: AppConstants.stackMd),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  color: AppColors.backgroundPrimary,
                  image: DecorationImage(
                    image: NetworkImage(post.mediaUrls.first),
                    fit: BoxFit.cover,
                  ),
                ),
                child: post.mediaUrls.length > 1
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.all(8),
                          color: Colors.black54,
                          child: Text('+${post.mediaUrls.length - 1}'),
                        ),
                      )
                    : null,
              ),

            // Attached Run
            if (post.attachedRunId != null)
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator(color: AppColors.accentNeon)),
                  );
                  final run = await FirestoreService().getRunById(post.attachedRunId!);
                  if (context.mounted) {
                    Navigator.pop(context); // close dialog
                    if (run != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RunSummaryScreen(runModel: run, isViewOnly: true),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Run data not found')));
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: AppConstants.stackMd),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundPrimary,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    border: Border.all(color: AppColors.accentNeon.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_run, color: AppColors.accentNeon),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Attached Run',
                          style: AppTextStyles.labelMd.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: AppConstants.stackMd),
            const Divider(color: AppColors.backgroundPrimary, height: 1),
            const SizedBox(height: AppConstants.stackSm),

            // Footer
            Row(
              children: [
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.redAccent : AppColors.textSecondary,
                  count: post.likeCount,
                  label: 'Like',
                  onTap: () {
                    communityProvider.toggleLike(post.id);
                  },
                ),
                const SizedBox(width: AppConstants.stackLg),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  color: AppColors.textSecondary,
                  count: post.commentCount,
                  label: 'Comment',
                  onTap: onTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required int count,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              count > 0 ? '$count' : label,
              style: AppTextStyles.labelSm.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, CommunityProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSurface,
        title: const Text('Delete Post', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to delete this post?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.deletePost(post.id);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, CommunityProvider provider) {
    final TextEditingController editController = TextEditingController(text: post.content);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final contentLength = editController.text.length;
          final isOverLimit = contentLength > AppConstants.maxPostCharacters;
          
          return AlertDialog(
            backgroundColor: AppColors.backgroundSurface,
            title: const Text('Edit Post', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: editController,
                  maxLines: 5,
                  maxLength: AppConstants.maxPostCharacters,
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.backgroundPrimary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    counterText: '', // Hide default counter
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$contentLength/${AppConstants.maxPostCharacters}',
                    style: AppTextStyles.labelSm.copyWith(
                      color: isOverLimit ? Colors.redAccent : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL', style: TextStyle(color: AppColors.textSecondary)),
              ),
              TextButton(
                onPressed: (contentLength == 0 || isOverLimit) ? null : () async {
                  Navigator.pop(context);
                  await provider.updatePost(post.id, editController.text.trim());
                },
                child: const Text('SAVE', style: TextStyle(color: AppColors.accentNeon)),
              ),
            ],
          );
        }
      ),
    );
  }
}
