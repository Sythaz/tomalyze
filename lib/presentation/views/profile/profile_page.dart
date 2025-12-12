import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomalyze/core/providers/auth_provider.dart';

import '../../../core/constants/app_colors.dart';

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
        ),
      ),
    );
  }
}
