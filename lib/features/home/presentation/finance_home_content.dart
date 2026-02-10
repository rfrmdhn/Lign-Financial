import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/features/home/data/home_view_model.dart';

class FinanceHomeContent extends ConsumerWidget {
  const FinanceHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(financeHomeDataProvider);
    final fmt = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Company Wallet Summary
          _CompanyWalletCard(data: data, fmt: fmt),
          const SizedBox(height: 20),

          // 2. Budget Overview
          _BudgetOverviewCard(data: data, fmt: fmt),
          const SizedBox(height: 20),

          // 3. Pending Approvals
          if (data.pendingApprovals.isNotEmpty) ...[
            _PendingApprovalsSection(
                approvals: data.pendingApprovals, fmt: fmt),
            const SizedBox(height: 20),
          ],

          // 4. Recent Company Transactions
          _RecentTransactionsSection(
              transactions: data.recentCompanyTransactions, fmt: fmt),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// =============================================================================
// 1. COMPANY WALLET SUMMARY
// =============================================================================

class _CompanyWalletCard extends StatelessWidget {
  final FinanceHomeData data;
  final NumberFormat fmt;

  const _CompanyWalletCard({required this.data, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Company Wallet',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white54,
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
                  'Manage Budget',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: LignColors.electricLime,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Total Balance
          Text(
            'Total Company Balance',
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
          ),
          const SizedBox(height: 4),
          Text(
            fmt.format(data.totalCompanyBalance),
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 20),

          // Allocated + Remaining Row
          Row(
            children: [
              Expanded(
                child: _WalletMetric(
                  label: 'Total Allocated',
                  value: fmt.format(data.totalAllocatedBudget),
                  color: LignColors.electricLime,
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: Colors.white12,
              ),
              Expanded(
                child: _WalletMetric(
                  label: 'Remaining',
                  value: fmt.format(data.remainingBalance),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _WalletMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white38),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 2. BUDGET OVERVIEW
// =============================================================================

class _BudgetOverviewCard extends StatelessWidget {
  final FinanceHomeData data;
  final NumberFormat fmt;

  const _BudgetOverviewCard({required this.data, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return LignCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Overview',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Metrics row
          Row(
            children: [
              _OverviewMetric(
                icon: Icons.people_outline,
                value: '${data.activeEmployees}',
                label: 'Active Employees',
              ),
              const SizedBox(width: 16),
              _OverviewMetric(
                icon: Icons.account_balance_wallet_outlined,
                value: _formatCompact(data.totalDistributedBudget),
                label: 'Distributed',
              ),
              const SizedBox(width: 16),
              _OverviewMetric(
                icon: Icons.trending_up,
                value: '${(data.budgetUsagePercentage * 100).toStringAsFixed(0)}%',
                label: 'Used',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.budgetUsagePercentage,
              backgroundColor: LignColors.border,
              color: data.budgetUsagePercentage > 0.8
                  ? LignColors.warning
                  : LignColors.electricLime,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Used ${fmt.format(data.budgetUsed)}',
                style: GoogleFonts.inter(
                    fontSize: 11, color: LignColors.textSecondary),
              ),
              Text(
                'of ${fmt.format(data.totalDistributedBudget)}',
                style: GoogleFonts.inter(
                    fontSize: 11, color: LignColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatCompact(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(0)}M';
    }
    return NumberFormat.compact().format(value);
  }
}

class _OverviewMetric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _OverviewMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: LignColors.secondaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: LignColors.textSecondary),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 10, color: LignColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 3. PENDING APPROVALS
// =============================================================================

class _PendingApprovalsSection extends StatelessWidget {
  final List<PendingApproval> approvals;
  final NumberFormat fmt;

  const _PendingApprovalsSection({
    required this.approvals,
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
              'Pending Approval',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: LignColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${approvals.length}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: LignColors.warning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...approvals.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ApprovalCard(approval: a, fmt: fmt),
            )),
      ],
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final PendingApproval approval;
  final NumberFormat fmt;

  const _ApprovalCard({required this.approval, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return LignCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: LignColors.electricLime.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    approval.employeeName[0],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: LignColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      approval.employeeName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: LignColors.textPrimary,
                      ),
                    ),
                    Text(
                      approval.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: LignColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                fmt.format(approval.amount),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LignButton(
                  text: 'Reject',
                  type: LignButtonType.secondary,
                  onPressed: () {},
                  isFullWidth: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LignButton(
                  text: 'Approve',
                  onPressed: () {},
                  isFullWidth: true,
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
// 4. RECENT COMPANY TRANSACTIONS
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
              'View All',
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
                  _CompanyTransactionTile(transaction: tx, fmt: fmt),
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

class _CompanyTransactionTile extends StatelessWidget {
  final Transaction transaction;
  final NumberFormat fmt;

  const _CompanyTransactionTile({
    required this.transaction,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;

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
                  transaction.employeeName ?? transaction.description,
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
