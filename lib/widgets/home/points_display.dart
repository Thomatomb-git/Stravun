import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';

class PointsDisplay extends StatelessWidget {
  final int points;

  const PointsDisplay({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Stack(
        children: [
          // Background faint star
          Positioned(
            right: -20,
            top: -20,
            bottom: -20,
            child: Icon(
              Icons.star,
              size: 180,
              color: AppColors.accentNeon.withValues(alpha: 0.1),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.accentNeon,
                      size: 24,
                    ),
                    const SizedBox(width: AppConstants.stackSm),
                    Text(
                      'Total Points',
                      style: AppTextStyles.labelMd.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.stackMd),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      points.toString(),
                      style: AppTextStyles.displayStat.copyWith(
                        color: AppColors.accentNeon,
                        fontSize: 56,
                      ),
                    ),
                    const SizedBox(width: AppConstants.stackSm),
                    Text(
                      'pts',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
