import 'package:flutter/material.dart';
import 'package:tomalyze/core/constants/app_colors.dart';

class AppTextStyles {
  static const String _font = 'Montserrat';

  static const light = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w300,
    color: AppColors.blackGrey,
  );

  static const regular = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w400,
    color: AppColors.blackGrey,
  );

  static const medium = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w500,
    color: AppColors.blackGrey,
  );

  static const semiBold = TextStyle(
    fontFamily: _font,
    fontWeight: FontWeight.w600,
    color: AppColors.blackGrey,
  );

  static const bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: _font,
    color: AppColors.blackGrey,
  );
}
