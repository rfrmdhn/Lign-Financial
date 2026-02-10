import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/core/widgets/lign_status_badge.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/features/home/domain/home_data.dart';
import 'package:lign_financial/features/home/domain/transaction.dart';
import 'package:lign_financial/features/home/presentation/home_providers.dart';

class EmployeeHomeContent extends ConsumerWidget {
  const EmployeeHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(employeeHomeDataProvider);

    return dataAsync.when(
      data: (data) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Personal Budget Card
            _PersonalBudgetCard(data: data),
            const SizedBox(height: 24),

            // 2. Quick Actions Grid 2x2
            _QuickActionsGrid(),
            const SizedBox(height: 24),

            // 3. Recent Transactions
            _RecentTransactionsSection(transactions: data.recentTransactions),
            const SizedBox(height: 16),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

// =============================================================================
// 1. PERSONAL BUDGET CARD
// =============================================================================

class _PersonalBudgetCard extends StatelessWidget {
  final EmployeeHomeData data;

  const _PersonalBudgetCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/budget'),
      child: LignCard(
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
            CurrencyFormatter.format(data.remainingBudget),
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
                'Spent ${CurrencyFormatter.format(data.spent)}',
                style: GoogleFonts.inter(
                    fontSize: 11, color: LignColors.textSecondary),
              ),
              Text(
                'of ${CurrencyFormatter.format(data.monthlyLimit)}',
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
                      CurrencyFormatter.format(data.totalBudget),
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
                      CurrencyFormatter.format(data.monthlyLimit),
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
                onTap: () => context.push('/transfer'),
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

class _QuickActionItem extends StatefulWidget {
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
  State<_QuickActionItem> createState() => _QuickActionItemState();
}

class _QuickActionItemState extends State<_QuickActionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? LignColors.electricLime
                : LignColors.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isPrimary
                  ? LignColors.electricLime
                  : LignColors.border,
            ),
          ),
          child: Column(
            children: [
              Icon(widget.icon, size: 28, color: LignColors.textPrimary),
              const SizedBox(height: 8),
              Text(
                widget.label,
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

  const _RecentTransactionsSection({
    required this.transactions,
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
            GestureDetector(
              onTap: () => context.go('/activity'),
              child: Text(
                'See all',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: LignColors.textSecondary,
                ),
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
                  _TransactionTile(transaction: tx),
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

  const _TransactionTile({required this.transaction});

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
                '${isPositive ? '+' : '-'}${CurrencyFormatter.format(transaction.amount.abs())}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPositive
                      ? const Color(0xFF2E7D32)
                      : LignColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              LignStatusBadge(status: transaction.status),
            ],
          ),
        ],
      ),
    );
  }
}


