import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data models shared across home content screens.

enum TransactionStatus { completed, pending, rejected }

class Transaction {
  final String id;
  final String merchant;
  final String description;
  final double amount;
  final TransactionStatus status;
  final DateTime date;
  final String? employeeName;

  const Transaction({
    required this.id,
    required this.merchant,
    required this.description,
    required this.amount,
    required this.status,
    required this.date,
    this.employeeName,
  });
}

enum AlertType { info, warning, blocked }

class HomeAlert {
  final String message;
  final AlertType type;
  final IconData icon;

  const HomeAlert({
    required this.message,
    required this.type,
    required this.icon,
  });
}

// Employee Home Data

class EmployeeHomeData {
  final double totalBudget;
  final double remainingBudget;
  final double monthlyLimit;
  final double spent;
  final List<Transaction> recentTransactions;
  final int notificationCount;

  const EmployeeHomeData({
    required this.totalBudget,
    required this.remainingBudget,
    required this.monthlyLimit,
    required this.spent,
    required this.recentTransactions,
    this.notificationCount = 0,
  });

  double get spentPercentage =>
      monthlyLimit > 0 ? (spent / monthlyLimit).clamp(0.0, 1.0) : 0.0;
}

// Finance Home Data

class PendingApproval {
  final String id;
  final String employeeName;
  final double amount;
  final String transactionType;
  final String description;

  const PendingApproval({
    required this.id,
    required this.employeeName,
    required this.amount,
    required this.transactionType,
    required this.description,
  });
}

class FinanceHomeData {
  final double totalCompanyBalance;
  final double totalAllocatedBudget;
  final double remainingBalance;
  final int activeEmployees;
  final double totalDistributedBudget;
  final double budgetUsed;
  final List<PendingApproval> pendingApprovals;
  final List<Transaction> recentCompanyTransactions;

  const FinanceHomeData({
    required this.totalCompanyBalance,
    required this.totalAllocatedBudget,
    required this.remainingBalance,
    required this.activeEmployees,
    required this.totalDistributedBudget,
    required this.budgetUsed,
    required this.pendingApprovals,
    required this.recentCompanyTransactions,
  });

  double get budgetUsagePercentage =>
      totalDistributedBudget > 0
          ? (budgetUsed / totalDistributedBudget).clamp(0.0, 1.0)
          : 0.0;
}

// Mock Data Providers

final employeeHomeDataProvider = Provider<EmployeeHomeData>((ref) {
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
});

final financeHomeDataProvider = Provider<FinanceHomeData>((ref) {
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
});
