import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/mission_model.dart';
import '../utils/constants.dart';

class MissionService {
  final _uuid = const Uuid();

  // Predefined mission pools
  final List<MissionDefinition> _bronzeMissions = [
    MissionDefinition(type: 'run_distance', description: 'Run 1 km', targetValue: 1, unit: 'km'),
    MissionDefinition(type: 'burn_calories', description: 'Burn 100 kcal', targetValue: 100, unit: 'kcal'),
    MissionDefinition(type: 'run_duration', description: 'Run for 10 minutes', targetValue: 10, unit: 'min'),
    MissionDefinition(type: 'run_count', description: 'Complete 1 run', targetValue: 1, unit: 'runs'),
    MissionDefinition(type: 'run_steps', description: 'Walk/run 1,300 steps', targetValue: 1300, unit: 'steps'),
  ];

  final List<MissionDefinition> _silverMissions = [
    MissionDefinition(type: 'run_distance', description: 'Run 3 km', targetValue: 3, unit: 'km'),
    MissionDefinition(type: 'burn_calories', description: 'Burn 300 kcal', targetValue: 300, unit: 'kcal'),
    MissionDefinition(type: 'run_duration', description: 'Run for 20 minutes', targetValue: 20, unit: 'min'),
    MissionDefinition(type: 'forum_post', description: 'Post in the community forum', targetValue: 1, unit: 'posts'),
    MissionDefinition(type: 'run_count', description: 'Complete 2 runs in one day', targetValue: 2, unit: 'runs'),
    MissionDefinition(type: 'run_pace', description: 'Run at a pace under 7:00 min/km', targetValue: 7.0, unit: 'min/km'),
  ];

  final List<MissionDefinition> _goldMissions = [
    MissionDefinition(type: 'run_distance', description: 'Run 5 km', targetValue: 5, unit: 'km'),
    MissionDefinition(type: 'burn_calories', description: 'Burn 500 kcal', targetValue: 500, unit: 'kcal'),
    MissionDefinition(type: 'run_duration', description: 'Run for 30 minutes non-stop', targetValue: 30, unit: 'min'),
    MissionDefinition(type: 'run_distance', description: 'Run 7 km', targetValue: 7, unit: 'km'),
    MissionDefinition(type: 'run_count', description: 'Complete 3 runs in one day', targetValue: 3, unit: 'runs'),
    MissionDefinition(type: 'run_pace', description: 'Run at a pace under 6:00 min/km', targetValue: 6.0, unit: 'min/km'),
  ];

  // Determine current cycle start date based on a fixed epoch
  // Using an arbitrary epoch (e.g. Jan 1, 2024) to ensure all users sync
  DateTime calculateCycleStartDate(DateTime now) {
    final epoch = DateTime(2024, 1, 1);
    final diffDays = now.difference(epoch).inDays;
    final cycleNum = diffDays ~/ AppConstants.missionRotationDays;
    return epoch.add(Duration(days: cycleNum * AppConstants.missionRotationDays));
  }

  // Check if a cycle is expired
  bool isCycleExpired(MissionCycle cycle) {
    return DateTime.now().isAfter(cycle.cycleEndDate);
  }

  // Generate a new mission cycle
  MissionCycle generateMissionCycle(DateTime startDate) {
    // We use the start date as a seed so all users get the same missions for the same cycle
    final seed = startDate.millisecondsSinceEpoch;
    final random = Random(seed);

    final bronze = _bronzeMissions[random.nextInt(_bronzeMissions.length)];
    final silver = _silverMissions[random.nextInt(_silverMissions.length)];
    final gold = _goldMissions[random.nextInt(_goldMissions.length)];

    return MissionCycle(
      id: _uuid.v4(),
      cycleStartDate: startDate,
      cycleEndDate: startDate.add(const Duration(days: AppConstants.missionRotationDays)),
      bronzeMission: bronze,
      silverMission: silver,
      goldMission: gold,
    );
  }
}
