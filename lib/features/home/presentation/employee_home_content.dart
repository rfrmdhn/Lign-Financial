import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/features/home/data/home_view_model.dart';

class EmployeeHomeContent extends ConsumerWidget {
  const EmployeeHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(employeeHomeDataProvider);
    final fmt = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Personal Budget Card
          _PersonalBudgetCard(data: data, fmt: fmt),
          const SizedBox(height: 24),

          // 2. Quick Actions Grid 2x2
          _QuickActionsGrid(),
          const SizedBox(height: 24),

          // 3. Recent Transactions
          _RecentTransactionsSection(
              transactions: data.recentTransactions, fmt: fmt),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// =============================================================================
// 1. PERSONAL BUDGET CARD
// =============================================================================

class _PersonalBudgetCard extends StatelessWidget {
  final EmployeeHomeData data;
  final NumberFormat fmt;

  const _PersonalBudgetCard({required this.data, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return LignCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Budget',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: LignColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: LignColors.electricLime.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Monthly',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: LignColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Remaining Budget (dominant)
          Text(
            'Remaining Budget',
            style: GoogleFonts.inter(fontSize: 12, color: LignColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            fmt.format(data.remainingBudget),
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 1.0 - data.spentPercentage,
              backgroundColor: LignColors.border,
              color: LignColors.electricLime,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent ${fmt.format(data.spent)}',
                style: GoogleFonts.inter(
                    fontSize: 11, color: LignColors.textSecondary),
              ),
              Text(
                'of ${fmt.format(data.monthlyLimit)}',
                style: GoogleFonts.inter(
                    fontSize: 11, color: LignColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Container(height: 1, color: LignColors.border),
          const SizedBox(height: 12),

          // Total + Monthly row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Budget',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: LignColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fmt.format(data.totalBudget),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LignColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Limit',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: LignColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fmt.format(data.monthlyLimit),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LignColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 2. QUICK ACTIONS GRID
// =============================================================================

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: LignColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionItem(
                icon: Icons.qr_code_scanner,
                label: 'Pay',
                isPrimary: true,
                onTap: () => context.go('/qris'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionItem(
                icon: Icons.send_outlined,
                label: 'Transfer',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Top Up',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionItem(
                icon: Icons.history,
                label: 'History',
                onTap: () => context.go('/activity'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? LignColors.electricLime : LignColors.primaryBackground,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary ? LignColors.electricLime : LignColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: LignColors.textPrimary),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
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

// =============================================================================
// 3. RECENT TRANSACTIONS
// =============================================================================

class _RecentTransactionsSection extends StatelessWidget {
  final List<Transaction> transactions;
  final NumberFormat fmt;

  const _RecentTransactionsSection({
    required this.transactions,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
            Text(
              'See all',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: LignColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: LignColors.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LignColors.border),
          ),
          child: Column(
            children: List.generate(transactions.length, (index) {
              final tx = transactions[index];
              return Column(
                children: [
                  _TransactionTile(transaction: tx, fmt: fmt),
                  if (index < transactions.length - 1)
                    const Divider(
                        height: 1, indent: 60, color: LignColors.border),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final NumberFormat fmt;

  const _TransactionTile({required this.transaction, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPositive
                  ? LignColors.electricLime.withValues(alpha: 0.15)
                  : LignColors.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPositive
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 16,
              color: isPositive
                  ? const Color(0xFF2E7D32)
                  : LignColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
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
                  timeFormat.format(transaction.date),
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
                '${isPositive ? '+' : '-'}${fmt.format(transaction.amount.abs())}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPositive
                      ? const Color(0xFF2E7D32)
                      : LignColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              _StatusBadge(status: transaction.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case TransactionStatus.completed:
        bgColor = LignColors.electricLime.withValues(alpha: 0.2);
        textColor = const Color(0xFF2E7D32);
        label = 'Completed';
      case TransactionStatus.pending:
        bgColor = LignColors.warning.withValues(alpha: 0.15);
        textColor = const Color(0xFFB8860B);
        label = 'Pending';
      case TransactionStatus.rejected:
        bgColor = LignColors.error.withValues(alpha: 0.12);
        textColor = LignColors.error;
        label = 'Rejected';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
