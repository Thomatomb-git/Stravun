import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

import '../../providers/auth_provider.dart';
import '../../config/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  bool loading = false;

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).register(nameC.text.trim(), emailC.text.trim(), passwordC.text);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      showMessage(_getAuthErrorMessage(e));
    }
    if (mounted) setState(() => loading = false);
  }

  String _getAuthErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Password is too weak. Use at least 6 characters.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        default:
          return 'Registration failed. Please try again.';
      }
    }
    return 'Registration failed. Please try again.';
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget input(TextEditingController controller, String hint, {bool obscure = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.backgroundSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                const SizedBox(height: 24),
                const Text('Create Account', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                const Text('Start tracking your running progress.', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 36),
                input(nameC, 'Full Name', validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Full name is required.';
                  if (value.trim().length < 3) return 'Name must be at least 3 characters.';
                  return null;
                }),
                const SizedBox(height: 16),
                input(emailC, 'Email', validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required.';
                  if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email address.';
                  return null;
                }),
                const SizedBox(height: 16),
                input(passwordC, 'Password', obscure: true, validator: (value) {
                  if (value == null || value.isEmpty) return 'Password is required.';
                  if (value.length < 6) return 'Password must be at least 6 characters.';
                  return null;
                }),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: loading ? null : handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentNeon,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: loading ? const CircularProgressIndicator() : const Text('Register', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
