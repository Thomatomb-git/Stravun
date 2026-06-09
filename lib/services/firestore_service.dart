import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/run_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/mission_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Operations ---
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _db.collection('users').doc(uid).update(data);
  }

  Future<void> updateLoginStreak(String uid) async {
    final user = await getUser(uid);
    if (user == null) return;

    final now = DateTime.now();
    final lastLogin = user.lastLoginDate;
    final difference = DateTime(now.year, now.month, now.day).difference(
        DateTime(lastLogin.year, lastLogin.month, lastLogin.day)).inDays;

    int newStreak = user.loginStreak;
    if (difference == 1) {
      newStreak += 1;
    } else if (difference > 1) {
      newStreak = 1; // Reset to 1 if skipped a day
    } else {
      return; // Already logged in today
    }

    await updateUser(uid, {
      'loginStreak': newStreak,
      'lastLoginDate': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addPoints(String uid, int points) async {
    await updateUser(uid, {
      'totalPoints': FieldValue.increment(points)
    });
  }

  Future<List<UserModel>> getLeaderboard(String field, {int limit = 50}) async {
    final snapshot = await _db.collection('users')
        .orderBy(field, descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<int> getUserRank(String uid, String field) async {
    final user = await getUser(uid);
    if (user == null) return -1;
    
    final userMap = user.toMap();
    final userValue = userMap[field];
    if (userValue == null) return -1;

    // Use count() aggregate query to get rank efficiently
    final aggregateQuery = await _db.collection('users')
        .where(field, isGreaterThan: userValue)
        .count()
        .get();
    
    return (aggregateQuery.count ?? 0) + 1;
  }

  // --- Run Operations ---
  Future<void> saveRun(RunModel run) async {
    // Save run to runs collection
    await _db.collection('runs').doc(run.id).set(run.toMap());
    
    // Update user stats
    final user = await getUser(run.userId);
    if (user != null) {
      // Handle weekly distance reset
      final now = DateTime.now();
      bool resetWeekly = false;
      // If the last reset was not in the same week (e.g. different week of year or more than 7 days)
      // Simplification: if now is after the next monday from the reset date.
      if (now.difference(user.weeklyDistanceResetDate).inDays >= 7 || 
          now.weekday < user.weeklyDistanceResetDate.weekday) {
        resetWeekly = true;
      }

      double newWeekly = resetWeekly ? run.distance : user.weeklyDistance + run.distance;
      double newHighestPace = user.highestPace == 0 ? run.pace : (run.pace < user.highestPace ? run.pace : user.highestPace);

      await updateUser(user.uid, {
        'totalDistance': FieldValue.increment(run.distance),
        'totalRuns': FieldValue.increment(1),
        'weeklyDistance': newWeekly,
        'weeklyDistanceResetDate': resetWeekly ? FieldValue.serverTimestamp() : Timestamp.fromDate(user.weeklyDistanceResetDate),
        'highestPace': newHighestPace,
      });
      
      // Evaluate missions
      await evaluateMissions(run.userId, run: run);
    }
  }

  Future<List<RunModel>> getRecentRuns(String uid, {int limit = 20}) async {
    final snapshot = await _db.collection('runs')
        .where('userId', isEqualTo: uid)
        .get();
    
    final runs = snapshot.docs.map((doc) => RunModel.fromMap(doc.data(), doc.id)).toList();
    // Sort descending by startedAt
    runs.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    
    if (runs.length > limit) {
      return runs.sublist(0, limit);
    }
    return runs;
  }

  Future<RunModel?> getLastRun(String uid) async {
    final runs = await getRecentRuns(uid, limit: 1);
    return runs.isNotEmpty ? runs.first : null;
  }

  Future<RunModel?> getRunById(String runId) async {
    final doc = await _db.collection('runs').doc(runId).get();
    if (doc.exists && doc.data() != null) {
      return RunModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<Map<int, double>> getWeeklyRunStats(String uid) async {
    final now = DateTime.now();
    // Start of the week (Monday)
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    
    // To avoid requiring a composite index on userId and startedAt,
    // we fetch by userId and filter by date locally.
    final snapshot = await _db.collection('runs')
        .where('userId', isEqualTo: uid)
        .get();
        
    Map<int, double> weeklyStats = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    
    for (var doc in snapshot.docs) {
      final run = RunModel.fromMap(doc.data(), doc.id);
      if (!run.startedAt.isBefore(startOfWeek)) {
        final weekday = run.startedAt.weekday; // 1 (Mon) to 7 (Sun)
        weeklyStats[weekday] = (weeklyStats[weekday] ?? 0) + run.distance;
      }
    }
    
    return weeklyStats;
  }

  // --- Post Operations ---
  Future<void> createPost(PostModel post) async {
    await _db.collection('posts').doc(post.id).set(post.toMap());
    
    // Evaluate missions
    await evaluateMissions(post.userId, isPost: true);
  }

  Future<List<PostModel>> getPosts({int limit = 20, DocumentSnapshot? startAfter}) async {
    var query = _db.collection('posts').orderBy('createdAt', descending: true).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => PostModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<PostModel?> getPostById(String postId) async {
    final doc = await _db.collection('posts').doc(postId).get();
    if (doc.exists && doc.data() != null) {
      return PostModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> updatePost(String postId, String content) async {
    await _db.collection('posts').doc(postId).update({
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePost(String postId) async {
    final batch = _db.batch();
    
    // Delete likes subcollection
    final likes = await _db.collection('posts').doc(postId).collection('likes').get();
    for (var doc in likes.docs) {
      batch.delete(doc.reference);
    }
    // Delete comments subcollection
    final comments = await _db.collection('posts').doc(postId).collection('comments').get();
    for (var doc in comments.docs) {
      batch.delete(doc.reference);
    }
    // Delete post document
    batch.delete(_db.collection('posts').doc(postId));
    
    await batch.commit();
  }

  Future<void> toggleLike(String postId, String userId) async {
    final likeRef = _db.collection('posts').doc(postId).collection('likes').doc(userId);
    final postRef = _db.collection('posts').doc(postId);
    
    await _db.runTransaction((transaction) async {
      final likeDoc = await transaction.get(likeRef);
      
      if (likeDoc.exists) {
        // Unlike
        transaction.delete(likeRef);
        transaction.update(postRef, {'likeCount': FieldValue.increment(-1)});
      } else {
        // Like
        transaction.set(likeRef, {'createdAt': FieldValue.serverTimestamp()});
        transaction.update(postRef, {'likeCount': FieldValue.increment(1)});
      }
    });
  }

  Future<bool> isPostLikedByUser(String postId, String userId) async {
    final likeDoc = await _db.collection('posts').doc(postId).collection('likes').doc(userId).get();
    return likeDoc.exists;
  }

  Future<List<CommentModel>> getComments(String postId) async {
    final snapshot = await _db.collection('posts').doc(postId).collection('comments')
        .orderBy('createdAt', descending: false)
        .get();
    return snapshot.docs.map((doc) => CommentModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> addComment(String postId, CommentModel comment) async {
    await _db.collection('posts').doc(postId).collection('comments').doc(comment.id).set(comment.toMap());
    await _db.collection('posts').doc(postId).update({'commentCount': FieldValue.increment(1)});
  }

  // --- Mission Operations ---
  Future<MissionCycle?> getCurrentMissionCycle() async {
    // We assume there's a master document for the current cycle or we query the latest
    final snapshot = await _db.collection('missions')
        .orderBy('cycleStartDate', descending: true)
        .limit(1)
        .get();
        
    if (snapshot.docs.isNotEmpty) {
      return MissionCycle.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
    }
    return null;
  }
  
  Future<void> saveMissionCycle(MissionCycle cycle) async {
    await _db.collection('missions').doc(cycle.id).set(cycle.toMap());
  }

  Future<UserMissionProgress?> getUserMissionProgress(String userId, String missionCycleId) async {
    final docId = "${userId}_$missionCycleId";
    final doc = await _db.collection('userMissions').doc(docId).get();
    if (doc.exists && doc.data() != null) {
      return UserMissionProgress.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> updateMissionProgress(UserMissionProgress progress) async {
    final docId = "${progress.userId}_${progress.missionCycleId}";
    await _db.collection('userMissions').doc(docId).set(progress.toMap(), SetOptions(merge: true));
  }

  Future<void> claimMissionPoints(String userId, String tier) async {
    // tier can be 'bronze', 'silver', 'gold'
    // Usually points are constants, but we'll increment based on tier
    int points = 0;
    if (tier == 'bronze') points = 1;
    if (tier == 'silver') points = 3;
    if (tier == 'gold') points = 5;
    
    if (points > 0) {
      await addPoints(userId, points);
    }
  }

  Future<void> evaluateMissions(String userId, {RunModel? run, bool isPost = false}) async {
    MissionCycle? cycle = await getCurrentMissionCycle();
    if (cycle == null) return;
    
    UserMissionProgress? progress = await getUserMissionProgress(userId, cycle.id);
    progress ??= UserMissionProgress(userId: userId, missionCycleId: cycle.id);
    
    bool updated = false;
    double bProg = progress.bronzeProgress;
    bool bComp = progress.bronzeCompleted;
    bool bClaim = progress.bronzeClaimedPoints;

    double sProg = progress.silverProgress;
    bool sComp = progress.silverCompleted;
    bool sClaim = progress.silverClaimedPoints;

    double gProg = progress.goldProgress;
    bool gComp = progress.goldCompleted;
    bool gClaim = progress.goldClaimedPoints;

    Future<void> evaluate(MissionDefinition mission, String tier) async {
      double currentProgress = tier == 'bronze' ? bProg : (tier == 'silver' ? sProg : gProg);
      bool completed = tier == 'bronze' ? bComp : (tier == 'silver' ? sComp : gComp);
      bool claimed = tier == 'bronze' ? bClaim : (tier == 'silver' ? sClaim : gClaim);

      if (completed) return;

      double newProgress = currentProgress;

      if (run != null) {
        if (mission.type == 'run_distance') {
          newProgress += run.distance;
        } else if (mission.type == 'burn_calories') {
          newProgress += run.calories;
        } else if (mission.type == 'run_duration') {
          newProgress += run.duration / 60.0;
        } else if (mission.type == 'run_count') {
          newProgress += 1;
        } else if (mission.type == 'run_steps') {
          newProgress += run.steps;
        } else if (mission.type == 'run_pace') {
          if (run.pace > 0 && run.pace <= mission.targetValue) {
            newProgress = mission.targetValue;
          }
        }
      }

      if (isPost && mission.type == 'forum_post') {
        newProgress += 1;
      }

      if (newProgress > currentProgress || (mission.type == 'run_pace' && newProgress > 0)) {
        updated = true;
        
        bool newlyCompleted = false;
        if (mission.type == 'run_pace') {
          newlyCompleted = newProgress <= mission.targetValue && newProgress > 0;
        } else {
          newProgress = newProgress > mission.targetValue ? mission.targetValue : newProgress;
          newlyCompleted = newProgress >= mission.targetValue;
        }

        if (newlyCompleted && !claimed) {
           await claimMissionPoints(userId, tier);
           claimed = true;
        }

        if (tier == 'bronze') {
          bProg = newProgress; bComp = newlyCompleted; bClaim = claimed;
        } else if (tier == 'silver') {
          sProg = newProgress; sComp = newlyCompleted; sClaim = claimed;
        } else if (tier == 'gold') {
          gProg = newProgress; gComp = newlyCompleted; gClaim = claimed;
        }
      }
    }

    await evaluate(cycle.bronzeMission, 'bronze');
    await evaluate(cycle.silverMission, 'silver');
    await evaluate(cycle.goldMission, 'gold');

    if (updated) {
      progress = progress.copyWith(
        bronzeProgress: bProg, bronzeCompleted: bComp, bronzeClaimedPoints: bClaim,
        silverProgress: sProg, silverCompleted: sComp, silverClaimedPoints: sClaim,
        goldProgress: gProg, goldCompleted: gComp, goldClaimedPoints: gClaim,
      );
      await updateMissionProgress(progress);
    }
  }
}
