import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/run_model.dart';
import '../models/mission_model.dart';
import '../services/firestore_service.dart';
import '../services/mission_service.dart';
import 'auth_provider.dart';

class HomeProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final MissionService _missionService = MissionService();
  final AuthProvider _authProvider;

  bool _isLoading = false;
  
  UserModel? _userModel;
  RunModel? _lastRun;
  Map<int, double> _weeklyStats = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
  MissionCycle? _currentMissions;
  UserMissionProgress? _missionProgress;
  int _userRank = -1;
  int _pointsToNextRank = 0;

  HomeProvider(this._authProvider) {
    if (_authProvider.isLoggedIn) {
      refreshHomeData();
    }
  }

  // Getters
  bool get isLoading => _isLoading;
  UserModel? get userModel => _userModel;
  RunModel? get lastRun => _lastRun;
  Map<int, double> get weeklyStats => _weeklyStats;
  MissionCycle? get currentMissions => _currentMissions;
  UserMissionProgress? get missionProgress => _missionProgress;
  int get userRank => _userRank;
  int get pointsToNextRank => _pointsToNextRank;

  Future<void> refreshHomeData() async {
    final uid = _authProvider.userModel?.uid;
    if (uid == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Get updated user model
      try {
        _userModel = await _firestoreService.getUser(uid);
      } catch (e) {
        debugPrint("Error fetching user model: $e");
      }
      
      // 2. Get last run
      try {
        _lastRun = await _firestoreService.getLastRun(uid);
      } catch (e) {
        debugPrint("Error fetching last run: $e");
      }
      
      // 3. Get weekly stats
      try {
        _weeklyStats = await _firestoreService.getWeeklyRunStats(uid);
      } catch (e) {
        debugPrint("Error fetching weekly stats: $e");
      }
      
      // 4. Get global rank based on total points
      try {
        _userRank = await _firestoreService.getUserRank(uid, 'totalPoints');
      } catch (e) {
        debugPrint("Error fetching user rank: $e");
      }
      
      // Calculate points to next rank (mocked logic for now)
      _pointsToNextRank = 10; // TODO: implement real logic by comparing with rank above
      
      // 5. Handle Missions
      try {
        await _handleMissions(uid);
      } catch (e) {
        debugPrint("Error handling missions: $e");
      }

    } catch (e) {
      debugPrint("Error refreshing home data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleMissions(String uid) async {
    // Check current cycle
    MissionCycle? cycle = await _firestoreService.getCurrentMissionCycle();
    
    // If no cycle or cycle expired, generate a new one
    if (cycle == null || _missionService.isCycleExpired(cycle)) {
      final startDate = _missionService.calculateCycleStartDate(DateTime.now());
      cycle = _missionService.generateMissionCycle(startDate);
      await _firestoreService.saveMissionCycle(cycle);
    }
    
    _currentMissions = cycle;

    // Get user progress for this cycle
    UserMissionProgress? progress = await _firestoreService.getUserMissionProgress(uid, cycle.id);
    
    // Create new progress if it doesn't exist
    if (progress == null) {
      progress = UserMissionProgress(
        userId: uid,
        missionCycleId: cycle.id,
      );
      await _firestoreService.updateMissionProgress(progress);
    }
    
    _missionProgress = progress;
  }
}
