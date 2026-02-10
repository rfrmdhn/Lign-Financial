import 'package:lign_financial/features/home/domain/home_data.dart';

abstract class HomeRepository {
  Future<EmployeeHomeData> getEmployeeHomeData();
  Future<FinanceHomeData> getFinanceHomeData();
}
