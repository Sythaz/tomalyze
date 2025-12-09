import 'package:flutter/material.dart';
import 'package:tomalyze/core/constants/app_colors.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.red,
            child: const Center(child: Text('Upload Page')),
          ),
        ),
      ),
    );
  }
}
