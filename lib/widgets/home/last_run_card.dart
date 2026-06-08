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
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundPrimary,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: const Center(
            child: Icon(Icons.map_outlined, color: AppColors.textSecondary, size: 32),
          ),
        ),
        const SizedBox(height: AppConstants.stackMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.route,
                value: currentRun.distance.toStringAsFixed(2),
                label: 'km',
              ),
            ),
            const SizedBox(width: AppConstants.stackSm),
            Expanded(
              child: StatCard(
                icon: Icons.timer,
                value: '${currentRun.duration ~/ 60}',
                label: 'min',
              ),
            ),
            const SizedBox(width: AppConstants.stackSm),
            Expanded(
              child: StatCard(
                icon: Icons.local_fire_department,
                value: '${currentRun.calories}',
                label: 'kcal',
              ),
            ),
            const SizedBox(width: AppConstants.stackSm),
            Expanded(
              child: StatCard(
                icon: Icons.speed,
                value: currentRun.pace.toStringAsFixed(1),
                label: 'min/km',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
