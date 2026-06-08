import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';


class AuthProvider extends ChangeNotifier {
  User? _user;
  UserModel? _userModel;

  User? get currentUser => _user;
  UserModel? get userModel => _userModel;
  bool get isLoggedIn => true; // BYPASSED
  bool get isLoading => false; // BYPASSED

  AuthProvider() {
    _init();
  }

  void _init() {
    _userModel = UserModel(
      uid: 'dummy-uid-123',
      username: 'Test User',
      email: 'test@example.com',
      totalPoints: 150,
      loginStreak: 5,
      lastLoginDate: DateTime.now(),
      weeklyDistanceResetDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

}
