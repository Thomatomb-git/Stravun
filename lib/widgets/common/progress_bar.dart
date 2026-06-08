import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color fillColor;
  final String? label;
  final double height;

  const ProgressBar({
    super.key,
    required this.progress,
    required this.fillColor,
    this.label,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp progress between 0.0 and 1.0
    final validProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.borderMuted,
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: validProgress,
                child: Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
