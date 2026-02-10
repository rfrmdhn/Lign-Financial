import 'package:lign_financial/features/home/model/home_data.dart';
import 'package:lign_financial/features/home/model/transaction.dart';

class HomeMockDataSource {
  Future<EmployeeHomeData> getEmployeeHomeData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return EmployeeHomeData(
      totalBudget: 15000000,
      remainingBudget: 2750000,
      monthlyLimit: 5000000,
      spent: 2250000,
      notificationCount: 3,
      recentTransactions: [
        Transaction(
          id: 't1',
          merchant: 'GrabFood',
          description: 'Team Lunch',
          amount: 250000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Transaction(
          id: 't2',
          merchant: 'Gojek',
          description: 'Client Meeting Transport',
          amount: 45000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transaction(
          id: 't3',
          merchant: 'Staples',
          description: 'Office Supplies',
          amount: 120000,
          status: TransactionStatus.pending,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    );
  }

  Future<FinanceHomeData> getFinanceHomeData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    return FinanceHomeData(
      totalCompanyBalance: 1250000000,
      totalAllocatedBudget: 850000000,
      remainingBalance: 400000000,
      activeEmployees: 124,
      totalDistributedBudget: 850000000,
      budgetUsed: 523000000,
      pendingApprovals: [
        const PendingApproval(
          id: 'a1',
          employeeName: 'Sarah Johnson',
          amount: 1500000,
          transactionType: 'Travel',
          description: 'Garuda Indonesia Flight',
        ),
        const PendingApproval(
          id: 'a2',
          employeeName: 'Mike Chen',
          amount: 3500000,
          transactionType: 'Equipment',
          description: 'Apple Store Monitor',
        ),
      ],
      recentCompanyTransactions: [
        Transaction(
          id: 'ct1',
          merchant: 'AWS Services',
          description: 'Cloud Infrastructure',
          amount: 15000000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 1)),
          employeeName: 'System',
        ),
        Transaction(
          id: 'ct2',
          merchant: 'WeWork',
          description: 'Office Rent - Feb',
          amount: 25000000,
          status: TransactionStatus.completed,
          date: DateTime.now().subtract(const Duration(days: 3)),
          employeeName: 'Finance Dept',
        ),
      ],
    );
  }
}
