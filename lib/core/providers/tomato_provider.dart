import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/tomato_analysis.dart';
import '../services/tomato_api_service.dart';

/// Provider untuk mengelola state analisis tomat
class TomatoProvider extends ChangeNotifier {
  final TomatoApiService _apiService = TomatoApiService();

  // State
  bool _isLoading = false;
  TomatoAnalysis? _currentAnalysis;
  String? _errorMessage;
  File? _selectedImage;

  // Getters
  bool get isLoading => _isLoading;
  TomatoAnalysis? get currentAnalysis => _currentAnalysis;
  String? get errorMessage => _errorMessage;
  File? get selectedImage => _selectedImage;

  /// Set selected image
  void setSelectedImage(File? image) {
    _selectedImage = image;
    _currentAnalysis = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Analyze dengan SVM
  Future<void> analyzeWithSvm() async {
    if (_selectedImage == null) {
      _errorMessage = 'Pilih gambar terlebih dahulu';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await _apiService.predictWithSvm(_selectedImage!);
      _currentAnalysis = result;
    } catch (e) {
      _errorMessage = e.toString();
      _currentAnalysis = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Analyze dengan KNN
  Future<void> analyzeWithKnn() async {
    if (_selectedImage == null) {
      _errorMessage = 'Pilih gambar terlebih dahulu';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await _apiService.predictWithKnn(_selectedImage!);
      _currentAnalysis = result;
    } catch (e) {
      _errorMessage = e.toString();
      _currentAnalysis = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Analyze dengan kedua model
  Future<void> analyzeWithBoth() async {
    if (_selectedImage == null) {
      _errorMessage = 'Pilih gambar terlebih dahulu';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await _apiService.predictWithBoth(_selectedImage!);
      _currentAnalysis = result;
    } catch (e) {
      _errorMessage = e.toString();
      _currentAnalysis = null;
    } finally {
      _setLoading(false);
    }
  }

  /// Test koneksi ke backend
  Future<bool> testBackendConnection() async {
    try {
      return await _apiService.testConnection();
    } catch (e) {
      return false;
    }
  }

  /// Clear hasil analisis
  void clearAnalysis() {
    _currentAnalysis = null;
    _selectedImage = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Private method untuk set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
