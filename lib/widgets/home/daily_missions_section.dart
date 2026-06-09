import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/mission_model.dart';

import 'mission_card.dart';

class DailyMissionsSection extends StatelessWidget {
  final MissionCycle? missionCycle;
  final UserMissionProgress? missionProgress;

  const DailyMissionsSection({
    super.key,
    this.missionCycle,
    this.missionProgress,
  });

  @override
  Widget build(BuildContext context) {
    if (missionCycle == null) {
      return const SizedBox.shrink(); // Hide if no data
    }

    final durationLeft = missionCycle!.cycleEndDate.difference(DateTime.now());
    final hoursLeft = durationLeft.inHours;
    final String subtitle;
    if (hoursLeft > 0) {
      subtitle = 'Resets in $hoursLeft hr';
    } else {
      final minsLeft = durationLeft.inMinutes;
      subtitle = minsLeft > 0 ? 'Resets in $minsLeft min' : 'Resets soon';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Daily Missions', style: AppTextStyles.headlineMd),
            Text(
              subtitle,
              style: AppTextStyles.labelSm.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.stackMd),
        
        MissionCard(
          tier: 'bronze',
          mission: missionCycle!.bronzeMission,
          progress: missionProgress?.bronzeProgress ?? 0.0,
          completed: missionProgress?.bronzeCompleted ?? false,
        ),
        
        MissionCard(
          tier: 'silver',
          mission: missionCycle!.silverMission,
          progress: missionProgress?.silverProgress ?? 0.0,
          completed: missionProgress?.silverCompleted ?? false,
        ),
        
        MissionCard(
          tier: 'gold',
          mission: missionCycle!.goldMission,
          progress: missionProgress?.goldProgress ?? 0.0,
          completed: missionProgress?.goldCompleted ?? false,
        ),
      ],
    );
  }
}
