import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomalyze/core/constants/app_colors.dart';
import 'package:tomalyze/core/constants/app_icons.dart';
import 'package:tomalyze/core/constants/app_text_styles.dart';
import 'package:tomalyze/presentation/widgets/custom_button.dart';
import 'package:tomalyze/presentation/widgets/custom_section.dart';

import '../scan/scan_page.dart';
import '../upload/upload_page.dart';
import '../classification/classification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _recentScans = [
    {'stage': 'Ripe', 'time': 'Scanned 2 hours ago', 'score': '90%'},
    {'stage': 'Half-ripe', 'time': 'Scanned 5 hours ago', 'score': '75%'},
    {'stage': 'Unripe', 'time': 'Scanned 1 day ago', 'score': '20%'},
    {'stage': 'Ripe', 'time': 'Scanned 3 days ago', 'score': '88%'},
    {'stage': 'Half-ripe', 'time': 'Scanned 5 days ago', 'score': '60%'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icon/app-icon.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Welcome, ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}!',
                        style: AppTextStyles.bold.copyWith(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Ready to check if your tomatoes are perfectly ripe for harvest?',
                  style: AppTextStyles.regular.copyWith(
                    fontSize: 15,
                    color: AppColors.blackGrey.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: Text(
                    'Scan Tomato',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    AppIcons.camera,
                    width: 25,
                    height: 25,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  backgroundColor: AppColors.primaryRed,
                  shadowColor: AppColors.primaryRed.withValues(alpha: 0.6),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: Text(
                    'Upload Image',
                    style: AppTextStyles.bold.copyWith(fontSize: 16),
                  ),
                  icon: SvgPicture.asset(
                    AppIcons.image,
                    width: 25,
                    height: 25,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blackGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                  backgroundColor: AppColors.white,
                  shadowColor: AppColors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: Text(
                    'Analisis Backend (ML)',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  icon: const Icon(
                    Icons.psychology,
                    color: AppColors.white,
                    size: 25,
                  ),
                  backgroundColor: AppColors.successGreen,
                  shadowColor: AppColors.successGreen.withValues(alpha: 0.6),
                  onTap: () async {
                    // Pilih gambar dulu sebelum navigasi ke ClassificationPage
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    
                    if (image != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassificationPage(
                            photo: File(image.path),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                CustomSection(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.infoBlue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          AppIcons.info,
                          color: AppColors.infoBlue,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              'How it works?',
                              style: AppTextStyles.bold.copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Simply take a photo or upload an image of your tomato. Our model will analyze the ripeness and give you instant results with accuracy scores.',
                              style: AppTextStyles.regular.copyWith(
                                fontSize: 14,
                              ),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                CustomSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ripeness Stages',
                        style: AppTextStyles.bold.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: customBadge(
                              backgroundColor: AppColors.successGreen,
                              text: 'Unripe',
                            ),
                          ),
                          const SizedBox(width: 10),
                          ripenessText(
                            title: 'Green',
                            titleColor: AppColors.successGreen,
                            description: ' - Not yet ripe',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: customBadge(
                              backgroundColor: AppColors.warningOrange,
                              text: 'Half-ripe',
                            ),
                          ),
                          const SizedBox(width: 10),
                          ripenessText(
                            title: 'Oranye',
                            titleColor: AppColors.warningOrange,
                            description: ' - Ripening in progress',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: customBadge(
                              backgroundColor: AppColors.errorRed,
                              text: 'Ripe',
                            ),
                          ),
                          const SizedBox(width: 10),
                          ripenessText(
                            title: 'Red',
                            titleColor: AppColors.errorRed,
                            description: ' - Ready to eat',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Scans',
                      style: AppTextStyles.bold.copyWith(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: Text(
                        'Show all',
                        style: AppTextStyles.bold.copyWith(
                          fontSize: 12,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    ..._recentScans.asMap().entries.take(3).map((entry) {
                      final index = entry.key;
                      final scan = entry.value;
                      return Container(
                        margin: index != 0
                            ? const EdgeInsets.only(top: 10)
                            : null,
                        child: CustomSection(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icon/app-icon.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        scan['stage'] ?? '',
                                        style: AppTextStyles.bold.copyWith(
                                          fontSize: 12,
                                          color: scan['stage'] == 'Ripe'
                                              ? AppColors.errorRed
                                              : (scan['stage'] == 'Unripe'
                                                    ? AppColors.successGreen
                                                    : AppColors.warningOrange),
                                        ),
                                      ),
                                      Text(
                                        scan['time'] ?? '',
                                        style: AppTextStyles.regular.copyWith(
                                          fontSize: 12,
                                          color: AppColors.blackGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              customBadge(
                                backgroundColor: AppColors.primaryRed,
                                text: scan['score'] ?? '',
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (_recentScans.length > 3) const SizedBox(height: 10),
                    if (_recentScans.length > 3)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          //
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: Text(
                            'And more..',
                            style: AppTextStyles.regular.copyWith(
                              fontSize: 12,
                              color: AppColors.blackGrey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  RichText ripenessText({
    required String title,
    required Color titleColor,
    required String description,
  }) {
    return RichText(
      text: TextSpan(
        text: title,
        style: AppTextStyles.bold.copyWith(fontSize: 12, color: titleColor),
        children: <TextSpan>[
          TextSpan(
            text: description,
            style: AppTextStyles.regular.copyWith(
              fontSize: 12,
              color: AppColors.blackGrey,
            ),
          ),
        ],
      ),
    );
  }

  Container customBadge({
    required Color backgroundColor,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(text, style: AppTextStyles.semiBold.copyWith(fontSize: 12)),
      ),
    );
  }
}
