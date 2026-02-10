import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';

enum QRISStep { scan, input, review, success }

class QRISState {
  final QRISStep step;
  final bool isLoading;
  final String? errorMessage;
  final String merchantName;
  final String merchantCategory;
  final double remainingLimit;
  final double amount;
  final bool needsApproval;

  const QRISState({
    this.step = QRISStep.scan,
    this.isLoading = false,
    this.errorMessage,
    this.merchantName = 'Starbucks Indonesia',
    this.merchantCategory = 'Food & Beverage',
    this.remainingLimit = 3500000,
    this.amount = 0,
    this.needsApproval = false,
  });

  QRISState copyWith({
    QRISStep? step,
    bool? isLoading,
    String? errorMessage,
    String? merchantName,
    String? merchantCategory,
    double? remainingLimit,
    double? amount,
    bool? needsApproval,
  }) {
    return QRISState(
      step: step ?? this.step,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Reset unless provided? No, specific update.
      merchantName: merchantName ?? this.merchantName,
      merchantCategory: merchantCategory ?? this.merchantCategory,
      remainingLimit: remainingLimit ?? this.remainingLimit,
      amount: amount ?? this.amount,
      needsApproval: needsApproval ?? this.needsApproval,
    );
  }
}

class QRISViewModel extends Notifier<QRISState> {
  @override
  QRISState build() {
    // Simulate scan start
    _startScanSimulation();
    return const QRISState();
  }

  void _startScanSimulation() {
    Future.delayed(const Duration(seconds: 2), () {
      state = state.copyWith(step: QRISStep.input);
    });
  }

  void setAmount(String value) {
    final amount = double.tryParse(value) ?? 0;
    String? error;
    if (amount > state.remainingLimit) {
      error = 'Amount exceeds remaining limit (${CurrencyFormatter.format(state.remainingLimit)})';
    }
    state = state.copyWith(amount: amount, errorMessage: error);
  }

  void proceedToReview() {
    if (state.amount <= 0 || state.errorMessage != null) return;
    
    final needsApproval = state.amount > 1000000;
    state = state.copyWith(step: QRISStep.review, needsApproval: needsApproval);
  }

  void backToInput() {
    state = state.copyWith(step: QRISStep.input);
  }

  Future<void> processPayment() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false, step: QRISStep.success);
  }

  void reset() {
    state = const QRISState();
    _startScanSimulation();
  }
}

final qrisViewModelProvider = NotifierProvider<QRISViewModel, QRISState>(() {
  return QRISViewModel();
});
