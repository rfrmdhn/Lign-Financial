import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/home/model/transaction.dart';
import 'package:lign_financial/features/home/model/home_repository.dart';
import 'package:lign_financial/features/home/model/home_repository_impl.dart';

class ActivityState {
  final bool isLoading;
  final List<Transaction> transactions;
  final String dateFilter; // 'All', 'Today', 'This Week'
  final String? errorMessage;

  const ActivityState({
    this.isLoading = false,
    this.transactions = const [],
    this.dateFilter = 'All',
    this.errorMessage,
  });

  ActivityState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
    String? dateFilter,
    String? errorMessage,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      dateFilter: dateFilter ?? this.dateFilter,
      errorMessage: errorMessage,
    );
  }
}

class ActivityViewModel extends Notifier<ActivityState> {
  late final HomeRepository _repository;
  // In a real app, inject Authentication/AppMode to know which data to fetch.
  // For now, we'll fetch both or simulate based on a flag passed to init, or just fetch Employee data by default.
  // The UI selects Finance/Employee mode.
  // Ideally, the ViewModel should watch the AppMode provider.
  // But to decouple, we can just load all potential data or have methods to load specific data.

  @override
  ActivityState build() {
    _repository = HomeRepositoryImpl();
    loadActivities();
    return const ActivityState(isLoading: true);
  }

  Future<void> loadActivities() async {
    state = state.copyWith(isLoading: true);
    try {
      // Fetching employee data as base. In real app, depends on context.
      // We will perform a merge or just fetch what's available.
      final employeeData = await _repository.getEmployeeHomeData(); 
      // final financeData = await _repository.getFinanceHomeData();
      
      // For this mock, we just use employee transactions.
      // If we implement Finance mode switching in Activity, we need to know the mode.
      state = state.copyWith(
        isLoading: false,
        transactions: employeeData.recentTransactions,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setDateFilter(String filter) {
    state = state.copyWith(dateFilter: filter);
    // Apply filtering logic here if we were doing server-side filtering
    // Or just store the filter and let a getter compute the view.
  }
  
  // Getter for filtered transactions based on date
  List<Transaction> get filteredTransactions {
    if (state.dateFilter == 'All') return state.transactions;
    
    final now = DateTime.now();
    return state.transactions.where((t) {
      if (state.dateFilter == 'Today') {
        return t.date.year == now.year && t.date.month == now.month && t.date.day == now.day;
      } else if (state.dateFilter == 'This Week') {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return t.date.isAfter(startOfWeek);
      }
      return true;
    }).toList();
  }
}

final activityViewModelProvider = NotifierProvider<ActivityViewModel, ActivityState>(() {
  return ActivityViewModel();
});
