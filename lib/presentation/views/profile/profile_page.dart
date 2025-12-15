import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // FOTO PROFIL
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                // NAMA USER
                Text(
                  "Nama User",
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 20,
                  ),
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
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: AppTextStyles.bold.copyWith(
                            color: Colors.black,
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
                    style: AppTextStyles.semiBold.copyWith(fontSize: 20),
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
                child: null,
              ),
            ],
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
