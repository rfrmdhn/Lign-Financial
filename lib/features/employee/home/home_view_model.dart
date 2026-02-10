import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Data Models ---

enum TransactionStatus { completed, pending, rejected }

class Transaction {
  final String id;
  final String merchant;
  final String description;
  final double amount;
  final TransactionStatus status;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.merchant,
    required this.description,
    required this.amount,
    required this.status,
    required this.date,
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

class HomeData {
  final double companyBalance;
  final double monthlyLimit;
  final double remainingLimit;
  final double spent;
  final List<Transaction> recentTransactions;
  final List<HomeAlert> alerts;
  final String? insightText;
  final int notificationCount;

  const HomeData({
    required this.companyBalance,
    required this.monthlyLimit,
    required this.remainingLimit,
    required this.spent,
    required this.recentTransactions,
    required this.alerts,
    this.insightText,
    this.notificationCount = 0,
  });

  double get spentPercentage =>
      monthlyLimit > 0 ? (spent / monthlyLimit).clamp(0.0, 1.0) : 0.0;
}

// --- ViewModel (Riverpod Provider) ---

final homeDataProvider = Provider<HomeData>((ref) {
  return HomeData(
    companyBalance: 150000000,
    monthlyLimit: 5000000,
    remainingLimit: 3500000,
    spent: 1500000,
    notificationCount: 3,
    alerts: const [
      HomeAlert(
        message: 'Reimbursement pending approval',
        type: AlertType.info,
        icon: Icons.info_outline,
      ),
      HomeAlert(
        message: 'Limit almost reached (70% used)',
        type: AlertType.warning,
        icon: Icons.warning_amber_rounded,
      ),
    ],
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
    insightText: 'Your biggest spending category this week: Transport',
  );
});
