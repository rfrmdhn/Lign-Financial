import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';

class FinanceHomeScreen extends StatelessWidget {
  const FinanceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Overview'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Company Balance
            LignCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('Total Cash Balance', style: Theme.of(context).textTheme.bodyMedium),
                   const SizedBox(height: 8),
                   Text(
                      currencyFormat.format(2450000000), // 2.45 Miliar
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Action Needed
            Text('Action Needed', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => context.go('/finance/approvals'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: LignColors.electricLime.withValues(alpha: 0.1),
                  border: Border.all(color: LignColors.electricLime),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.assignment_late, color: Colors.orange),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('12 Pending Approvals', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Expense reports & card requests', style: TextStyle(fontSize: 12, color: LignColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: LignColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Spending Trends Mock
            Text('This Month Spending', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LignCard(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                height: 150,
                child: Center(
                  child: Text('Spending Chart Placeholder', style: TextStyle(color: LignColors.textDisabled)),
                ),
              ),
            ),
             const SizedBox(height: 24),
            
            Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
             const SizedBox(height: 16),
             _ActivityItem(title: 'Server Cost Payment', subtitle: 'Auto-debit', amount: -6500000),
             _ActivityItem(title: 'Top Up - Operational', subtitle: 'Transfer In', amount: 50000000, isPositive: true),
             _ActivityItem(title: 'Client Dinner', subtitle: 'Employee Expense', amount: -1250000),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final bool isPositive;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Padding(
       padding: const EdgeInsets.only(bottom: 16.0),
       child: Row(
         children: [
           CircleAvatar(
             backgroundColor: LignColors.secondaryBackground,
             child: Icon(
               isPositive ? Icons.arrow_downward : Icons.arrow_upward,
               color: isPositive ? LignColors.success : LignColors.textPrimary,
               size: 16,
             ),
           ),
           const SizedBox(width: 16),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                 Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
               ],
             ),
           ),
           Text(
             currencyFormat.format(amount.abs()),
             style: TextStyle(
               fontWeight: FontWeight.bold,
               color: isPositive ? LignColors.success : LignColors.textPrimary,
             ),
           ),
         ],
       ),
    );
  }
}
