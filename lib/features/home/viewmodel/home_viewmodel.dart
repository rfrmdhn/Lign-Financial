import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/domain/app_mode.dart';
import 'package:lign_financial/features/home/model/home_state.dart';
import 'package:lign_financial/features/home/model/home_repository.dart';
import 'package:lign_financial/features/home/model/home_repository_impl.dart';

/// Home ViewModel
class HomeViewModel extends Notifier<HomeState> {
  late final HomeRepository _repository;

  @override
  HomeState build() {
    _repository = HomeRepositoryImpl();
    // Schedule load after build() completes
    Future.microtask(() => loadData());
    return const HomeState(isLoading: true);
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (state.currentMode == AppMode.employee) {
        final data = await _repository.getEmployeeHomeData();
        state = state.copyWith(isLoading: false, employeeData: data);
      } else {
        final data = await _repository.getFinanceHomeData();
        state = state.copyWith(isLoading: false, financeData: data);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void switchMode() {
    final newMode = state.currentMode == AppMode.employee
        ? AppMode.finance
        : AppMode.employee;
    state = state.copyWith(currentMode: newMode);
    loadData(); // Reload data for new mode
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
