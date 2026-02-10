import 'package:lign_financial/features/auth/domain/app_mode.dart';
import 'package:lign_financial/features/home/model/home_data.dart';

/// Home State
class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final EmployeeHomeData? employeeData;
  final FinanceHomeData? financeData;
  final AppMode currentMode;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.employeeData,
    this.financeData,
    this.currentMode = AppMode.employee,
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    EmployeeHomeData? employeeData,
    FinanceHomeData? financeData,
    AppMode? currentMode,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      employeeData: employeeData ?? this.employeeData,
      financeData: financeData ?? this.financeData,
      currentMode: currentMode ?? this.currentMode,
    );
  }
}
