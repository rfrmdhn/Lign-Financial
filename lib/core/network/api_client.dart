import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Central Dio-based API client.
///
/// All feature repositories should depend on this provider instead of
/// creating their own Dio instances.
class ApiClient {
  final Dio _dio;

  ApiClient({required String baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

  Dio get dio => _dio;

  /// Sets the auth token for subsequent requests.
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clears the auth token.
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}

/// Riverpod provider for the API client.
///
/// Override the base URL via [apiBaseUrlProvider] when configuring the app.
final apiBaseUrlProvider = Provider<String>((_) {
  // Default — override in main.dart or via environment config.
  return 'https://api.lign.com';
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return ApiClient(baseUrl: baseUrl);
});
