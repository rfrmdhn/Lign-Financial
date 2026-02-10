import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/home/domain/home_data.dart';
import 'package:lign_financial/features/home/domain/home_repository.dart';
import 'package:lign_financial/features/home/data/home_repository_impl.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

final employeeHomeDataProvider = FutureProvider<EmployeeHomeData>((ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getEmployeeHomeData();
});

final financeHomeDataProvider = FutureProvider<FinanceHomeData>((ref) async {
  final repository = ref.read(homeRepositoryProvider);
  return repository.getFinanceHomeData();
});
