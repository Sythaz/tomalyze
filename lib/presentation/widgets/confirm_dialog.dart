import 'package:flutter/material.dart';
import 'package:tomalyze/core/constants/app_text_styles.dart';

import '../../core/constants/app_colors.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String cancelText,
  required String confirmText,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.white,
          title: Text(title, style: AppTextStyles.bold.copyWith(fontSize: 24)),
          content: Text(content),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                cancelText,
                style: AppTextStyles.semiBold.copyWith(
                  color: AppColors.blackGrey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                confirmText,
                style: AppTextStyles.semiBold.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ) ??
      false;
}
