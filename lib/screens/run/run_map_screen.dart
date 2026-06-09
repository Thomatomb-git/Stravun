import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/theme.dart';
import '../../models/run_model.dart';
import '../../providers/auth_provider.dart';
import 'run_summary_screen.dart';

class RunMapScreen extends StatefulWidget {
  const RunMapScreen({super.key});

  @override
  State<RunMapScreen> createState() => _RunMapScreenState();
}

class _RunMapScreenState extends State<RunMapScreen> {
  // States
  bool isTracking = false;
  bool isPaused = false;
  bool hasStarted = false;
  
  // Stats
  int seconds = 0;
  double distance = 0.0; // in km
  
  // Tracking data
  Timer? timer;
  DateTime? startedAt;
  List<LatLng> routePoints = [];
  StreamSubscription<Position>? positionStream;
  
  // Map Controller
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndGetInitialLocation();
  }

  Future<void> _checkLocationPermissionAndGetInitialLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      try {
        _mapController.move(_currentLocation!, 16.0);
      } catch (e) {
        // Map controller might not be ready yet.
        // It's okay, because initialCenter will pick up _currentLocation on next build.
      }
    }
  }

  void startRun() async {
    // Ensure permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
        return; // Cannot start without permission
      }
    }

    setState(() {
      isTracking = true;
      isPaused = false;
      hasStarted = true;
      startedAt ??= DateTime.now();
    });

    _startTimer();
    _startLocationStream();
  }

  void pauseRun() {
    setState(() {
      isPaused = true;
    });
    timer?.cancel();
    positionStream?.pause();
  }

  void resumeRun() {
    setState(() {
      isPaused = false;
    });
    _startTimer();
    positionStream?.resume();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          seconds++;
        });
      }
    });
  }

  void _startLocationStream() {
    positionStream?.cancel();
    
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2, // minimum distance (meters) to trigger update
    );

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        if (!isTracking || isPaused) return;

        final newPoint = LatLng(position.latitude, position.longitude);
        
        if (mounted) {
          setState(() {
            if (routePoints.isNotEmpty) {
              final lastPoint = routePoints.last;
              final distToAdd = const Distance().as(LengthUnit.Meter, lastPoint, newPoint) / 1000.0; // convert to km
              distance += distToAdd;
            }
            routePoints.add(newPoint);
            _currentLocation = newPoint;
          });
          
          // Auto center map
          try {
            _mapController.move(newPoint, _mapController.camera.zoom);
          } catch (e) {
            // Ignore if map is not ready
          }
        }
      }
    );
  }

  Future<void> stopAndNavigateToSummary() async {
    timer?.cancel();
    positionStream?.cancel();
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;
    if (user != null && startedAt != null) {
      // Calculate final stats
      final finalPace = pace;
      final calories = (distance * 60).toInt(); // ~60 kcal per km
      final steps = (distance * 1300).toInt(); // ~1300 steps per km
      
      final run = RunModel(
        id: const Uuid().v4(),
        userId: user.uid,
        distance: distance,
        duration: seconds,
        pace: finalPace,
        calories: calories,
        steps: steps,
        route: List.from(routePoints), // Pass a copy of the list
        startedAt: startedAt!,
        createdAt: DateTime.now(),
      );

      // Reset state so when user comes back, it's fresh
      setState(() {
        isTracking = false;
        isPaused = false;
        hasStarted = false;
        seconds = 0;
        distance = 0;
        startedAt = null;
        routePoints.clear();
      });

      // Navigate to summary screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RunSummaryScreen(runModel: run)),
        );
      }
    }
  }

  double get pace => distance <= 0 ? 0 : (seconds / 60) / distance;

  @override
  void dispose() {
    timer?.cancel();
    positionStream?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Default center if no location yet
    final center = _currentLocation ?? const LatLng(-6.2017, 106.7817);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.stravun',
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4.0,
                      color: AppColors.accentNeon,
                    ),
                  ],
                ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                            )
                          ]
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                isTracking && !isPaused ? 'Recording' : (isPaused ? 'Paused' : 'Ready to Run'), 
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9), 
                  fontSize: 22, 
                  fontWeight: FontWeight.w700,
                  shadows: const [Shadow(color: Colors.black54, blurRadius: 4)],
                )
              ),
            ),
          ),

          // Bottom Controls Panel
          Positioned(
            left: 26,
            right: 26,
            bottom: 42,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              decoration: BoxDecoration(
                color: AppColors.backgroundSurface, 
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem('Time', _formatDuration(seconds)),
                      _statItem('Pace', pace.toStringAsFixed(1)),
                      _statItem('km', distance.toStringAsFixed(2)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (!hasStarted) {
      // START button
      return GestureDetector(
        onTap: startRun,
        child: Container(
          width: 78,
          height: 78,
          decoration: const BoxDecoration(color: AppColors.accentNeon, shape: BoxShape.circle),
          child: const Icon(Icons.play_arrow, color: AppColors.backgroundSurface, size: 48),
        ),
      );
    } else if (isTracking && !isPaused) {
      // PAUSE button
      return GestureDetector(
        onTap: pauseRun,
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface, 
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentNeon, width: 3),
          ),
          child: const Icon(Icons.pause, color: AppColors.accentNeon, size: 40),
        ),
      );
    } else {
      // RESUME and STOP buttons side by side
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // STOP
          GestureDetector(
            onTap: stopAndNavigateToSummary,
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
              child: const Icon(Icons.stop, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(width: 32),
          // RESUME
          GestureDetector(
            onTap: resumeRun,
            child: Container(
              width: 78,
              height: 78,
              decoration: const BoxDecoration(color: AppColors.accentNeon, shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow, color: AppColors.backgroundSurface, size: 48),
            ),
          ),
        ],
      );
    }
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final sec = totalSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
