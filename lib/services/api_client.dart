// lib/services/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  // Singleton
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5000/api', // Android Emulator
    // baseUrl: 'http://localhost:5000/api', // iOS / Web
    connectTimeout: Duration(seconds: 8),
    receiveTimeout: Duration(seconds: 6),
  ));

  static final _storage = FlutterSecureStorage();

  // Initialize once in main()
  static Future<void> init() async {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt');
        if (token != null) {
          options.headers['x-auth-token'] = token;
        }
        handler.next(options);
      },
      onError: (e, handler) {
        print("API Error: ${e.response?.data ?? e.message}");
        handler.next(e);
      },
    ));
  }

  // POST Reaction
  static Future<Map<String, dynamic>?> reactToPost(String postId, String reactionType) async {
    try {
      final response = await _dio.post(
        '/reactions',
        data: {
          'postId': postId,
          'reactionType': reactionType,
        },
      );
      return response.data;
    } on DioException catch (e) {
      print("Reaction failed: ${e.response?.data ?? e.message}");
      return null;
    }
  }

  // Optional: Save JWT after login
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt', value: token);
  }

  // Optional: Clear token on logout
  static Future<void> clearToken() async {
    await _storage.delete(key: 'jwt');
  }
}
