import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomalyze/core/providers/auth_provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: TextButton(
              onPressed: () {
                Provider.of<AuthenticationProvider>(
                  context,
                  listen: false,
                ).logout();
              },
              child: Text('Logout'),
            ),
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade400),
          const SizedBox(height: 10),

          // DAFTAR MEMBER
          _buildMember("Member 1"),
          _buildMember("Member 2"),
          _buildMember("Member 3"),
          _buildMember("Member 4"),
          _buildMember("Member 5"),
        ],
      ),
    );
  }

  // ================================
  //        WIDGET MEMBER
  // ================================
  Widget _buildMember(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.grey.shade300,
          ),

          const SizedBox(width: 15),

          Text(
            name,
            style: AppTextStyles.semiBold.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ================================
  //            APP BAR
  // ================================
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Profile",
        style: AppTextStyles.bold.copyWith(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
