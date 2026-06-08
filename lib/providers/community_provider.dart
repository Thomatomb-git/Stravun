import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import 'auth_provider.dart';

enum LeaderboardCategory { totalPoints, loginStreak, weeklyDistance }

class CommunityProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final AuthProvider _authProvider;
  final Uuid _uuid = const Uuid();

  // --- Leaderboard State ---
  bool _isLoadingLeaderboard = false;
  LeaderboardCategory _selectedCategory = LeaderboardCategory.totalPoints;
  List<UserModel> _leaderboardUsers = [];
  int _currentUserRank = -1;

  // --- Forum State ---
  bool _isLoadingForum = false;
  final bool _isLoadingMore = false;
  List<PostModel> _posts = [];
  bool _hasMorePosts = true;
  final Set<String> _likedPostIds = {};
  
  // --- Post Detail State ---
  List<CommentModel> _comments = [];

  CommunityProvider(this._authProvider) {
    if (_authProvider.isLoggedIn) {
      fetchLeaderboard(_selectedCategory);
      fetchPosts();
    }
  }

  // Getters
  bool get isLoadingLeaderboard => _isLoadingLeaderboard;
  LeaderboardCategory get selectedCategory => _selectedCategory;
  List<UserModel> get leaderboardUsers => _leaderboardUsers;
  int get currentUserRank => _currentUserRank;

  bool get isLoadingForum => _isLoadingForum;
  bool get isLoadingMore => _isLoadingMore;
  List<PostModel> get posts => _posts;
  bool get hasMorePosts => _hasMorePosts;
  Set<String> get likedPostIds => _likedPostIds;
  List<CommentModel> get comments => _comments;

  // --- Leaderboard Methods ---
  Future<void> fetchLeaderboard(LeaderboardCategory category) async {
    _selectedCategory = category;
    _isLoadingLeaderboard = true;
    notifyListeners();

    try {
      String field = 'totalPoints';
      switch (category) {
        case LeaderboardCategory.totalPoints:
          field = 'totalPoints';
          break;
        case LeaderboardCategory.loginStreak:
          field = 'loginStreak';
          break;
        case LeaderboardCategory.weeklyDistance:
          field = 'weeklyDistance';
          break;
      }

      _leaderboardUsers = await _firestoreService.getLeaderboard(field, limit: 50);
      
      final uid = _authProvider.userModel?.uid;
      if (uid != null) {
        _currentUserRank = await _firestoreService.getUserRank(uid, field);
      }
    } catch (e) {
      debugPrint("Error fetching leaderboard: $e");
    } finally {
      _isLoadingLeaderboard = false;
      notifyListeners();
    }
  }

  // --- Forum Methods ---
  Future<void> fetchPosts() async {
    _isLoadingForum = true;
    _hasMorePosts = true;
    notifyListeners();

    try {
      // For proper pagination, we need the actual query snapshots, but since our service
      // currently returns List<PostModel>, we'll simplify and just fetch first 20.
      // In a real app, the service should return the DocumentSnapshot for startAfter.
      _posts = await _firestoreService.getPosts(limit: 20);
      
      // Fetch user likes
      final uid = _authProvider.userModel?.uid;
      if (uid != null) {
        _likedPostIds.clear();
        for (var post in _posts) {
          bool liked = await _firestoreService.isPostLikedByUser(post.id, uid);
          if (liked) _likedPostIds.add(post.id);
        }
      }
      
      if (_posts.length < 20) {
        _hasMorePosts = false;
      }
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {
      _isLoadingForum = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    // Simplified since we don't have the last doc
    // In actual implementation, we pass _lastPostDoc to service
  }

  Future<void> createPost(String content, List<File> mediaFiles, List<String> mediaTypes, {String? attachedRunId}) async {
    final userModel = _authProvider.userModel;
    if (userModel == null) return;

    try {
      List<String> mediaUrls = [];
      
      // Upload media files if any
      for (int i = 0; i < mediaFiles.length; i++) {
        final file = mediaFiles[i];
        final type = mediaTypes[i];
        final path = 'posts/${userModel.uid}/${_uuid.v4()}.${type == "image" ? "jpg" : "mp4"}';
        
        String url;
        if (type == 'image') {
          url = await _storageService.uploadImage(file, path);
        } else {
          url = await _storageService.uploadVideo(file, path);
        }
        mediaUrls.add(url);
      }

      final post = PostModel(
        id: _uuid.v4(),
        userId: userModel.uid,
        username: userModel.username,
        userProfilePicUrl: userModel.profilePicUrl,
        content: content,
        mediaUrls: mediaUrls,
        mediaTypes: mediaTypes,
        attachedRunId: attachedRunId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestoreService.createPost(post);
      
      // Insert at top of list
      _posts.insert(0, post);
      notifyListeners();
    } catch (e) {
      debugPrint("Error creating post: $e");
      rethrow;
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestoreService.deletePost(postId);
      _posts.removeWhere((p) => p.id == postId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting post: $e");
      rethrow;
    }
  }

  Future<void> updatePost(String postId, String newContent) async {
    try {
      await _firestoreService.updatePost(postId, newContent);
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(
          content: newContent,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating post: $e");
      rethrow;
    }
  }

  Future<void> toggleLike(String postId) async {
    final uid = _authProvider.userModel?.uid;
    if (uid == null) return;

    try {
      final isLiked = _likedPostIds.contains(postId);
      
      // Optimistic update
      if (isLiked) {
        _likedPostIds.remove(postId);
        _updatePostLikeCount(postId, -1);
      } else {
        _likedPostIds.add(postId);
        _updatePostLikeCount(postId, 1);
      }
      notifyListeners();

      // Background update
      await _firestoreService.toggleLike(postId, uid);
    } catch (e) {
      // Revert on error
      debugPrint("Error toggling like: $e");
      fetchPosts(); // Refetch to sync state
    }
  }

  void _updatePostLikeCount(String postId, int change) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        likeCount: _posts[index].likeCount + change
      );
    }
  }

  // --- Comment Methods ---
  Future<void> fetchComments(String postId) async {
    try {
      _comments = await _firestoreService.getComments(postId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching comments: $e");
    }
  }

  Future<void> addComment(String postId, String content) async {
    final userModel = _authProvider.userModel;
    if (userModel == null) return;

    try {
      final comment = CommentModel(
        id: _uuid.v4(),
        userId: userModel.uid,
        username: userModel.username,
        userProfilePicUrl: userModel.profilePicUrl,
        content: content,
        createdAt: DateTime.now(),
      );

      await _firestoreService.addComment(postId, comment);
      _comments.add(comment);
      
      // Update local post comment count
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        _posts[postIndex] = _posts[postIndex].copyWith(
          commentCount: _posts[postIndex].commentCount + 1
        );
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding comment: $e");
      rethrow;
    }
  }
}
