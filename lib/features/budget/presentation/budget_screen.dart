import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/features/home/data/home_view_model.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(employeeHomeDataProvider);

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('My Budget'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BudgetOverviewCard(data: data),
            const SizedBox(height: 24),
            Text(
              'Budget Breakdown',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _BudgetUseItem(
              category: 'Food & Beverage',
              amount: 1500000,
              total: 3000000,
              color: Colors.orange,
              icon: Icons.fastfood,
            ),
            const SizedBox(height: 12),
            _BudgetUseItem(
              category: 'Transportation',
              amount: 800000,
              total: 2000000,
              color: Colors.blue,
              icon: Icons.directions_car,
            ),
            const SizedBox(height: 12),
            _BudgetUseItem(
              category: 'Office Supplies',
              amount: 200000,
              total: 1000000,
              color: Colors.purple,
              icon: Icons.print,
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetOverviewCard extends StatelessWidget {
  final EmployeeHomeData data;

  const _BudgetOverviewCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return LignCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Remaining Balance',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: LignColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(data.remainingBudget),
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BudgetStat(
                label: 'Total Budget',
                value: CurrencyFormatter.format(data.totalBudget),
              ),
              _BudgetStat(
                label: 'This Month',
                value: CurrencyFormatter.format(data.monthlyLimit),
                alignRight: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: data.spentPercentage,
              minHeight: 12,
              backgroundColor: LignColors.secondaryBackground,
              color: LignColors.electricLime,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(data.spentPercentage * 100).toInt()}% Used',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: LignColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetStat extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;

  const _BudgetStat({
    required this.label,
    required this.value,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: LignColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _BudgetUseItem extends StatelessWidget {
  final String category;
  final double amount;
  final double total;
  final Color color;
  final IconData icon;

  const _BudgetUseItem({
    required this.category,
    required this.amount,
    required this.total,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = amount / total;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LignColors.primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: LignColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 6,
                    backgroundColor: LignColors.secondaryBackground,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            CurrencyFormatter.format(amount),
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
