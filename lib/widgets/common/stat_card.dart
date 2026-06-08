import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';

class StatCard extends StatelessWidget {
  final dynamic icon; // IconData or Widget
  final String value;
  final String label;
  final Color? valueColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.stackMd),
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon is IconData)
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 20,
            )
          else if (icon is Widget)
            icon,
          const SizedBox(height: AppConstants.stackSm),
          Text(
            value,
            style: AppTextStyles.headlineMd.copyWith(
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
