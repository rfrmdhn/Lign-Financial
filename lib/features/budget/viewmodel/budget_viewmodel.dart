import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/home/model/home_data.dart';
import 'package:lign_financial/features/home/model/home_repository.dart';
import 'package:lign_financial/features/home/model/home_repository_impl.dart';

class BudgetState {
  final bool isLoading;
  final EmployeeHomeData? data;
  final String? errorMessage;

  const BudgetState({
    this.isLoading = false,
    this.data,
    this.errorMessage,
  });

  BudgetState copyWith({
    bool? isLoading,
    EmployeeHomeData? data,
    String? errorMessage,
  }) {
    return BudgetState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

class BudgetViewModel extends Notifier<BudgetState> {
  late final HomeRepository _repository;

  @override
  BudgetState build() {
    _repository = HomeRepositoryImpl();
    loadData();
    return const BudgetState(isLoading: true);
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final data = await _repository.getEmployeeHomeData();
      state = state.copyWith(isLoading: false, data: data);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final budgetViewModelProvider = NotifierProvider<BudgetViewModel, BudgetState>(() {
  return BudgetViewModel();
});
