/// Model untuk hasil analisis kematangan tomat
class TomatoAnalysis {
  final String filename;
  final String? predictionModel; // "SVM" atau "KNN" untuk endpoint single
  final String? prediction; // Hasil prediksi untuk endpoint single
  final List<double>? probability; // Probability untuk endpoint single

  // Untuk endpoint /predict-all
  final String? svmPrediction;
  final List<double>? svmProb;
  final String? knnPrediction;
  final List<double>? knnProb;

  TomatoAnalysis({
    required this.filename,
    this.predictionModel,
    this.prediction,
    this.probability,
    this.svmPrediction,
    this.svmProb,
    this.knnPrediction,
    this.knnProb,
  });

  /// Factory constructor untuk parsing dari JSON response backend
  factory TomatoAnalysis.fromJson(Map<String, dynamic> json) {
    return TomatoAnalysis(
      filename: json['filename'] ?? '',
      predictionModel: json['prediction_model'],
      prediction: json['prediction'],
      probability: json['probability'] != null
          ? List<double>.from(json['probability'])
          : null,
      svmPrediction: json['svm_prediction'],
      svmProb:
          json['svm_prob'] != null ? List<double>.from(json['svm_prob']) : null,
      knnPrediction: json['knn_prediction'],
      knnProb:
          json['knn_prob'] != null ? List<double>.from(json['knn_prob']) : null,
    );
  }

  /// Convert ke JSON (jika perlu disimpan)
  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'prediction_model': predictionModel,
      'prediction': prediction,
      'probability': probability,
      'svm_prediction': svmPrediction,
      'svm_prob': svmProb,
      'knn_prediction': knnPrediction,
      'knn_prob': knnProb,
    };
  }

  /// Helper method untuk mendapatkan label yang lebih user-friendly
  String getMaturityLabel(String? prediction) {
    if (prediction == null) return 'Unknown';
    
    switch (prediction.toLowerCase()) {
      case 'ripe':
        return 'Matang';
      case 'unripe':
        return 'Belum Matang';
      case 'half-ripe':
        return 'Setengah Matang';
      default:
        return prediction;
    }
  }

  /// Mendapatkan confidence score (probability tertinggi)
  double? getConfidenceScore(List<double>? prob) {
    if (prob == null || prob.isEmpty) return null;
    return prob.reduce((a, b) => a > b ? a : b) * 100;
  }
}
