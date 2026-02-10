/// Transfer Step Enum
enum TransferStep { menu, input, review, success }

/// Transfer State
class TransferState {
  final bool isLoading;
  final String? errorMessage;
  final TransferStep currentStep;
  final String selectedType;

  const TransferState({
    this.isLoading = false,
    this.errorMessage,
    this.currentStep = TransferStep.menu,
    this.selectedType = '',
  });

  TransferState copyWith({
    bool? isLoading,
    String? errorMessage,
    TransferStep? currentStep,
    String? selectedType,
  }) {
    return TransferState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      currentStep: currentStep ?? this.currentStep,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}
