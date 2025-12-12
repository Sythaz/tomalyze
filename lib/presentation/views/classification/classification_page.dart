import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tomalyze/presentation/widgets/custom_button.dart';
import 'package:tomalyze/presentation/widgets/custom_section.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/tomato_analysis.dart';
import '../../../core/services/tomato_api_service.dart';
import '../../widgets/confirm_dialog.dart';

class ClassificationPage extends StatefulWidget {
  final File? photo;
  const ClassificationPage({super.key, this.photo});

  @override
  State<ClassificationPage> createState() => _ClassificationPageState();
}

class _ClassificationPageState extends State<ClassificationPage> {
  final TomatoApiService _apiService = TomatoApiService();
  final Map<String, String> _labelMeansText = {
    'Matang':
        'A ripe tomato is at its peak flavor and is ready for immediate consumption. It should be firm to the touch but have a slight give, with a vibrant, uniform color.',
    'Belum Matang':
        'An unripe tomato is not yet ready for consumption. It is typically green in color and very firm to the touch. The flavor is sour and lacks the sweetness and juiciness of a ripe tomato.',
  };
  final List<String> meanText = [];

  bool _isLoading = true;
  String? _errorMessage;
  TomatoAnalysis? _analysisResult;

  List<ClassificationData> classifications = [];

  @override
  void initState() {
    super.initState();
    _performAnalysis();
  }

  Future<void> _performAnalysis() async {
    if (widget.photo == null) {
      setState(() {
        _errorMessage = 'No photo provided';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call backend API with both SVM and KNN
      final result = await _apiService.predictWithBoth(widget.photo!);
      
      setState(() {
        _analysisResult = result;
        _isLoading = false;
        _parseAnalysisToClassifications();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _parseAnalysisToClassifications() {
    if (_analysisResult == null) return;

    classifications.clear();

    // Parse SVM results
    if (_analysisResult!.svmPrediction != null && _analysisResult!.svmProb != null) {
      final svmProb = _analysisResult!.svmProb!;
      classifications.addAll([
        ClassificationData(
          method: ClassificationMethod.svm,
          label: _analysisResult!.svmPrediction!,
          percentage: svmProb.isNotEmpty ? svmProb[0] : 0.0,
        ),
        ClassificationData(
          method: ClassificationMethod.svm,
          label: _analysisResult!.svmPrediction == 'Matang' ? 'Belum Matang' : 'Matang',
          percentage: svmProb.length > 1 ? svmProb[1] : 0.0,
        ),
      ]);
    }

    // Parse KNN results
    if (_analysisResult!.knnPrediction != null && _analysisResult!.knnProb != null) {
      final knnProb = _analysisResult!.knnProb!;
      classifications.addAll([
        ClassificationData(
          method: ClassificationMethod.knn,
          label: _analysisResult!.knnPrediction!,
          percentage: knnProb.isNotEmpty ? knnProb[0] : 0.0,
        ),
        ClassificationData(
          method: ClassificationMethod.knn,
          label: _analysisResult!.knnPrediction == 'Matang' ? 'Belum Matang' : 'Matang',
          percentage: knnProb.length > 1 ? knnProb[1] : 0.0,
        ),
      ]);
    }
  }

  String _getPredictionLabel() {
    if (_analysisResult?.svmPrediction != null) {
      return _analysisResult!.svmPrediction!;
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(context),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primaryRed),
              SizedBox(height: 16),
              Text('Analyzing tomato...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: $_errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: Text(
                    'Try Again',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  backgroundColor: AppColors.primaryRed,
                  onTap: _performAnalysis,
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                Text(
                  _getPredictionLabel(),
                  style: const TextStyle(
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
                      const Text(
                        'What this means',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getFinalLabelText(),
                        style: const TextStyle(
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

  String _getFinalLabelText() {
    // Count majority prediction from both models
    if (_analysisResult?.svmPrediction != null) {
      meanText.add(_analysisResult!.svmPrediction!);
    }
    if (_analysisResult?.knnPrediction != null) {
      meanText.add(_analysisResult!.knnPrediction!);
    }

    final matangCount = meanText.where((e) => e == 'Matang').length;
    final belumMatangCount = meanText.where((e) => e == 'Belum Matang').length;

    final majorityLabel = matangCount > belumMatangCount ? 'Matang' : 'Belum Matang';
    
    return _labelMeansText[majorityLabel] ?? 'Unknown classification';
  }

  Widget _buildClassificationCard({
    required String title,
    required ClassificationMethod method,
  }) {
    final methodClassifications = classifications
        .where((c) => c.method == method)
        .toList();

    if (methodClassifications.isEmpty) {
      return const SizedBox.shrink();
    }

    final highest = methodClassifications
        .reduce((a, b) => a.percentage > b.percentage ? a : b);

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
          ...methodClassifications
              .map((classification) => ClassificationData(
                    method: classification.method,
                    label: classification.label,
                    percentage: classification.percentage,
                    isHighest: classification.percentage == highest.percentage,
                  ))
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
                data.label,
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
        icon: const Icon(Icons.close_rounded),
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

class ClassificationData {
  final ClassificationMethod method;
  final String label;
  final double percentage;
  final bool isHighest;

  const ClassificationData({
    this.isHighest = false,
    required this.method,
    required this.label,
    required this.percentage,
  });
}
