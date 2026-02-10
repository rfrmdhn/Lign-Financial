import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lign_financial/core/design_system/colors.dart';

import 'package:lign_financial/core/widgets/lign_card.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Employee User',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: LignColors.secondaryBackground,
                    child: Icon(Icons.notifications_outlined, color: LignColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Company Balance (Read-only)
              LignCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.business, size: 16, color: LignColors.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Company Balance',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(150000000),
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LignColors.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Personal Limit & Remaining
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: LignColors.textPrimary, // Black card
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining Limit',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(3500000),
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: LignColors.electricLime,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.7, // 3.5m / 5m remaining -> 70%
                      backgroundColor: Colors.white24,
                      color: LignColors.electricLime,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent: ${currencyFormat.format(1500000)}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          'Limit: ${currencyFormat.format(5000000)}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.qr_code_scanner,
                      label: 'QRIS Pay',
                      isActive: true,
                      onTap: () => context.go('/employee/qris'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.send_outlined,
                      label: 'Transfer',
                      onTap: () {}, // TODO: Implement Transfer
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Transactions (Mock)
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _TransactionItem(
                title: 'Grab Transport',
                date: 'Today, 10:30 AM',
                amount: -45000,
                category: 'Transport',
              ),
              _TransactionItem(
                title: 'Starbucks Coffee',
                date: 'Yesterday, 08:15 AM',
                amount: -65000,
                category: 'Meals',
              ),
              _TransactionItem(
                title: 'Reimbursement Approved',
                date: 'Mon, 09:00 AM',
                amount: 150000,
                category: 'Refund',
                isPositive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? LignColors.electricLime : LignColors.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? LignColors.electricLime : LignColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: LignColors.textPrimary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final double amount;
  final String category;
  final bool isPositive;

  const _TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.category,
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
                Text(date, style: Theme.of(context).textTheme.bodySmall),
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
