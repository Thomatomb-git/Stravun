import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../models/user_model.dart';
import '../../providers/community_provider.dart';
import 'leaderboard_list_item.dart';

class LeaderboardCurrentUserBar extends StatelessWidget {
  final UserModel user;
  final int rank;
  final LeaderboardCategory category;

  const LeaderboardCurrentUserBar({
    super.key,
    required this.user,
    required this.rank,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.stackSm),
          child: LeaderboardListItem(
            user: user,
            rank: rank,
            category: category,
            isCurrentUser: true,
          ),
        ),
      ),
    );
  }
}
