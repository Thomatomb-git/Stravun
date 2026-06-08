import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/points_display.dart';
import '../../widgets/home/streak_rank_row.dart';
import '../../widgets/home/last_run_card.dart';
import '../../widgets/home/weekly_stats_chart.dart';
import '../../widgets/home/daily_missions_section.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            final authProvider = Provider.of<AuthProvider>(context);
            
            // Show loading if needed
            if (homeProvider.isLoading || authProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accentNeon),
              );
            }

            // Provide fallback values if models are null (e.g., initial state)
            final username = homeProvider.userModel?.username ?? 'Runner';
            final points = homeProvider.userModel?.totalPoints ?? 0;
            final streak = homeProvider.userModel?.loginStreak ?? 0;
            final rank = homeProvider.userRank > 0 ? homeProvider.userRank : 0;
            final ptsToNext = homeProvider.pointsToNextRank;
            
            return RefreshIndicator(
              color: AppColors.accentNeon,
              backgroundColor: AppColors.backgroundSurface,
              onRefresh: () async {
                await homeProvider.refreshHomeData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.gutter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(username: username),
                    const SizedBox(height: AppConstants.stackMd),
                    
                    PointsDisplay(points: points),
                    const SizedBox(height: AppConstants.sectionGap),
                    
                    StreakRankRow(
                      streakDays: streak,
                      rank: rank,
                      pointsToNext: ptsToNext,
                    ),
                    const SizedBox(height: AppConstants.sectionGap),
                    
                    DailyMissionsSection(
                      missionCycle: homeProvider.currentMissions,
                      missionProgress: homeProvider.missionProgress,
                    ),
                    const SizedBox(height: AppConstants.sectionGap),
                    
                    LastRunCard(run: homeProvider.lastRun),
                    const SizedBox(height: AppConstants.sectionGap),
                    
                    WeeklyStatsChart(weeklyStats: homeProvider.weeklyStats),
                    const SizedBox(height: AppConstants.sectionGap * 2), // Bottom padding
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
