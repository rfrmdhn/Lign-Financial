import 'package:flutter/material.dart';
import 'package:lign_financial/features/home/domain/transaction.dart';

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
