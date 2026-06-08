import 'package:cloud_firestore/cloud_firestore.dart';

class MissionDefinition {
  final String type;
  final String description;
  final double targetValue;
  final String unit;

  MissionDefinition({
    required this.type,
    required this.description,
    required this.targetValue,
    required this.unit,
  });

  factory MissionDefinition.fromMap(Map<String, dynamic> map) {
    return MissionDefinition(
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      targetValue: (map['targetValue'] as num?)?.toDouble() ?? 0.0,
      unit: map['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'targetValue': targetValue,
      'unit': unit,
    };
  }
}

class MissionCycle {
  final String id;
  final DateTime cycleStartDate;
  final DateTime cycleEndDate;
  final MissionDefinition bronzeMission;
  final MissionDefinition silverMission;
  final MissionDefinition goldMission;

  MissionCycle({
    required this.id,
    required this.cycleStartDate,
    required this.cycleEndDate,
    required this.bronzeMission,
    required this.silverMission,
    required this.goldMission,
  });

  factory MissionCycle.fromMap(Map<String, dynamic> map, String documentId) {
    return MissionCycle(
      id: documentId,
      cycleStartDate: (map['cycleStartDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cycleEndDate: (map['cycleEndDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      bronzeMission: MissionDefinition.fromMap(map['bronzeMission'] ?? {}),
      silverMission: MissionDefinition.fromMap(map['silverMission'] ?? {}),
      goldMission: MissionDefinition.fromMap(map['goldMission'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cycleStartDate': Timestamp.fromDate(cycleStartDate),
      'cycleEndDate': Timestamp.fromDate(cycleEndDate),
      'bronzeMission': bronzeMission.toMap(),
      'silverMission': silverMission.toMap(),
      'goldMission': goldMission.toMap(),
    };
  }

  MissionCycle copyWith({
    String? id,
    DateTime? cycleStartDate,
    DateTime? cycleEndDate,
    MissionDefinition? bronzeMission,
    MissionDefinition? silverMission,
    MissionDefinition? goldMission,
  }) {
    return MissionCycle(
      id: id ?? this.id,
      cycleStartDate: cycleStartDate ?? this.cycleStartDate,
      cycleEndDate: cycleEndDate ?? this.cycleEndDate,
      bronzeMission: bronzeMission ?? this.bronzeMission,
      silverMission: silverMission ?? this.silverMission,
      goldMission: goldMission ?? this.goldMission,
    );
  }
}

class UserMissionProgress {
  final String userId;
  final String missionCycleId;
  final double bronzeProgress;
  final bool bronzeCompleted;
  final bool bronzeClaimedPoints;
  final double silverProgress;
  final bool silverCompleted;
  final bool silverClaimedPoints;
  final double goldProgress;
  final bool goldCompleted;
  final bool goldClaimedPoints;

  UserMissionProgress({
    required this.userId,
    required this.missionCycleId,
    this.bronzeProgress = 0.0,
    this.bronzeCompleted = false,
    this.bronzeClaimedPoints = false,
    this.silverProgress = 0.0,
    this.silverCompleted = false,
    this.silverClaimedPoints = false,
    this.goldProgress = 0.0,
    this.goldCompleted = false,
    this.goldClaimedPoints = false,
  });

  factory UserMissionProgress.fromMap(Map<String, dynamic> map) {
    return UserMissionProgress(
      userId: map['userId'] ?? '',
      missionCycleId: map['missionCycleId'] ?? '',
      bronzeProgress: (map['bronzeProgress'] as num?)?.toDouble() ?? 0.0,
      bronzeCompleted: map['bronzeCompleted'] ?? false,
      bronzeClaimedPoints: map['bronzeClaimedPoints'] ?? false,
      silverProgress: (map['silverProgress'] as num?)?.toDouble() ?? 0.0,
      silverCompleted: map['silverCompleted'] ?? false,
      silverClaimedPoints: map['silverClaimedPoints'] ?? false,
      goldProgress: (map['goldProgress'] as num?)?.toDouble() ?? 0.0,
      goldCompleted: map['goldCompleted'] ?? false,
      goldClaimedPoints: map['goldClaimedPoints'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'missionCycleId': missionCycleId,
      'bronzeProgress': bronzeProgress,
      'bronzeCompleted': bronzeCompleted,
      'bronzeClaimedPoints': bronzeClaimedPoints,
      'silverProgress': silverProgress,
      'silverCompleted': silverCompleted,
      'silverClaimedPoints': silverClaimedPoints,
      'goldProgress': goldProgress,
      'goldCompleted': goldCompleted,
      'goldClaimedPoints': goldClaimedPoints,
    };
  }

  UserMissionProgress copyWith({
    String? userId,
    String? missionCycleId,
    double? bronzeProgress,
    bool? bronzeCompleted,
    bool? bronzeClaimedPoints,
    double? silverProgress,
    bool? silverCompleted,
    bool? silverClaimedPoints,
    double? goldProgress,
    bool? goldCompleted,
    bool? goldClaimedPoints,
  }) {
    return UserMissionProgress(
      userId: userId ?? this.userId,
      missionCycleId: missionCycleId ?? this.missionCycleId,
      bronzeProgress: bronzeProgress ?? this.bronzeProgress,
      bronzeCompleted: bronzeCompleted ?? this.bronzeCompleted,
      bronzeClaimedPoints: bronzeClaimedPoints ?? this.bronzeClaimedPoints,
      silverProgress: silverProgress ?? this.silverProgress,
      silverCompleted: silverCompleted ?? this.silverCompleted,
      silverClaimedPoints: silverClaimedPoints ?? this.silverClaimedPoints,
      goldProgress: goldProgress ?? this.goldProgress,
      goldCompleted: goldCompleted ?? this.goldCompleted,
      goldClaimedPoints: goldClaimedPoints ?? this.goldClaimedPoints,
    );
  }
}
