import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/run_model.dart';
import '../common/section_header.dart';
import 'package:flutter_map/flutter_map.dart';

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
        // Actual map thumbnail
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundPrimary,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          clipBehavior: Clip.hardEdge,
          child: currentRun.route.isEmpty 
            ? Center(
                child: Text('No route data', style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary)),
              )
            : FlutterMap(
                options: MapOptions(
                  initialCenter: currentRun.route.first,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.stravun',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: currentRun.route,
                        strokeWidth: 4.0,
                        color: AppColors.accentNeon,
                      ),
                    ],
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
