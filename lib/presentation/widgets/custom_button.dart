import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Text text;
  final Widget? icon;
  final Color backgroundColor;
  final Color? shadowColor;
  final Size? size;
  final Function() onTap;
  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    required this.backgroundColor,
    this.shadowColor,
    this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: size ?? const Size(double.infinity, 60),
        shadowColor: shadowColor?.withValues(alpha: 0.6) ?? Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const SizedBox.shrink(),
          const SizedBox(width: 10),
          text,
        ],
      ),
    );
  }
}
