import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Not logged in")));
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accentNeon));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final name = data['username'] ?? 'Runner';
          
          final totalDistance = (data['totalDistance'] as num?)?.toDouble() ?? 0.0;
          final totalRuns = (data['totalRuns'] as num?)?.toInt() ?? 0;
          final loginStreak = (data['loginStreak'] as num?)?.toInt() ?? 0;
          final totalPoints = (data['totalPoints'] as num?)?.toInt() ?? 0;
          final highestPace = (data['highestPace'] as num?)?.toDouble() ?? 0.0;

          return SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 44, 24, 36),
                  color: AppColors.backgroundSurface, // Replaced header color
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 54, 
                        backgroundColor: AppColors.borderMuted, 
                        child: Icon(Icons.person, size: 60, color: Colors.white)
                      ),
                      const SizedBox(height: 20),
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                      Text(user.email ?? '', style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 110,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileEditScreen())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.borderMuted,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
                          ),
                          child: const Text('edit'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        const Text('YOUR STATS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: AppColors.backgroundSurface, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              Row(children: [
                                profileStat(Icons.directions_run, highestPace.toStringAsFixed(2), 'BEST PACE (MIN/KM)'),
                                profileStat(Icons.workspace_premium, totalPoints.toString(), 'TOTAL POINTS', iconColor: AppColors.tierGold),
                              ]),
                              const SizedBox(height: 34),
                              Row(children: [
                                profileStat(Icons.map_outlined, totalDistance.toStringAsFixed(1), 'KM TOTAL DISTANCE'),
                                profileStat(Icons.bolt, loginStreak.toString(), 'DAY STREAK', iconColor: AppColors.accentNeon),
                              ]),
                              const SizedBox(height: 34),
                              Row(children: [
                                profileStat(Icons.directions_run, totalRuns.toString(), 'TOTAL RUNS'),
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity, 
                          child: OutlinedButton(
                            onPressed: () => authProvider.signOut(), 
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error)
                            ),
                            child: const Text('Logout')
                          )
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget profileStat(IconData icon, String value, String label, {Color iconColor = Colors.white}) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 34),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
