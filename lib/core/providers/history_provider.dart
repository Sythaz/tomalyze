import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/history_classification_model.dart';
import '../services/local_history_service.dart';

class HistoryProvider with ChangeNotifier {
  HistoryProvider() {
    loadHistory();
    _bindBoxListener();
  }
  final localHistoryService = LocalHistoryService();

  List<HistoryClassificationModel> _historyItems = [];

  List<HistoryClassificationModel> get historyItems => _historyItems;

  late final ValueListenable _boxListenable;
  VoidCallback? _boxListener;

  void _bindBoxListener() {
    final box = Hive.box<HistoryClassificationModel>('classification_history');
    _boxListenable = box.listenable();
    _boxListener = () {
      _historyItems = localHistoryService.getHistory();
      notifyListeners();
    };
    _boxListenable.addListener(_boxListener!);
  }

  Future<void> loadHistory() async {
    _historyItems = localHistoryService.getHistory();
    notifyListeners();
  }

  Future<bool> saveToHistory({
    required File imageFile,
    required String svmPrediction,
    required List<double> svmProbability,
    required String knnPrediction,
    required List<double> knnProbability,
  }) async {
    try {
      await localHistoryService.saveToHistory(
        imageFile: imageFile,
        historyItem: HistoryClassificationModel(
          svmPrediction: svmPrediction,
          svmProbability: svmProbability,
          knnPrediction: knnPrediction,
          knnProbability: knnProbability,
        ),
      );
      _historyItems = localHistoryService.getHistory();
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> clearHistory() async {
    await localHistoryService.clearHistory();
    _historyItems = [];

    notifyListeners();
  }

  Future<void> deleteHistoryItem(int index) async {
    await localHistoryService.deleteHistoryItem(index);
    _historyItems.removeAt(index);

    notifyListeners();
  }

  @override
  void dispose() {
    if (_boxListener != null) {
      _boxListenable.removeListener(_boxListener!);
    }
    super.dispose();
  }
}
