import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/transfer/model/bank_model.dart';
import 'package:lign_financial/features/transfer/model/transfer_repository.dart';

/// State for the new recipient form page.
class NewRecipientState {
  final bool isLoadingBanks;
  final List<BankModel> banks;
  final BankModel? selectedBank;
  final String accountNumber;
  final bool isLookingUp;
  final String? accountHolderName;
  final String? errorMessage;

  const NewRecipientState({
    this.isLoadingBanks = true,
    this.banks = const [],
    this.selectedBank,
    this.accountNumber = '',
    this.isLookingUp = false,
    this.accountHolderName,
    this.errorMessage,
  });

  NewRecipientState copyWith({
    bool? isLoadingBanks,
    List<BankModel>? banks,
    BankModel? selectedBank,
    String? accountNumber,
    bool? isLookingUp,
    String? accountHolderName,
    String? errorMessage,
  }) {
    return NewRecipientState(
      isLoadingBanks: isLoadingBanks ?? this.isLoadingBanks,
      banks: banks ?? this.banks,
      selectedBank: selectedBank ?? this.selectedBank,
      accountNumber: accountNumber ?? this.accountNumber,
      isLookingUp: isLookingUp ?? this.isLookingUp,
      accountHolderName: accountHolderName,
      errorMessage: errorMessage,
    );
  }

  bool get canContinue =>
      selectedBank != null && accountNumber.length >= 8 && !isLookingUp;
}

/// ViewModel for the new-recipient form.
class TransferNewRecipientViewModel extends Notifier<NewRecipientState> {
  @override
  NewRecipientState build() {
    Future.microtask(() => _loadBanks());
    return const NewRecipientState();
  }

  Future<void> _loadBanks() async {
    final repo = ref.read(transferRepositoryProvider);
    final banks = await repo.getBanks();
    state = state.copyWith(isLoadingBanks: false, banks: banks);
  }

  void selectBank(BankModel bank) {
    state = state.copyWith(selectedBank: bank, accountHolderName: null);
  }

  void setAccountNumber(String value) {
    state = state.copyWith(accountNumber: value, accountHolderName: null);
  }

  /// Look up the account holder name after user taps Continue.
  Future<String?> lookupAccount() async {
    final bank = state.selectedBank;
    if (bank == null || state.accountNumber.length < 8) return null;

    state = state.copyWith(isLookingUp: true, errorMessage: null);

    try {
      final repo = ref.read(transferRepositoryProvider);
      final name = await repo.lookupAccountHolder(
        bankCode: bank.code,
        accountNumber: state.accountNumber,
      );
      state = state.copyWith(isLookingUp: false, accountHolderName: name);
      return name;
    } catch (e) {
      state = state.copyWith(
        isLookingUp: false,
        errorMessage: 'Account lookup failed.',
      );
      return null;
    }
  }

  void reset() {
    state = const NewRecipientState();
  }
}

final transferNewRecipientProvider =
    NotifierProvider<TransferNewRecipientViewModel, NewRecipientState>(() {
  return TransferNewRecipientViewModel();
});
