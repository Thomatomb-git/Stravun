import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserModel? _userModel;
  bool _isLoading = true;

  User? get currentUser => _user;
  UserModel? get userModel => _userModel;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        _isLoading = true;
        notifyListeners();
        
        // Fetch user model from Firestore
        _userModel = await _firestoreService.getUser(user.uid);
        
        // Self-heal: If user is authenticated but Firestore doc is missing or missing fields
        if (_userModel == null) {
          final recoveredUser = UserModel(
            uid: user.uid,
            username: user.displayName ?? user.email?.split('@').first ?? 'Runner',
            email: user.email ?? '',
            lastLoginDate: DateTime.now(),
            weeklyDistanceResetDate: DateTime.now(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _firestoreService.createUser(recoveredUser);
          _userModel = recoveredUser;
        } else {
          // Ensure all default fields (like totalPoints) are written back if they were missing in old documents
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(_userModel!.toMap(), SetOptions(merge: true));
        }

        // Update login streak
        if (_userModel != null) {
          await _firestoreService.updateLoginStreak(user.uid);
          // Refetch to get updated streak
          _userModel = await _firestoreService.getUser(user.uid);
        }
      } else {
        _userModel = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  Future<void> register(String username, String email, String password) async {
    await _authService.registerWithEmail(username, email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
