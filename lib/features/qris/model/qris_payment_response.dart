/// Data model for the QRIS payment API response (201 Created).
class QrisPaymentResponse {
  final String id;
  final String transactionStatus;
  final String merchantName;
  final String merchantId;
  final double transactionAmount;
  final double feeAmount;
  final String walletName;
  final String status;
  final String? merchantLocation;
  final String? currencyCode;
  final Map<String, dynamic>? decodedData;

  const QrisPaymentResponse({
    required this.id,
    required this.transactionStatus,
    required this.merchantName,
    required this.merchantId,
    required this.transactionAmount,
    required this.feeAmount,
    required this.walletName,
    required this.status,
    this.merchantLocation,
    this.currencyCode,
    this.decodedData,
  });

  factory QrisPaymentResponse.fromJson(Map<String, dynamic> json) {
    return QrisPaymentResponse(
      id: json['id'] as String,
      transactionStatus: json['transaction_status'] as String,
      merchantName: json['merchant_name'] as String,
      merchantId: json['merchant_id'] as String,
      transactionAmount: (json['transaction_amount'] as num).toDouble(),
      feeAmount: (json['fee_amount'] as num).toDouble(),
      walletName: json['wallet_name'] as String,
      status: json['status'] as String,
      merchantLocation: json['merchant_location'] as String?,
      currencyCode: json['currency_code'] as String?,
      decodedData: json['decoded_data'] as Map<String, dynamic>?,
    );
  }
}
