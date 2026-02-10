import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/home/viewmodel/home_viewmodel.dart';

class EmployeeHomeContent extends ConsumerWidget {
  const EmployeeHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final data = state.employeeData;

    if (data == null) {
      return const Center(child: Text('No Data'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceCard(data.remainingBudget, data.totalBudget),
          const SizedBox(height: 24),
          const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...data.recentTransactions.map((t) => ListTile(
            title: Text(t.description),
            subtitle: Text(t.date.toString()), // Simple formatting
            trailing: Text('- \${t.amount.toStringAsFixed(2)}'),
          )),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double remaining, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Remaining Budget', style: TextStyle(color: Colors.white70)),
          Text('\$${remaining.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Total: \$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
