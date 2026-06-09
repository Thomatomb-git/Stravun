import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../config/theme.dart';
import '../../models/run_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';

class RunMapScreen extends StatefulWidget {
  const RunMapScreen({super.key});

  @override
  State<RunMapScreen> createState() => _RunMapScreenState();
}

class _RunMapScreenState extends State<RunMapScreen> {
  bool running = false;
  int seconds = 0;
  double distance = 0;
  Timer? timer;
  DateTime? startedAt;
  
  final FirestoreService _firestoreService = FirestoreService();

  void toggleRun() {
    setState(() => running = !running);
    if (running) {
      startedAt ??= DateTime.now();
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          seconds++;
          distance += 0.003;
        });
      });
    } else {
      timer?.cancel();
    }
  }

  Future<void> stopAndSaveRun() async {
    timer?.cancel();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;
    if (user != null && startedAt != null) {
      final run = RunModel(
        id: const Uuid().v4(),
        userId: user.uid,
        distance: distance,
        duration: seconds,
        pace: pace,
        calories: (distance * 60).toInt(), // dummy calc
        steps: (distance * 1300).toInt(),
        route: const [], // Empty route for now
        startedAt: startedAt!,
        createdAt: DateTime.now(),
      );
      await _firestoreService.saveRun(run);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Run saved successfully!')));
        // Reset state
        setState(() {
          running = false;
          seconds = 0;
          distance = 0;
          startedAt = null;
        });
      }
    }
  }

  double get pace => distance <= 0 ? 0 : (seconds / 60) / distance;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const binusAnggrek = LatLng(-6.2017, 106.7817);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(initialCenter: binusAnggrek, initialZoom: 16),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.stravun',
              ),
              const MarkerLayer(
                markers: [
                  Marker(
                    point: binusAnggrek,
                    width: 48,
                    height: 48,
                    child: Icon(Icons.location_pin, color: AppColors.accentNeon, size: 46),
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Map #1', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 22, fontWeight: FontWeight.w700)),
            ),
          ),
          Positioned(
            left: 26,
            right: 26,
            bottom: 42,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              decoration: BoxDecoration(color: AppColors.backgroundSurface, borderRadius: BorderRadius.circular(14)),
              child: Column(
                children: [
                  const Text('Run', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      stat('Time', seconds.toString()),
                      stat('Pace', pace.toStringAsFixed(1)),
                      stat('Distance', distance.toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: toggleRun,
                        child: Container(
                          width: 78,
                          height: 78,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(running ? Icons.pause : Icons.play_arrow, color: AppColors.backgroundSurface, size: 48),
                        ),
                      ),
                      if (!running && seconds > 0) ...[
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: stopAndSaveRun,
                          child: Container(
                            width: 78,
                            height: 78,
                            decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                            child: const Icon(Icons.stop, color: Colors.white, size: 48),
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget stat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
