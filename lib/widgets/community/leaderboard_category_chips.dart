import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../providers/community_provider.dart';

class LeaderboardCategoryChips extends StatelessWidget {
  final LeaderboardCategory selectedCategory;
  final Function(LeaderboardCategory) onCategorySelected;

  const LeaderboardCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.gutter),
      child: Row(
        children: [
          _buildChip(
            title: 'Total Points',
            category: LeaderboardCategory.totalPoints,
          ),
          const SizedBox(width: AppConstants.stackSm),
          _buildChip(
            title: 'Login Streak',
            category: LeaderboardCategory.loginStreak,
          ),
          const SizedBox(width: AppConstants.stackSm),
          _buildChip(
            title: 'Weekly Distance',
            category: LeaderboardCategory.weeklyDistance,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({required String title, required LeaderboardCategory category}) {
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentNeon : AppColors.backgroundSurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        ),
        child: Text(
          title,
          style: AppTextStyles.labelMd.copyWith(
            color: isSelected ? AppColors.backgroundPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
