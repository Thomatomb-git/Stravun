import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String username;
  final double size;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.username,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final String initial = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => _buildFallback(initial),
              errorWidget: (context, url, error) => _buildFallback(initial),
            )
          : _buildFallback(initial),
    );
  }

  Widget _buildFallback(String initial) {
    return Container(
      color: AppColors.borderMuted,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.labelMd.copyWith(
          color: AppColors.textPrimary,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
