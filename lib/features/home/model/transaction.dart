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
