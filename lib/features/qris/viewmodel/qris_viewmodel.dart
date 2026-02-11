import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lign_financial/features/qris/data/qris_repository_impl.dart';
import 'package:lign_financial/features/qris/model/qris_payment_response.dart';

/// Represents the current state of the QRIS payment flow.
class QrisState {
  final bool isLoading;
  final String? errorMessage;

  /// Raw content decoded from the QR code.
  final String? qrContent;

  /// Populated after a successful POST to the API.
  final QrisPaymentResponse? paymentResponse;

  /// Amount entered by the user on the confirmation page.
  final double amount;

  /// Whether the pay action is in progress.
  final bool isPaymentProcessing;

  /// Whether the payment has been completed successfully.
  final bool isPaymentSuccess;

  /// Timestamp of the completed payment.
  final DateTime? paymentDate;

  const QrisState({
    this.isLoading = false,
    this.errorMessage,
    this.qrContent,
    this.paymentResponse,
    this.amount = 0,
    this.isPaymentProcessing = false,
    this.isPaymentSuccess = false,
    this.paymentDate,
  });

  QrisState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? qrContent,
    QrisPaymentResponse? paymentResponse,
    double? amount,
    bool? isPaymentProcessing,
    bool? isPaymentSuccess,
    DateTime? paymentDate,
    bool clearError = false,
    bool clearQrContent = false,
    bool clearPaymentResponse = false,
  }) {
    return QrisState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      qrContent: clearQrContent ? null : (qrContent ?? this.qrContent),
      paymentResponse: clearPaymentResponse
          ? null
          : (paymentResponse ?? this.paymentResponse),
      amount: amount ?? this.amount,
      isPaymentProcessing:
          isPaymentProcessing ?? this.isPaymentProcessing,
      isPaymentSuccess: isPaymentSuccess ?? this.isPaymentSuccess,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }
}

/// ViewModel for the entire QRIS payment flow.
class QrisViewModel extends Notifier<QrisState> {
  @override
  QrisState build() => const QrisState();

  /// Called when a QR code is successfully decoded (camera or gallery).
  ///
  /// Validates the content, then calls the backend API.
  Future<bool> onQrScanned(String content) async {
    if (content.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'QR code content is empty',
        clearQrContent: true,
      );
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      qrContent: content,
      clearError: true,
    );

    try {
      final repo = ref.read(qrisRepositoryProvider);
      final response = await repo.submitQrContent(content);

      state = state.copyWith(
        isLoading: false,
        paymentResponse: response,
      );
      return true;
    } on QrisValidationException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
        clearQrContent: true,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error. Please try again.',
        clearQrContent: true,
      );
      return false;
    }
  }

  /// Updates the user-entered payment amount.
  void setAmount(String value) {
    final amount = double.tryParse(value) ?? 0;
    state = state.copyWith(amount: amount, clearError: true);
  }

  /// Simulates the pay action (no dedicated endpoint specified).
  Future<bool> processPayment() async {
    if (state.amount <= 0) {
      state = state.copyWith(errorMessage: 'Amount must be greater than 0');
      return false;
    }

    state = state.copyWith(isPaymentProcessing: true, clearError: true);

    // Simulate payment processing — replace with real endpoint when available.
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(
      isPaymentProcessing: false,
      isPaymentSuccess: true,
      paymentDate: DateTime.now(),
    );
    return true;
  }

  /// Resets the entire QRIS flow to initial state.
  void reset() {
    state = const QrisState();
  }
}

final qrisViewModelProvider =
    NotifierProvider<QrisViewModel, QrisState>(QrisViewModel.new);
