import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lign_financial/core/network/api_client.dart';
import 'package:lign_financial/features/qris/data/qris_repository.dart';
import 'package:lign_financial/features/qris/model/qris_payment_response.dart';

/// Concrete implementation of [QrisRepository] backed by Dio.
class QrisRepositoryImpl implements QrisRepository {
  final ApiClient _apiClient;

  QrisRepositoryImpl(this._apiClient);

  @override
  Future<QrisPaymentResponse> submitQrContent(String qrContent) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/v1/qris-payments',
        data: {'qr_content': qrContent},
      );

      if (response.statusCode == 201) {
        return QrisPaymentResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Unexpected status code: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        final message = data is Map
            ? (data['message'] as String? ?? 'Validation error')
            : 'Validation error';
        throw QrisValidationException(message);
      }
      rethrow;
    }
  }
}

/// Thrown when the API returns a 422 validation error.
class QrisValidationException implements Exception {
  final String message;
  const QrisValidationException(this.message);

  @override
  String toString() => message;
}

/// Riverpod provider for [QrisRepository].
final qrisRepositoryProvider = Provider<QrisRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QrisRepositoryImpl(apiClient);
});
