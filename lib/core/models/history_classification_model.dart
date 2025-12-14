import 'package:hive_flutter/hive_flutter.dart';

part 'history_classification_model.g.dart';

@HiveType(typeId: 0)
class HistoryClassificationModel extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? imagePath;
  @HiveField(2)
  final String svmPrediction;
  @HiveField(3)
  final List<double> svmProbability;
  @HiveField(4)
  final String knnPrediction;
  @HiveField(5)
  final List<double> knnProbability;
  @HiveField(6)
  final DateTime? createdAt;

  HistoryClassificationModel({
    this.id,
    this.imagePath,
    required this.svmPrediction,
    required this.svmProbability,
    required this.knnPrediction,
    required this.knnProbability,
    this.createdAt,
  });

  @override
  String toString() {
    return 'HistoryClassificationModel{\nid: $id,\nimagePath: $imagePath,\nsvmPrediction: $svmPrediction,\nsvmProbability: $svmProbability,\nknnPrediction: $knnPrediction,\nknnProbability: $knnProbability,\ncreatedAt: $createdAt\n}';
  }
}
