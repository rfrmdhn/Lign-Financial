import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';

class EmployeeExpensesScreen extends StatefulWidget {
  const EmployeeExpensesScreen({super.key});

  @override
  State<EmployeeExpensesScreen> createState() => _EmployeeExpensesScreenState();
}

class _EmployeeExpensesScreenState extends State<EmployeeExpensesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: LignColors.textPrimary,
          unselectedLabelColor: LignColors.textSecondary,
          indicatorColor: LignColors.electricLime,
          indicatorWeight: 3,
          dividerColor: LignColors.border,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ExpenseList(status: 'Pending'),
          _ExpenseList(status: 'Approved'),
          _ExpenseList(status: 'Rejected'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement Submit Expense Flow
        },
        backgroundColor: LignColors.electricLime,
        foregroundColor: LignColors.textPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Submit Expense', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ExpenseList extends StatelessWidget {
  final String status;

  const _ExpenseList({required this.status});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> expenses = [
      if (status == 'Pending') ...[
        {'title': 'Team Lunch', 'amount': 450000, 'date': 'Today'},
        {'title': 'Taxi to Client', 'amount': 75000, 'date': 'Yesterday'},
      ],
      if (status == 'Approved') ...[
        {'title': 'Office Supplies', 'amount': 120000, 'date': 'Last Week'},
        {'title': 'Flight Ticket', 'amount': 2500000, 'date': '2 Weeks Ago'},
      ],
      if (status == 'Rejected') ...[
        {'title': 'Video Game', 'amount': 800000, 'date': 'Last Month'},
      ],
    ];

    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 60, color: LignColors.border),
            const SizedBox(height: 16),
            Text('No $status expenses', style: const TextStyle(color: LignColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _ExpenseItem(
            title: expense['title'],
            amount: (expense['amount'] as int).toDouble(),
            date: expense['date'],
            status: status,
          ),
        );
      },
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final String title;
  final double amount;
  final String date;
  final String status;

  const _ExpenseItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    Color statusColor;
    switch (status) {
      case 'Approved':
        statusColor = LignColors.success;
        break;
      case 'Rejected':
        statusColor = LignColors.error;
        break;
      default:
        statusColor = LignColors.warning;
    }

    return LignCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
               Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: LignColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt, color: LignColors.textSecondary),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(date, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(amount),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
