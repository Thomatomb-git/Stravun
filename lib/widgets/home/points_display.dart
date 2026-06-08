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
      padding: const EdgeInsets.symmetric(vertical: AppConstants.sectionGap),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.star,
            color: AppColors.accentNeon,
            size: 48,
            shadows: [
              Shadow(
                color: AppColors.accentNeon.withValues(alpha: 0.5),
                blurRadius: 20,
              )
            ],
          ),
          const SizedBox(height: AppConstants.stackSm),
          Text(
            points.toString(),
            style: AppTextStyles.displayStat,
          ),
          const SizedBox(height: 4),
          Text(
            'TOTAL POINTS',
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
