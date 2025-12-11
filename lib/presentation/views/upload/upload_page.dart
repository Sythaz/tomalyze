import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomalyze/core/constants/app_colors.dart';
import 'package:tomalyze/core/constants/app_icons.dart';
import 'package:tomalyze/presentation/views/scan/scan_page.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_button.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload a photo of the tomato',
                style: AppTextStyles.bold.copyWith(fontSize: 32, height: 1.2),
              ),
              const SizedBox(height: 10),
              Text(
                'Note: The picture should be tomato with black background',
                style: AppTextStyles.regular.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.primaryRed, width: 3),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: _selectedImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcons.image, height: 28),
                            const SizedBox(height: 5),
                            Text(
                              'Select file',
                              style: AppTextStyles.medium.copyWith(
                                fontSize: 16,
                                color: AppColors.blackGrey,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: Text(
                  'Scan Tomato',
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 16,
                    color: AppColors.blackGrey,
                  ),
                ),
                icon: SvgPicture.asset(
                  AppIcons.camera,
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blackGrey,
                    BlendMode.srcIn,
                  ),
                ),
                backgroundColor: AppColors.buttonPink,
                shadowColor: AppColors.primaryRed,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomButton(
            text: Text(
              'Continue',
              style: AppTextStyles.bold.copyWith(
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
            backgroundColor: AppColors.primaryRed,
            shadowColor: AppColors.primaryRed.withValues(alpha: 0.6),
            onTap: () {
              if (_selectedImage == null) {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Uhm...',
                    message: 'Please upload a photo first',

                    contentType: ContentType.failure,
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              }
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, fontWeight: FontWeight.bold),
        onPressed: () async {
          if (_selectedImage == null) return Navigator.pop(context);

          final isExit = await showConfirmationDialog(
            context: context,
            title: 'Konfirmasi',
            content:
                'Apakah Anda yakin ingin keluar?\nFoto yang telah diambil mungkin akan hilang.',
            cancelText: 'Batal',
            confirmText: 'Ya, Keluar',
          );
          if (isExit) {
            _selectedImage = null;
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        'Upload Image',
        style: AppTextStyles.bold.copyWith(fontSize: 16),
      ),
    );
  }
}
