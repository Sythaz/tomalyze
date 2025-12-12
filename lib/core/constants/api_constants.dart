class ApiConstants {
  // Base URL untuk backend FastAPI
  // Untuk emulator Android gunakan: http://10.0.2.2:8000
  // Untuk iOS simulator gunakan: http://localhost:8000
  // Untuk device fisik gunakan IP komputer Anda, misal: http://192.168.1.100:8000
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Endpoints
  static const String predictEndpoint = '/predict';
  static const String predictSvmEndpoint = '/predict-svm';
  static const String predictKnnEndpoint = '/predict-knn';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
