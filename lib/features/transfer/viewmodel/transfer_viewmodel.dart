import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/transfer/model/transfer_state.dart';
import 'package:lign_financial/features/transfer/model/transfer_repository.dart';

/// Transfer ViewModel
class TransferViewModel extends Notifier<TransferState> {
  late final TransferRepository _repository;

  @override
  TransferState build() {
    _repository = ref.read(transferRepositoryProvider);
    return const TransferState();
  }

  void selectType(String type) {
    state = state.copyWith(selectedType: type, currentStep: TransferStep.input);
  }

  void goToReview() {
    state = state.copyWith(currentStep: TransferStep.review);
  }

  void goBack() {
    if (state.currentStep == TransferStep.input) {
      state = state.copyWith(currentStep: TransferStep.menu);
    } else if (state.currentStep == TransferStep.review) {
      state = state.copyWith(currentStep: TransferStep.input);
    }
  }

  Future<void> processTransfer({
    required String amount,
    required String destination,
    required String notes,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _repository.performTransfer(
        amount: amount,
        destination: destination,
        notes: notes,
      );
      state = state.copyWith(isLoading: false, currentStep: TransferStep.success);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Transfer failed. Please try again.');
    }
  }

  void reset() {
    state = const TransferState();
  }
}

final transferViewModelProvider = NotifierProvider<TransferViewModel, TransferState>(() {
  return TransferViewModel();
});
