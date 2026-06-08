import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/user_model.dart';
import '../../providers/community_provider.dart';
import '../common/user_avatar.dart';

class LeaderboardPodium extends StatelessWidget {
  final List<UserModel> topUsers;
  final LeaderboardCategory category;

  const LeaderboardPodium({
    super.key,
    required this.topUsers,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    if (topUsers.isEmpty) {
      return const SizedBox(height: 160);
    }

    final hasRank1 = topUsers.isNotEmpty;
    final hasRank2 = topUsers.length > 1;
    final hasRank3 = topUsers.length > 2;

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.gutter),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rank 2 (Silver)
          if (hasRank2)
            Expanded(
              child: _buildPodiumColumn(
                user: topUsers[1],
                rank: 2,
                color: AppColors.tierSilver,
                avatarSize: 56,
                height: 120,
              ),
            )
          else
            const Expanded(child: SizedBox()),

          // Rank 1 (Gold)
          if (hasRank1)
            Expanded(
              child: _buildPodiumColumn(
                user: topUsers[0],
                rank: 1,
                color: AppColors.tierGold,
                avatarSize: 72,
                height: 160,
              ),
            ),

          // Rank 3 (Bronze)
          if (hasRank3)
            Expanded(
              child: _buildPodiumColumn(
                user: topUsers[2],
                rank: 3,
                color: AppColors.tierBronze,
                avatarSize: 56,
                height: 100,
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildPodiumColumn({
    required UserModel user,
    required int rank,
    required Color color,
    required double avatarSize,
    required double height,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
              child: UserAvatar(
                username: user.username,
                imageUrl: user.profilePicUrl.isNotEmpty ? user.profilePicUrl : null,
                size: avatarSize,
              ),
            ),
            if (rank == 1)
              const Icon(Icons.star, color: AppColors.tierGold, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user.username,
          style: AppTextStyles.labelMd.copyWith(color: AppColors.textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          _getStatValue(user),
          style: AppTextStyles.labelSm.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _getStatValue(UserModel user) {
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
