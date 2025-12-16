import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:tomalyze/core/providers/auth_provider.dart';
import 'package:tomalyze/core/providers/local_auth_provider.dart';
import 'package:tomalyze/presentation/views/auth/login_page.dart';

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
    final authUser = context.watch<AuthenticationProvider>().currentUser;
    final displayName = authUser?.displayName?.trim();
    final email = authUser?.email?.trim();
    final userName = (displayName != null && displayName.isNotEmpty)
        ? displayName
        : (email != null && email.isNotEmpty ? email : 'Pengguna');

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // FOTO PROFIL
                ProfilePicture(name: userName, radius: 70, fontsize: 32),

                const SizedBox(height: 20),

                // NAMA USER
                Text(
                  userName,
                  style: AppTextStyles.bold.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // CARD TEAM INFO
                _buildTeamInfoCard(),

                const SizedBox(height: 30),

                // ===========================
                //      LOGOUT BUTTON
                // ===========================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () async {
                      await context.read<AuthenticationProvider>().logout();
                      // ignore: use_build_context_synchronously
                      await context.read<LocalAuthProvider>().logout();

                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: AppTextStyles.bold.copyWith(
                            color: AppColors.blackGrey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================
  //        WIDGET TEAM INFO
  // ================================
  Widget _buildTeamInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER TEAM INFO
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Team Info",
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 20,
                      color: AppColors.blackGrey,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Group 4 with 5 member",
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade300,
                child: Image.asset(
                  'assets/icon/app-icon.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade400),
          const SizedBox(height: 10),

          // DAFTAR MEMBER
          _buildMember("Muhammad Syafiq Aldiansyah"),
          _buildMember("Anugerah Rachmadani"),
          _buildMember("Febriansyah adi nugroho"),
          _buildMember("Muhammad Adityo Rahman"),
          _buildMember("Stevan Zaky Setyanto"),
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
          ProfilePicture(name: name, radius: 15, fontsize: 12),

          const SizedBox(width: 15),

          Text(
            name,
            style: AppTextStyles.semiBold.copyWith(
              fontSize: 16,
              color: AppColors.blackGrey,
            ),
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
        icon: const Icon(Icons.close_rounded, fontWeight: FontWeight.bold),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "Profile",
        style: AppTextStyles.bold.copyWith(
          fontSize: 16,
          color: AppColors.blackGrey,
        ),
      ),
    );
  }
}
