import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/account/model/account_model.dart';

class AccountState {
  final bool isLoading;
  final AccountData? data;
  final String? errorMessage;

  const AccountState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  AccountState copyWith({
    bool? isLoading,
    AccountData? data,
    String? errorMessage,
  }) {
    return AccountState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

class AccountViewModel extends Notifier<AccountState> {
  late final AccountRepository _repository;

  @override
  AccountState build() {
    _repository = AccountRepositoryImpl();
    Future.microtask(() => loadAccountData());
    return const AccountState(isLoading: true);
  }

  Future<void> loadAccountData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _repository.getAccountData();
      state = state.copyWith(isLoading: false, data: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final accountViewModelProvider = NotifierProvider<AccountViewModel, AccountState>(() {
  return AccountViewModel();
});
