import 'package:lign_financial/features/transfer/model/recipient_model.dart';

/// State for the transfer confirmation flow.
class TransferConfirmationState {
  final RecipientModel? recipient;
  final double amount;
  final String pin;
  final bool isExistingRecipient;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const TransferConfirmationState({
    this.recipient,
    this.amount = 0,
    this.pin = '',
    this.isExistingRecipient = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  TransferConfirmationState copyWith({
    RecipientModel? recipient,
    double? amount,
    String? pin,
    bool? isExistingRecipient,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return TransferConfirmationState(
      recipient: recipient ?? this.recipient,
      amount: amount ?? this.amount,
      pin: pin ?? this.pin,
      isExistingRecipient: isExistingRecipient ?? this.isExistingRecipient,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
