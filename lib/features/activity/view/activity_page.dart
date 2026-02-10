import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_status_badge.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/features/auth/domain/app_mode.dart';
import 'package:lign_financial/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:lign_financial/features/home/model/transaction.dart';
import 'package:lign_financial/features/activity/viewmodel/activity_viewmodel.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen>
    with SingleTickerProviderStateMixin {
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
    // Use AuthViewModel to determine mode
    final authState = ref.watch(authViewModelProvider);
    final isFinance = authState.activeMode == AppMode.finance; 

    final state = ref.watch(activityViewModelProvider);
    final viewModel = ref.read(activityViewModelProvider.notifier);
    
    final transactions = viewModel.filteredTransactions;

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: Text(isFinance ? 'Company Activity' : 'My Activity'),
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
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Pending'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text(state.errorMessage!))
              : Column(
                  children: [
                    // Filters (Finance mode only - disabled/hidden if not finance)
                    if (isFinance) ...[
                      Container(
                        color: LignColors.primaryBackground,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            _FilterChip(
                              label: 'All',
                              isSelected: state.dateFilter == 'All',
                              onTap: () => viewModel.setDateFilter('All'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Today',
                              isSelected: state.dateFilter == 'Today',
                              onTap: () => viewModel.setDateFilter('Today'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'This Week',
                              isSelected: state.dateFilter == 'This Week',
                              onTap: () => viewModel.setDateFilter('This Week'),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Transaction List
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _TransactionList(transactions: transactions),
                          _TransactionList(
                            transactions: transactions
                                .where((t) =>
                                    t.status == TransactionStatus.completed)
                                .toList(),
                          ),
                          _TransactionList(
                            transactions: transactions
                                .where((t) =>
                                    t.status == TransactionStatus.pending)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? LignColors.electricLime
              : LignColors.secondaryBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? LignColors.electricLime : LignColors.border,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: LignColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 60, color: LignColors.border),
            const SizedBox(height: 16),
            Text(
              'No transactions found',
              style: GoogleFonts.inter(color: LignColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return _ActivityTransactionCard(transaction: tx);
      },
    );
  }
}

class _ActivityTransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _ActivityTransactionCard({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount > 0;
    final dateFormat = DateFormat('dd MMM, HH:mm');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LignColors.primaryBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LignColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
              size: 18,
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
                  dateFormat.format(transaction.date),
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
                  fontSize: 14,
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


