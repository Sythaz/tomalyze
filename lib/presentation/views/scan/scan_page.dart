import 'package:flutter/material.dart';
import 'package:tomalyze/core/constants/app_colors.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.red,
            child: const Center(child: Text('Scan Page')),
          ),
        ),
      ),
    );
  }
}
