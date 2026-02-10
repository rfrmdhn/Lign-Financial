import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/transfer/model/recipient_model.dart';
import 'package:lign_financial/features/transfer/model/transfer_repository.dart';
import 'package:lign_financial/features/transfer/model/transfer_state.dart';

/// ViewModel for the confirmation page (shared by all transfer paths).
class TransferConfirmationViewModel
    extends Notifier<TransferConfirmationState> {
  @override
  TransferConfirmationState build() {
    return const TransferConfirmationState();
  }

  /// Set the recipient from saved list or new form.
  void setRecipient({
    required RecipientModel recipient,
    required bool isExisting,
  }) {
    state = state.copyWith(
      recipient: recipient,
      isExistingRecipient: isExisting,
    );
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void setPin(String pin) {
    state = state.copyWith(pin: pin);
  }

  Future<bool> processTransfer() async {
    final recipient = state.recipient;
    if (recipient == null || state.amount <= 0 || state.pin.length < 6) {
      state = state.copyWith(errorMessage: 'Please fill all fields.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repo = ref.read(transferRepositoryProvider);
      await repo.performTransfer(
        bankCode: recipient.bankCode,
        accountNumber: recipient.accountNumber,
        amount: state.amount,
        pin: state.pin,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Transfer failed. Please try again.',
      );
      return false;
    }
  }

  void reset() {
    state = const TransferConfirmationState();
  }
}

final transferConfirmationProvider =
    NotifierProvider<TransferConfirmationViewModel, TransferConfirmationState>(
        () {
  return TransferConfirmationViewModel();
});
