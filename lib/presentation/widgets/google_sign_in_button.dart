import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const GoogleSignInButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.textFieldBg,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      label: Center(
        child: Text('Lanjutkan melalui Google', style: AppTextStyles.regular),
      ),
      iconAlignment: IconAlignment.start,
      icon: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Image.asset(
          'assets/icon/google_logo.png',
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
