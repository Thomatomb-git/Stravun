import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';

class HomeHeader extends StatelessWidget {
  final String username;

  const HomeHeader({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.stackMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hi, $username',
            style: AppTextStyles.headlineLg,
          ),
        ],
      ),
    );
  }
}
