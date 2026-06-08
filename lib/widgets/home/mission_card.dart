import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/mission_model.dart';
import '../common/progress_bar.dart';

class MissionCard extends StatelessWidget {
  final String tier; // 'bronze', 'silver', 'gold'
  final MissionDefinition mission;
  final double progress;
  final bool completed;

  const MissionCard({
    super.key,
    required this.tier,
    required this.mission,
    required this.progress,
    required this.completed,
  });

  Color _getTierColor() {
    switch (tier) {
      case 'bronze': return AppColors.tierBronze;
      case 'silver': return AppColors.tierSilver;
      case 'gold': return AppColors.tierGold;
      default: return AppColors.textSecondary;
    }
  }

  int _getPoints() {
    switch (tier) {
      case 'bronze': return AppConstants.bronzePoints;
      case 'silver': return AppConstants.silverPoints;
      case 'gold': return AppConstants.goldPoints;
      default: return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTierColor();
    final points = _getPoints();
    final progressRatio = mission.targetValue > 0 ? (progress / mission.targetValue) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.stackMd),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: completed ? Border.all(color: color.withValues(alpha: 0.5), width: 1) : null,
      ),
      child: Row(
        children: [
          // Left Accent Stripe
          Container(
            width: 8,
            height: 80,
            color: color,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.stackMd),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: completed
                        ? Icon(Icons.check, color: color)
                        : Icon(Icons.flag, color: color),
                  ),
                  const SizedBox(width: AppConstants.stackMd),
                  
                  // Description & Progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.description,
                          style: AppTextStyles.labelMd.copyWith(
                            decoration: completed ? TextDecoration.lineThrough : null,
                            color: completed ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ProgressBar(
                          progress: progressRatio,
                          fillColor: color,
                          height: 6,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: AppConstants.stackMd),
                  
                  // Points
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundPrimary,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: Text(
                      '+$points pts',
                      style: AppTextStyles.labelSm.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
