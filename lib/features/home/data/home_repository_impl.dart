import 'package:lign_financial/features/home/domain/home_data.dart';
import 'package:lign_financial/features/home/domain/home_repository.dart';
import 'package:lign_financial/features/home/domain/transaction.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<EmployeeHomeData> getEmployeeHomeData() async {
    // Mock simulation
    await Future.delayed(const Duration(milliseconds: 300));
    return EmployeeHomeData(
      totalBudget: 5000000,
      remainingBudget: 3500000,
      monthlyLimit: 5000000,
      spent: 1500000,
      notificationCount: 3,
      recentTransactions: [
        Transaction(
          id: '1',
          merchant: 'Grab Transport',
          description: 'Office commute',
          amount: -45000,
          status: TransactionStatus.completed,
          date: DateTime.now(),
        ),
        Transaction(
          id: '2',
          merchant: 'Starbucks Coffee',
          description: 'Client meeting',
          amount: -65000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(hours: 18)),
        ),
        Transaction(
          id: '3',
          merchant: 'Tokopedia Office Supply',
          description: 'Stationery',
          amount: -120000,
          status: TransactionStatus.pending,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transaction(
          id: '4',
          merchant: 'GoFood Lunch',
          description: 'Team lunch',
          amount: -85000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Transaction(
          id: '5',
          merchant: 'Reimbursement',
          description: 'Travel refund',
          amount: 150000,
          status: TransactionStatus.rejected,
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    );
  }

  @override
  Future<FinanceHomeData> getFinanceHomeData() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return FinanceHomeData(
      totalCompanyBalance: 2450000000,
      totalAllocatedBudget: 850000000,
      remainingBalance: 1600000000,
      activeEmployees: 124,
      totalDistributedBudget: 850000000,
      budgetUsed: 523000000,
      pendingApprovals: const [
        PendingApproval(
          id: 'a1',
          employeeName: 'Budi Santoso',
          amount: 2500000,
          transactionType: 'Travel',
          description: 'Flight ticket to Singapore',
        ),
        PendingApproval(
          id: 'a2',
          employeeName: 'Siti Aminah',
          amount: 3500000,
          transactionType: 'Equipment',
          description: 'New Monitor 27"',
        ),
        PendingApproval(
          id: 'a3',
          employeeName: 'Ahmad Fauzi',
          amount: 450000,
          transactionType: 'Meals',
          description: 'Client dinner at Sushi Tei',
        ),
      ],
      recentCompanyTransactions: [
        Transaction(
          id: 'c1',
          merchant: 'AWS Cloud Services',
          description: 'Server cost',
          amount: -6500000,
          status: TransactionStatus.completed,
          date: DateTime.now(),
          employeeName: 'System',
        ),
        Transaction(
          id: 'c2',
          merchant: 'Top Up — Operational',
          description: 'Transfer in',
          amount: 50000000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(hours: 6)),
          employeeName: 'Finance',
        ),
        Transaction(
          id: 'c3',
          merchant: 'Google Workspace',
          description: 'Monthly subscription',
          amount: -1800000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 1)),
          employeeName: 'System',
        ),
        Transaction(
          id: 'c4',
          merchant: 'Office Supplies',
          description: 'Employee expense',
          amount: -320000,
          status: TransactionStatus.pending,
          date: DateTime.now().subtract(const Duration(days: 2)),
          employeeName: 'Budi Santoso',
        ),
        Transaction(
          id: 'c5',
          merchant: 'Grab for Business',
          description: 'Team transport',
          amount: -1250000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 3)),
          employeeName: 'Various',
        ),
      ],
    );
  }
}
