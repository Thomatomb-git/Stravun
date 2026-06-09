import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/run_model.dart';
import '../../providers/home_provider.dart';
import '../../services/firestore_service.dart';
import '../community/create_post_screen.dart';

class RunSummaryScreen extends StatefulWidget {
  final RunModel runModel;
  final bool isViewOnly;

  const RunSummaryScreen({super.key, required this.runModel, this.isViewOnly = false});

  @override
  State<RunSummaryScreen> createState() => _RunSummaryScreenState();
}

class _RunSummaryScreenState extends State<RunSummaryScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Parse route points
    final routePoints = widget.runModel.route;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Run Summary', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: widget.isViewOnly, // Allow back button if view only
        leading: widget.isViewOnly ? IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ) : null,
      ),
      body: Column(
        children: [
          // Map
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              clipBehavior: Clip.hardEdge,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: routePoints.isNotEmpty ? routePoints.first : const LatLng(-6.2017, 106.7817),
                  initialZoom: 15,
                  // Disable interaction since it's just a summary view
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
                        points: routePoints,
                        strokeWidth: 4.0,
                        color: AppColors.accentNeon,
                      ),
                    ],
                  ),
                  if (routePoints.isNotEmpty)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: routePoints.first,
                          child: const Icon(Icons.play_circle_fill, color: Colors.green, size: 24),
                        ),
                        Marker(
                          point: routePoints.last,
                          child: const Icon(Icons.stop_circle, color: Colors.red, size: 24),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          
          // Stats
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Primary Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem('Distance', '${widget.runModel.distance.toStringAsFixed(2)} km'),
                      _statItem('Time', _formatDuration(widget.runModel.duration)),
                      _statItem('Avg Pace', '${widget.runModel.pace.toStringAsFixed(2)} /km'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Secondary Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem('Calories', '${widget.runModel.calories} kcal'),
                      _statItem('Steps', '${widget.runModel.steps}'),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Action Buttons
                  if (!widget.isViewOnly) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Discard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () => _saveRun(context, share: false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.backgroundSurface,
                              foregroundColor: AppColors.textPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: _isLoading && !_isShareLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _saveRun(context, share: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentNeon,
                          foregroundColor: AppColors.backgroundPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading && _isShareLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.backgroundPrimary))
                            : const Text('Share to Community', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isShareLoading = false;

  Future<void> _saveRun(BuildContext context, {required bool share}) async {
    setState(() {
      _isLoading = true;
      _isShareLoading = share;
    });

    try {
      final firestoreService = FirestoreService();
      
      // Save to Firestore
      await firestoreService.saveRun(widget.runModel);
      
      if (context.mounted) {
        // Refresh Home Provider to update stats and missions
        Provider.of<HomeProvider>(context, listen: false).refreshHomeData();
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Run saved successfully!')));
        
        if (share) {
          // Navigate to Create Post with attached run ID, replacing this screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(attachedRunId: widget.runModel.id),
            ),
          );
        } else {
          // Just go back to map screen (which is now reset)
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        setState(() {
          _isLoading = false;
          _isShareLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save run. Please try again.')));
      }
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
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
