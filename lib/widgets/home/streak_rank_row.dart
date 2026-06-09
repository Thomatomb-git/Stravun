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
          child: Container(
            padding: const EdgeInsets.all(AppConstants.gutter),
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: Colors.yellowAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'STREAK',
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.stackLg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      streakDays.toString(),
                      style: AppTextStyles.headlineLg,
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
          child: Container(
            padding: const EdgeInsets.all(AppConstants.gutter),
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.public, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'GLOBAL RANK',
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary, letterSpacing: 1.0),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.stackLg),
                Text(
                  _formatRank(rank),
                  style: AppTextStyles.headlineLg,
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
