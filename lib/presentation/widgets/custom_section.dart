import 'package:flutter/material.dart';
import 'package:tomalyze/core/constants/app_colors.dart';

class CustomSection extends StatelessWidget {
  const CustomSection({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textGrey.withValues(alpha: 0.4),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
