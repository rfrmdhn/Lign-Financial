import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/features/home/model/home_data.dart';
import 'package:lign_financial/features/home/model/transaction.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Company Wallet Summary
          _CompanyWalletCard(data: data),

          const SizedBox(height: 28),

          // 2. Budget Overview
          _BudgetOverviewSection(data: data),

          const SizedBox(height: 28),

          // 3. Pending Approvals
          _PendingApprovalsSection(approvals: data.pendingApprovals),

          const SizedBox(height: 28),

          // 4. Recent Company Transactions
          _RecentTransactionsSection(transactions: data.recentCompanyTransactions),
        ],
      ),
    );
  }
}

// ─── 1. Company Wallet Summary ───────────────────────────────────────────────

class _CompanyWalletCard extends StatelessWidget {
  final FinanceHomeData data;
  const _CompanyWalletCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Company Balance',
            style: GoogleFonts.inter(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(data.totalCompanyBalance),
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _WalletInfoChip(
                label: 'Allocated',
                value: CurrencyFormatter.compact(data.totalAllocatedBudget),
              ),
              const SizedBox(width: 12),
              _WalletInfoChip(
                label: 'Remaining',
                value: CurrencyFormatter.compact(data.remainingBalance),
                highlight: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: LignColors.electricLime,
                side: const BorderSide(color: LignColors.electricLime),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Manage Budget',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _WalletInfoChip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 10),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                color: highlight ? LignColors.electricLime : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 2. Budget Overview ──────────────────────────────────────────────────────

class _BudgetOverviewSection extends StatelessWidget {
  final FinanceHomeData data;
  const _BudgetOverviewSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Budget Overview',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: LignColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _OverviewStat(
              icon: Icons.people_outline,
              label: 'Active Employees',
              value: data.activeEmployees.toString(),
            ),
            const SizedBox(width: 12),
            _OverviewStat(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Distributed',
              value: CurrencyFormatter.compact(data.totalDistributedBudget),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Usage progress
        LignCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Used',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: LignColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(data.budgetUsagePercentage * 100).toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: LignColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: data.budgetUsagePercentage,
                  backgroundColor: LignColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    data.budgetUsagePercentage > 0.8
                        ? LignColors.error
                        : LignColors.electricLime,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${CurrencyFormatter.compact(data.budgetUsed)} of ${CurrencyFormatter.compact(data.totalDistributedBudget)}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: LignColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OverviewStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _OverviewStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LignCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: LignColors.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: LignColors.textPrimary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: LignColors.textPrimary,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: LignColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 3. Pending Approvals ────────────────────────────────────────────────────

class _PendingApprovalsSection extends StatelessWidget {
  final List<PendingApproval> approvals;
  const _PendingApprovalsSection({required this.approvals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pending Approvals',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            if (approvals.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: LignColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  approvals.length.toString(),
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
        if (approvals.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No pending approvals',
                style: GoogleFonts.inter(color: LignColors.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: approvals.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ApprovalCard(approval: approvals[i]),
          ),
      ],
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  final PendingApproval approval;
  const _ApprovalCard({required this.approval});

  @override
  Widget build(BuildContext context) {
    return LignCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: LignColors.secondaryBackground,
                child: Text(
                  approval.employeeName[0],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: LignColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      approval.employeeName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LignColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: LignColors.secondaryBackground,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            approval.transactionType,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: LignColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            approval.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: LignColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(approval.amount),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: LignColors.error,
                    side: const BorderSide(color: LignColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LignColors.textPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── 4. Recent Company Transactions ──────────────────────────────────────────

class _RecentTransactionsSection extends StatelessWidget {
  final List<Transaction> transactions;
  const _RecentTransactionsSection({required this.transactions});

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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: LignColors.electricLime,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No recent transactions',
                style: GoogleFonts.inter(color: LignColors.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) =>
                _CompanyTransactionItem(transaction: transactions[i]),
          ),
      ],
    );
  }
}

class _CompanyTransactionItem extends StatelessWidget {
  final Transaction transaction;
  const _CompanyTransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, HH:mm');

    return LignCard(
      padding: const EdgeInsets.all(14),
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
              Icons.receipt_outlined,
              size: 20,
              color: LignColors.textPrimary,
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
                CurrencyFormatter.format(transaction.amount),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateFormat.format(transaction.date),
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
}
