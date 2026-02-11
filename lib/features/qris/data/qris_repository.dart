import 'package:lign_financial/features/qris/model/qris_payment_response.dart';

/// Contract for QRIS payment operations.
abstract class QrisRepository {
  /// Submits decoded QR content to the backend.
  ///
  /// Returns [QrisPaymentResponse] on 201.
  /// Throws on 422 (validation) or network errors.
  Future<QrisPaymentResponse> submitQrContent(String qrContent);
}
