import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'leaderboard_tab.dart'; 
import 'forum_tab.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          title: Text(
            'STRAVUN',
            style: AppTextStyles.headlineMd.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 1.2,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.accentNeon,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Leaderboard'),
              Tab(text: 'Forum'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LeaderboardTab(),
            ForumTab(),
          ],
        ),
      ),
    );
  }
}
