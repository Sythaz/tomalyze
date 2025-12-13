import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/scan_result.dart';

class ApiService {
  // PENTING: Ganti sesuai kondisi Anda
  // - Emulator Android: "http://10.0.2.2:8000"
  // - Physical Device: "http://192.168.x.x:8000" (ganti dengan IP laptop Anda)
  static const String baseUrl = "http://10.0.2.2:8000";

  /// Upload foto tomat dan dapatkan hasil klasifikasi dari SVM + KNN
  Future<ScanResult> predictTomato(File imageFile) async {
    final url = Uri.parse("$baseUrl/predict-all");

    try {
      var request = http.MultipartRequest("POST", url);

      // Tambahkan file foto
      http.MultipartFile imageData = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: imageFile.uri.pathSegments.last,
      );

      request.files.add(imageData);

      // Kirim request
      print("📤 Mengirim foto ke backend...");
      http.StreamedResponse response = await request.send();

      // Baca response
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception(
          "Gagal melakukan prediksi: ${response.statusCode}\n$responseBody",
        );
      }

      // Parse JSON response
      Map<String, dynamic> responseData = jsonDecode(responseBody);

      print("✅ Prediksi sukses: $responseBody");

      return ScanResult.fromJson(responseData);
    } catch (e) {
      print("❌ Error predict: $e");
      throw Exception("Gagal menghubungi server: $e");
    }
  }

  /// Prediksi hanya menggunakan SVM
  Future<Map<String, dynamic>> predictSVM(File imageFile) async {
    final url = Uri.parse("$baseUrl/predict-svm");

    try {
      var request = http.MultipartRequest("POST", url);

      http.MultipartFile imageData = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: imageFile.uri.pathSegments.last,
      );

      request.files.add(imageData);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception("Gagal prediksi SVM: ${response.statusCode}");
      }

      return jsonDecode(responseBody);
    } catch (e) {
      throw Exception("Error SVM: $e");
    }
  }

  /// Prediksi hanya menggunakan KNN
  Future<Map<String, dynamic>> predictKNN(File imageFile) async {
    final url = Uri.parse("$baseUrl/predict-knn");

    try {
      var request = http.MultipartRequest("POST", url);

      http.MultipartFile imageData = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        filename: imageFile.uri.pathSegments.last,
      );

      request.files.add(imageData);
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception("Gagal prediksi KNN: ${response.statusCode}");
      }

      return jsonDecode(responseBody);
    } catch (e) {
      throw Exception("Error KNN: $e");
    }
  }
}
