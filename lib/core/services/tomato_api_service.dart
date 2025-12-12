import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants/api_constants.dart';
import '../models/tomato_analysis.dart';

/// Service untuk berkomunikasi dengan FastAPI backend
class TomatoApiService {
  /// Predict menggunakan SVM
  Future<TomatoAnalysis> predictWithSvm(File imageFile) async {
    return await _uploadAndPredict(
      imageFile,
      ApiConstants.predictSvmEndpoint,
    );
  }

  /// Predict menggunakan KNN
  Future<TomatoAnalysis> predictWithKnn(File imageFile) async {
    return await _uploadAndPredict(
      imageFile,
      ApiConstants.predictKnnEndpoint,
    );
  }

  /// Predict menggunakan kedua model (SVM & KNN)
  Future<TomatoAnalysis> predictWithBoth(File imageFile) async {
    return await _uploadAndPredict(
      imageFile,
      '/predict-all',
    );
  }

  /// Private method untuk upload image dan mendapatkan prediksi
  Future<TomatoAnalysis> _uploadAndPredict(
    File imageFile,
    String endpoint,
  ) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      // Buat multipart request
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      // Kirim request
      final streamedResponse = await request.send().timeout(
            ApiConstants.connectionTimeout,
          );

      // Baca response
      final response = await http.Response.fromStream(streamedResponse);

      // Cek status code
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TomatoAnalysis.fromJson(jsonData);
      } else {
        // Handle error response
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['detail'] ?? 'Gagal melakukan prediksi: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan backend sudah berjalan.',
      );
    } on http.ClientException {
      throw Exception('Gagal mengirim request ke server.');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  /// Test koneksi ke backend
  Future<bool> testConnection() async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 5),
          );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
