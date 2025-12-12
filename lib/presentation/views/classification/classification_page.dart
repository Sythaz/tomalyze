import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tomalyze/presentation/widgets/custom_button.dart';
import 'package:tomalyze/presentation/widgets/custom_section.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../widgets/confirm_dialog.dart';

class ClassificationPage extends StatefulWidget {
  final File? photo;
  const ClassificationPage({super.key, this.photo});

  @override
  State<ClassificationPage> createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  final Map<String, String> _labelMeansText = {
    'ripe':
        'A ripe tomato is at its peak flavor and is ready for immediate consumption. It should be firm to the touch but have a slight give, with a vibrant, uniform color.',
    'halfRipe':
        'A half-ripe tomato is in the process of ripening. It may have a mix of green and red colors, indicating that it is not yet fully mature. The texture is firmer than a ripe tomato, and the flavor is less developed.',
    'unripe':
        'An unripe tomato is not yet ready for consumption. It is typically green in color and very firm to the touch. The flavor is sour and lacks the sweetness and juiciness of a ripe tomato. Unripe tomatoes are often used in cooking, such as in fried green tomato recipes.',
  };
  final List<int> meanText = [];

  List<ClassificationData> classifications = [
    ClassificationData(
      method: ClassificationMethod.svm,
      label: ClassificationLabel.ripe,
      percentage: 0.92,
    ),
    ClassificationData(
      method: ClassificationMethod.svm,
      label: ClassificationLabel.halfRipe,
      percentage: 0.06,
    ),
    ClassificationData(
      method: ClassificationMethod.svm,
      label: ClassificationLabel.unripe,
      percentage: 0.02,
    ),
    ClassificationData(
      method: ClassificationMethod.knn,
      label: ClassificationLabel.ripe,
      percentage: 0.88,
    ),
    ClassificationData(
      method: ClassificationMethod.knn,
      label: ClassificationLabel.unripe,
      percentage: 0.02,
    ),
    ClassificationData(
      method: ClassificationMethod.knn,
      label: ClassificationLabel.halfRipe,
      percentage: 0.10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBg,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      widget.photo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.image,
                            size: 100,
                            color: AppColors.textGrey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ripe',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackGrey,
                  ),
                ),
                const SizedBox(height: 24),

                _buildClassificationCard(
                  title: 'SVM Classification',
                  method: ClassificationMethod.svm,
                ),
                const SizedBox(height: 16),

                _buildClassificationCard(
                  title: 'KNN Classification',
                  method: ClassificationMethod.knn,
                ),
                const SizedBox(height: 24),

                CustomSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What this means',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getFinalLabelText(meanText),
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: Text(
                    'Save to History',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  backgroundColor: AppColors.primaryRed,
                  onTap: () {
                    //
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getFinalLabelText(List<int> meanText) {
    final counts = {
      0: meanText.where((e) => e == 0).length,
      1: meanText.where((e) => e == 1).length,
      2: meanText.where((e) => e == 2).length,
    };

    final maxCount = counts.values.reduce((a, b) => a > b ? a : b);
    final majorityLabel = counts.entries
        .firstWhere((e) => e.value == maxCount)
        .key;

    switch (majorityLabel) {
      case 0:
        return _labelMeansText['ripe']!;
      case 1:
        return _labelMeansText['halfRipe']!;
      case 2:
        return _labelMeansText['unripe']!;
      default:
        return 'Unknown';
    }
  }

  Widget _buildClassificationCard({
    required String title,
    required ClassificationMethod method,
  }) {
    final highest = classifications
        .where((c) => c.method == method)
        .reduce((a, b) => a.percentage > b.percentage ? a : b);
    meanText.add(highest.label.index);

    return CustomSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.blackGrey,
            ),
          ),
          const SizedBox(height: 20),
          ...classifications
              .where((classification) => classification.method == method)
              .map(
                (classification) => ClassificationData(
                  method: classification.method,
                  label: classification.label,
                  percentage: classification.percentage,
                  isHighest:
                      classification.percentage ==
                      classifications
                          .where((c) => c.method == method)
                          .map((c) => c.percentage)
                          .reduce((a, b) => a > b ? a : b),
                ),
              )
              .toList()
              .map((data) => _buildProgressBar(data)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ClassificationData data) {
    Color colorLogic = data.isHighest
        ? AppColors.blackGrey
        : AppColors.blackGrey.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.label == ClassificationLabel.ripe
                    ? 'Ripe'
                    : data.label == ClassificationLabel.halfRipe
                    ? 'Half-ripe'
                    : 'Unripe',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorLogic,
                ),
              ),
              Text(
                '${(data.percentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: colorLogic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: data.percentage,
              backgroundColor: AppColors.textFieldBg,
              valueColor: AlwaysStoppedAnimation<Color>(
                data.isHighest ? AppColors.primaryRed : AppColors.textGrey,
              ),
              minHeight: 8,
            ),
          ),
        ],
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
          final isExit = await showConfirmationDialog(
            context: context,
            title: 'Konfirmasi',
            content:
                'Apakah Anda yakin ingin keluar?\nHasil klasifikasi yang telah ditampilkan tidak akan disimpan.',
            cancelText: 'Batal',
            confirmText: 'Ya, Keluar',
          );
          if (isExit) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        'Classification Result',
        style: AppTextStyles.bold.copyWith(fontSize: 16),
      ),
    );
  }
}

enum ClassificationMethod { svm, knn }

enum ClassificationLabel { ripe, halfRipe, unripe }

class ClassificationData {
  final ClassificationMethod method;
  final ClassificationLabel label;
  final double percentage;
  final bool isHighest;

  const ClassificationData({
    this.isHighest = false,
    required this.method,
    required this.label,
    required this.percentage,
  });
}
