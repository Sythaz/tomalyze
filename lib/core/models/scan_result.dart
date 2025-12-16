// File: lib/core/models/scan_result.dart

class ScanResult {
  final String filename;
  final String svmPrediction;
  final List<double>? svmProbability;
  final String knnPrediction;
  final List<double>? knnProbability;
  final DateTime createdAt;

  ScanResult({
    required this.filename,
    required this.svmPrediction,
    this.svmProbability,
    required this.knnPrediction,
    this.knnProbability,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert dari JSON response backend
  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      filename: json['filename'] ?? '',
      svmPrediction: json['svm_prediction'] ?? '',
      svmProbability: json['svm_prob'] != null
          ? List<double>.from(json['svm_prob'])
          : null,
      knnPrediction: json['knn_prediction'] ?? '',
      knnProbability: json['knn_prob'] != null
          ? List<double>.from(json['knn_prob'])
          : null,
    );
  }

  // Convert ke JSON untuk disimpan
  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'svm_prediction': svmPrediction,
      'svm_prob': svmProbability,
      'knn_prediction': knnPrediction,
      'knn_prob': knnProbability,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper untuk mendapatkan label final (mayoritas)
  String get finalPrediction {
    // Jika kedua model sepakat
    if (svmPrediction == knnPrediction) {
      return svmPrediction;
    }

    // Jika berbeda, ambil yang probabilitas lebih tinggi
    final svmMaxProb = svmProbability?.reduce((a, b) => a > b ? a : b) ?? 0.0;
    final knnMaxProb = knnProbability?.reduce((a, b) => a > b ? a : b) ?? 0.0;

    return svmMaxProb > knnMaxProb ? svmPrediction : knnPrediction;
  }

  // Helper untuk mendapatkan confidence score
  double get confidenceScore {
    final svmMaxProb = svmProbability?.reduce((a, b) => a > b ? a : b) ?? 0.0;
    final knnMaxProb = knnProbability?.reduce((a, b) => a > b ? a : b) ?? 0.0;

    return ((svmMaxProb + knnMaxProb) / 2) * 100;
  }
}
