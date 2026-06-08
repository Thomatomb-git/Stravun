import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/user_model.dart';
import '../../providers/community_provider.dart';
import '../common/user_avatar.dart';

class LeaderboardListItem extends StatelessWidget {
  final UserModel user;
  final int rank;
  final LeaderboardCategory category;
  final bool isCurrentUser;

  const LeaderboardListItem({
    super.key,
    required this.user,
    required this.rank,
    required this.category,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.gutter, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.accentNeon.withValues(alpha: 0.1) : Colors.transparent,
        border: isCurrentUser ? Border.all(color: AppColors.accentNeon.withValues(alpha: 0.5)) : null,
        borderRadius: isCurrentUser ? BorderRadius.circular(AppConstants.radiusMd) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '$rank',
              style: AppTextStyles.labelMd.copyWith(
                color: isCurrentUser ? AppColors.accentNeon : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          UserAvatar(
            username: user.username,
            imageUrl: user.profilePicUrl.isNotEmpty ? user.profilePicUrl : null,
            size: 40,
          ),
          const SizedBox(width: AppConstants.stackMd),
          Expanded(
            child: Text(
              user.username,
              style: AppTextStyles.bodyLg.copyWith(
                color: isCurrentUser ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _getStatValue(),
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatValue() {
    switch (category) {
      case LeaderboardCategory.totalPoints:
        return '${user.totalPoints} pts';
      case LeaderboardCategory.loginStreak:
        return '${user.loginStreak} days';
      case LeaderboardCategory.weeklyDistance:
        return '${user.weeklyDistance.toStringAsFixed(1)} km';
    }
  }
}
