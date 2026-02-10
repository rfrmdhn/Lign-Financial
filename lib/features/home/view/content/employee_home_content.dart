import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/features/home/model/transaction.dart';
import 'package:lign_financial/features/home/viewmodel/home_viewmodel.dart';
import 'package:intl/intl.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card
          _buildBalanceCard(data.remainingBudget, data.totalBudget, data.monthlyLimit),
          
          const SizedBox(height: 32),
          
          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // 2x2 Grid
          Row(
            children: [
              _QuickActionButton(
                icon: Icons.qr_code_scanner,
                label: 'Pay (QRIS)',
                onTap: () => context.push('/qris'),
              ),
              const SizedBox(width: 12),
              _QuickActionButton(
                icon: Icons.swap_horiz,
                label: 'Transfer',
                onTap: () => context.push('/transfer'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _QuickActionButton(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Top Up',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _QuickActionButton(
                icon: Icons.receipt_long,
                label: 'History',
                onTap: () => context.push('/activity'),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Recent Transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/activity'),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: LignColors.electricLime,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (data.recentTransactions.isEmpty)
             const Center(
               child: Padding(
                 padding: EdgeInsets.all(32.0),
                 child: Text('No recent transactions', style: TextStyle(color: LignColors.textSecondary)),
               ),
             )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.recentTransactions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transaction = data.recentTransactions[index];
                return _TransactionItem(transaction: transaction);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(double remaining, double total, double limit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LignColors.textPrimary, // Dark background
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: LignColors.textPrimary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remaining Budget',
                style: GoogleFonts.inter(
                  color: LignColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: LignColors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Limit: ${CurrencyFormatter.compact(limit)}',
                  style: GoogleFonts.inter(
                    color: LignColors.textDisabled,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            CurrencyFormatter.format(remaining),
            style: GoogleFonts.outfit(
              color: LignColors.electricLime,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? (total - remaining) / total : 0,
              backgroundColor: LignColors.textSecondary.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(LignColors.electricLime),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
           Text(
            '${((total - remaining) / total * 100).toStringAsFixed(1)}% spent of ${CurrencyFormatter.format(total)}',
            style: GoogleFonts.inter(
              color: LignColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: LignColors.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LignColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: LignColors.textPrimary, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: LignColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return LignCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LignColors.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 20,
              color: LignColors.textPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchant,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LignColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: LignColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '- ${CurrencyFormatter.format(transaction.amount)}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(transaction.date),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: LignColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM HH:mm').format(date);
  }
}
