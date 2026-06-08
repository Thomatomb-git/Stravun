import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class RunModel {
  final String id;
  final String userId;
  final double distance;
  final int duration;
  final double pace;
  final int calories;
  final int steps;
  final List<LatLng> route;
  final DateTime startedAt;
  final DateTime createdAt;

  RunModel({
    required this.id,
    required this.userId,
    required this.distance,
    required this.duration,
    required this.pace,
    required this.calories,
    required this.steps,
    required this.route,
    required this.startedAt,
    required this.createdAt,
  });

  factory RunModel.fromMap(Map<String, dynamic> map, String documentId) {
    List<LatLng> parsedRoute = [];
    if (map['route'] != null) {
      for (var point in map['route']) {
        if (point is GeoPoint) {
          parsedRoute.add(LatLng(point.latitude, point.longitude));
        } else if (point is Map) {
          parsedRoute.add(LatLng(point['lat'], point['lng']));
        }
      }
    }

    return RunModel(
      id: documentId,
      userId: map['userId'] ?? '',
      distance: (map['distance'] as num?)?.toDouble() ?? 0.0,
      duration: map['duration']?.toInt() ?? 0,
      pace: (map['pace'] as num?)?.toDouble() ?? 0.0,
      calories: map['calories']?.toInt() ?? 0,
      steps: map['steps']?.toInt() ?? 0,
      route: parsedRoute,
      startedAt: (map['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'distance': distance,
      'duration': duration,
      'pace': pace,
      'calories': calories,
      'steps': steps,
      'route': route.map((e) => GeoPoint(e.latitude, e.longitude)).toList(),
      'startedAt': Timestamp.fromDate(startedAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  RunModel copyWith({
    String? id,
    String? userId,
    double? distance,
    int? duration,
    double? pace,
    int? calories,
    int? steps,
    List<LatLng>? route,
    DateTime? startedAt,
    DateTime? createdAt,
  }) {
    return RunModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      pace: pace ?? this.pace,
      calories: calories ?? this.calories,
      steps: steps ?? this.steps,
      route: route ?? this.route,
      startedAt: startedAt ?? this.startedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
