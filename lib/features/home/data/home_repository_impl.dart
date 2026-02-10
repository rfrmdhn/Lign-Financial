import 'package:lign_financial/features/home/data/datasources/home_mock_data_source.dart';
import 'package:lign_financial/features/home/domain/home_data.dart';
import 'package:lign_financial/features/home/domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeMockDataSource _dataSource;

  HomeRepositoryImpl({HomeMockDataSource? dataSource})
      : _dataSource = dataSource ?? HomeMockDataSource();

  @override
  Future<EmployeeHomeData> getEmployeeHomeData() {
    return _dataSource.getEmployeeHomeData();
  }

  @override
  Future<FinanceHomeData> getFinanceHomeData() {
    return _dataSource.getFinanceHomeData();
  }
}
