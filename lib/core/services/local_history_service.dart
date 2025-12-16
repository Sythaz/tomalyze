// ignore_for_file: avoid_print

import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tomalyze/core/models/history_classification_model.dart';
import 'package:uuid/uuid.dart';

class LocalHistoryService {
  final box = Hive.box<HistoryClassificationModel>('classification_history');

  // Ini seharusnya di service terpisah (ImageService)
  Future<String> _saveImageToLocal({required File imageFile}) async {
    // Mendapatkan direktori khusus dari os perangkat
    // Tambah subdirektori 'images' dari direktori utama
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(directory.path, 'images'));

    // Membuat direktori jika belum ada
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final filename =
        'imageClassification_${DateTime.now().millisecondsSinceEpoch}_${p.basename(imageFile.path)}';

    final savePath = p.join(imagesDir.path, filename);

    // Dilakukan penyalinan karena file yang dikirim berupa temporary file
    // Menyalin image yang dikirim ke path baru yang telah dibuat/sudah ada
    await imageFile.copy(savePath);

    return savePath;
  }

  Future<List<File>> getSavedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(directory.path, 'images'));

    if (!await imagesDir.exists()) {
      return [];
    }

    final imageFiles = imagesDir
        .listSync()
        .whereType<File>()
        .where(
          (file) => [
            '.png',
            '.jpg',
            '.jpeg',
          ].contains(p.extension(file.path).toLowerCase()),
        )
        .toList();

    return imageFiles;
  }

  Future<void> saveToHistory({
    required File imageFile,
    required HistoryClassificationModel historyItem,
  }) async {
    final String imagePath = await _saveImageToLocal(imageFile: imageFile);

    await box.add(
      HistoryClassificationModel(
        id: const Uuid().v4(),
        imagePath: imagePath,
        svmPrediction: historyItem.svmPrediction,
        svmProbability: historyItem.svmProbability,
        knnPrediction: historyItem.knnPrediction,
        knnProbability: historyItem.knnProbability,
        createdAt: DateTime.now(),
      ),
    );
  }

  List<HistoryClassificationModel> getHistory() {
    print('History length: ${box.length}');
    print('\nHistory items:');
    for (final key in box.keys) {
      final value = box.getAt(key);
      print('$key: ${value.toString()}');
    }
    return box.values.toList();
  }

  HistoryClassificationModel? getHistoryItem(int index) {
    return box.getAt(index);
  }

  Future<void> clearHistory() async {
    for (final item in box.values) {
      final file = File(item.imagePath ?? '');
      if (await file.exists()) {
        await file.delete();
      }
    }
    await box.clear();
  }

  Future<void> deleteHistoryItem(int index) async {
    final item = box.getAt(index);
    if (item == null) return;

    final imageFile = File(item.imagePath ?? '');
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
    await item.delete();
  }
}
