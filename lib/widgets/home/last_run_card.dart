import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/run_model.dart';
import '../common/section_header.dart';
import '../common/stat_card.dart';

class LastRunCard extends StatelessWidget {
  final RunModel? run;

  const LastRunCard({
    super.key,
    this.run,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Last Run',
          actionText: 'VIEW HISTORY',
          onAction: () {
            // Navigate to history (future phase)
          },
        ),
        const SizedBox(height: AppConstants.stackMd),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.stackMd),
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface,
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          child: run == null
              ? _buildEmptyState()
              : _buildRunStats(run!),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.stackLg),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.directions_run, color: AppColors.textSecondary, size: 48),
            const SizedBox(height: AppConstants.stackMd),
            Text(
              'Start your first run! 🏃',
              style: AppTextStyles.bodyLg.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunStats(RunModel currentRun) {
    return Column(
      children: [
        // Placeholder for map thumbnail
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundPrimary,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            gradient: RadialGradient(
              colors: [
                AppColors.accentNeon.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              radius: 0.8,
            )
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundSurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.stackLg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCol('Distance', currentRun.distance.toStringAsFixed(1), 'km'),
            _buildVerticalDivider(),
            _buildStatCol('Duration', '${currentRun.duration ~/ 60}', 'min'),
            _buildVerticalDivider(),
            _buildStatCol('Calories', '${currentRun.calories}', 'kcal'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCol(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: AppTextStyles.headlineMd,
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: AppColors.borderMuted,
    );
  }
}
