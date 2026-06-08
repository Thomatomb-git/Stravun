import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/community_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/community/leaderboard_category_chips.dart';
import '../../widgets/community/leaderboard_podium.dart';
import '../../widgets/community/leaderboard_list_item.dart';
import '../../widgets/community/leaderboard_current_user_bar.dart';

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        final authProvider = Provider.of<AuthProvider>(context);
        final currentUserModel = authProvider.userModel;

        if (provider.isLoadingLeaderboard && provider.leaderboardUsers.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accentNeon),
          );
        }

        final users = provider.leaderboardUsers;
        final top3 = users.take(3).toList();
        final rest = users.skip(3).toList();

        return Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: AppConstants.stackMd),
                LeaderboardCategoryChips(
                  selectedCategory: provider.selectedCategory,
                  onCategorySelected: (category) {
                    provider.fetchLeaderboard(category);
                  },
                ),
                const SizedBox(height: AppConstants.sectionGap),
                LeaderboardPodium(
                  topUsers: top3,
                  category: provider.selectedCategory,
                ),
                const SizedBox(height: AppConstants.stackLg),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: currentUserModel != null ? 100 : AppConstants.stackLg,
                    ),
                    itemCount: rest.length,
                    itemBuilder: (context, index) {
                      final user = rest[index];
                      final rank = index + 4;
                      final isCurrentUser = currentUserModel?.uid == user.uid;

                      return LeaderboardListItem(
                        user: user,
                        rank: rank,
                        category: provider.selectedCategory,
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  ),
                ),
              ],
            ),
            if (currentUserModel != null && provider.currentUserRank > 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: LeaderboardCurrentUserBar(
                  user: currentUserModel,
                  rank: provider.currentUserRank,
                  category: provider.selectedCategory,
                ),
              ),
          ],
        );
      },
    );
  }
}
