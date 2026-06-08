import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String profilePicUrl;
  final int totalPoints;
  final int loginStreak;
  final DateTime lastLoginDate;
  final double totalDistance;
  final int totalRuns;
  final double highestPace;
  final double weeklyDistance;
  final DateTime weeklyDistanceResetDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.profilePicUrl = '',
    this.totalPoints = 0,
    this.loginStreak = 0,
    required this.lastLoginDate,
    this.totalDistance = 0,
    this.totalRuns = 0,
    this.highestPace = 0,
    this.weeklyDistance = 0,
    required this.weeklyDistanceResetDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      totalPoints: map['totalPoints']?.toInt() ?? 0,
      loginStreak: map['loginStreak']?.toInt() ?? 0,
      lastLoginDate: (map['lastLoginDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalDistance: (map['totalDistance'] as num?)?.toDouble() ?? 0,
      totalRuns: map['totalRuns']?.toInt() ?? 0,
      highestPace: (map['highestPace'] as num?)?.toDouble() ?? 0,
      weeklyDistance: (map['weeklyDistance'] as num?)?.toDouble() ?? 0,
      weeklyDistanceResetDate: (map['weeklyDistanceResetDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'totalPoints': totalPoints,
      'loginStreak': loginStreak,
      'lastLoginDate': Timestamp.fromDate(lastLoginDate),
      'totalDistance': totalDistance,
      'totalRuns': totalRuns,
      'highestPace': highestPace,
      'weeklyDistance': weeklyDistance,
      'weeklyDistanceResetDate': Timestamp.fromDate(weeklyDistanceResetDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? profilePicUrl,
    int? totalPoints,
    int? loginStreak,
    DateTime? lastLoginDate,
    double? totalDistance,
    int? totalRuns,
    double? highestPace,
    double? weeklyDistance,
    DateTime? weeklyDistanceResetDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      totalPoints: totalPoints ?? this.totalPoints,
      loginStreak: loginStreak ?? this.loginStreak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      totalDistance: totalDistance ?? this.totalDistance,
      totalRuns: totalRuns ?? this.totalRuns,
      highestPace: highestPace ?? this.highestPace,
      weeklyDistance: weeklyDistance ?? this.weeklyDistance,
      weeklyDistanceResetDate: weeklyDistanceResetDate ?? this.weeklyDistanceResetDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
