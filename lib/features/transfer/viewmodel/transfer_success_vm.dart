import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/transfer/model/transfer_repository.dart';

/// State for the transfer success page.
class TransferSuccessState {
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final double amount;
  final bool isExistingRecipient;
  final bool isSaving;
  final bool savedSuccessfully;

  const TransferSuccessState({
    this.bankName = '',
    this.accountNumber = '',
    this.accountHolderName = '',
    this.amount = 0,
    this.isExistingRecipient = true,
    this.isSaving = false,
    this.savedSuccessfully = false,
  });

  TransferSuccessState copyWith({
    String? bankName,
    String? accountNumber,
    String? accountHolderName,
    double? amount,
    bool? isExistingRecipient,
    bool? isSaving,
    bool? savedSuccessfully,
  }) {
    return TransferSuccessState(
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      amount: amount ?? this.amount,
      isExistingRecipient: isExistingRecipient ?? this.isExistingRecipient,
      isSaving: isSaving ?? this.isSaving,
      savedSuccessfully: savedSuccessfully ?? this.savedSuccessfully,
    );
  }
}

/// ViewModel for the success page.
class TransferSuccessViewModel extends Notifier<TransferSuccessState> {
  @override
  TransferSuccessState build() {
    return const TransferSuccessState();
  }

  void setResult({
    required String bankName,
    required String accountNumber,
    required String accountHolderName,
    required double amount,
    required bool isExistingRecipient,
  }) {
    state = TransferSuccessState(
      bankName: bankName,
      accountNumber: accountNumber,
      accountHolderName: accountHolderName,
      amount: amount,
      isExistingRecipient: isExistingRecipient,
    );
  }

  Future<bool> saveRecipient(String alias) async {
    state = state.copyWith(isSaving: true);
    try {
      final repo = ref.read(transferRepositoryProvider);
      await repo.saveRecipient(
        alias: alias,
        bankName: state.bankName,
        bankCode: state.bankName,
        accountNumber: state.accountNumber,
        accountHolderName: state.accountHolderName,
      );
      state = state.copyWith(isSaving: false, savedSuccessfully: true);
      return true;
    } catch (_) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }

  void reset() {
    state = const TransferSuccessState();
  }
}

final transferSuccessProvider =
    NotifierProvider<TransferSuccessViewModel, TransferSuccessState>(() {
  return TransferSuccessViewModel();
});
