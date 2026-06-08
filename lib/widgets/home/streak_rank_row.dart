import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';

class StreakRankRow extends StatelessWidget {
  final int streakDays;
  final int rank;
  final int pointsToNext;

  const StreakRankRow({
    super.key,
    required this.streakDays,
    required this.rank,
    required this.pointsToNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Streak Card
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.stackMd),
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: AppColors.accentNeon, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Streak',
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.stackSm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      streakDays.toString(),
                      style: AppTextStyles.headlineMd,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'days',
                      style: AppTextStyles.labelMd.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppConstants.gutter),
        // Rank Card
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.stackMd),
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: AppColors.tierGold, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Global Rank',
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.stackSm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatRank(rank),
                      style: AppTextStyles.headlineMd,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  rank > 1 ? 'Just $pointsToNext pts to next rank!' : 'You are #1!',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.accentNeon,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatRank(int rank) {
    if (rank <= 0) return '-';
    if (rank % 100 >= 11 && rank % 100 <= 13) return '${rank}th';
    switch (rank % 10) {
      case 1: return '${rank}st';
      case 2: return '${rank}nd';
      case 3: return '${rank}rd';
      default: return '${rank}th';
    }
  }
}
