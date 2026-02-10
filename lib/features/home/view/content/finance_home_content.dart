import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/home/viewmodel/home_viewmodel.dart';

class FinanceHomeContent extends ConsumerWidget {
  const FinanceHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final data = state.financeData;

    if (data == null) {
      return const Center(child: Text('No Data'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompanyBalanceCard(data.totalCompanyBalance, data.remainingBalance),
          const SizedBox(height: 24),
          Text('${data.pendingApprovals.length} Pending Approvals', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
           ...data.pendingApprovals.map((a) => ListTile(
            title: Text(a.employeeName),
            subtitle: Text(a.description),
            trailing: Text('\$${a.amount.toStringAsFixed(2)}'),
          )),
        ],
      ),
    );
  }

  Widget _buildCompanyBalanceCard(double total, double remaining) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Company Balance', style: TextStyle(color: Colors.white70)),
          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
           const SizedBox(height: 8),
          Text('Remaining: \$${remaining.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
