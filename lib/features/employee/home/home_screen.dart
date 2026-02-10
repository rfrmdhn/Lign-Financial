import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/features/auth/presentation/auth_controller.dart';
import 'package:lign_financial/features/employee/home/home_view_model.dart';

class EmployeeHomeScreen extends ConsumerWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeDataProvider);
    final authState = ref.watch(authControllerProvider);
    final userName = authState.user?.name ?? 'Employee';

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. App Header
              _AppHeader(
                userName: userName,
                notificationCount: homeData.notificationCount,
              ),
              const SizedBox(height: 24),

              // 2. Balance & Limit Card
              _BalanceLimitCard(homeData: homeData),
              const SizedBox(height: 24),

              // 3. Primary Action Row
              const _PrimaryActionRow(),
              const SizedBox(height: 24),

              // 4. Alerts (Conditional)
              if (homeData.alerts.isNotEmpty) ...[
                _AlertsSection(alerts: homeData.alerts),
                const SizedBox(height: 24),
              ],

              // 5. Recent Activity
              _RecentActivitySection(
                transactions: homeData.recentTransactions,
              ),

              // 6. Insight Card (Optional)
              if (homeData.insightText != null) ...[
                const SizedBox(height: 24),
                _InsightCard(text: homeData.insightText!),
              ],

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 1. APP HEADER
// =============================================================================

class _AppHeader extends StatelessWidget {
  final String userName;
  final int notificationCount;

  const _AppHeader({
    required this.userName,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Company / Account name
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lign Financial',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: LignColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Notification bell with badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: LignColors.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LignColors.border),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: LignColors.textPrimary,
                size: 20,
              ),
            ),
            if (notificationCount > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: LignColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      notificationCount > 9 ? '9+' : '$notificationCount',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),

        // Profile avatar
        GestureDetector(
          onTap: () => context.go('/employee/profile'),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LignColors.electricLime.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : 'E',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// 2. BALANCE & LIMIT CARD
// =============================================================================

class _BalanceLimitCard extends StatelessWidget {
  final HomeData homeData;

  const _BalanceLimitCard({required this.homeData});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return LignCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Balance
          Row(
            children: [
              const Icon(Icons.business_outlined,
                  size: 14, color: LignColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Company Available Balance',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: LignColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            currencyFormat.format(homeData.companyBalance),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              height: 1,
              color: LignColors.border,
            ),
          ),

          // Monthly Limit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly Limit',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: LignColors.textSecondary,
                ),
              ),
              Text(
                currencyFormat.format(homeData.monthlyLimit),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: LignColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Remaining Limit (DOMINANT)
          Text(
            'Remaining Limit',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: LignColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currencyFormat.format(homeData.remainingLimit),
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 1.0 - homeData.spentPercentage,
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
                'Spent ${currencyFormat.format(homeData.spent)}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: LignColors.textSecondary,
                ),
              ),
              Text(
                'of ${currencyFormat.format(homeData.monthlyLimit)}',
                style: GoogleFonts.inter(
                  fontSize: 11,
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

// =============================================================================
// 3. PRIMARY ACTION ROW
// =============================================================================

class _PrimaryActionRow extends StatelessWidget {
  const _PrimaryActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // QRIS — Primary, lime accent
        Expanded(
          child: _ActionButton(
            icon: Icons.qr_code_scanner,
            label: 'QRIS',
            isPrimary: true,
            iconSize: 28,
            onTap: () => context.go('/employee/qris'),
          ),
        ),
        const SizedBox(width: 12),
        // Transfer — Neutral
        Expanded(
          child: _ActionButton(
            icon: Icons.send_outlined,
            label: 'Transfer',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        // Expense — Neutral
        Expanded(
          child: _ActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'Expense',
            onTap: () => context.go('/employee/expenses'),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final double iconSize;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    this.iconSize = 24,
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
              Icon(icon, size: iconSize, color: LignColors.textPrimary),
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
// 4. ALERTS SECTION
// =============================================================================

class _AlertsSection extends StatelessWidget {
  final List<HomeAlert> alerts;

  const _AlertsSection({required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alerts',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: LignColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...alerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AlertCard(alert: alert),
            )),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final HomeAlert alert;

  const _AlertCard({required this.alert});

  Color get _accentColor {
    switch (alert.type) {
      case AlertType.info:
        return LignColors.electricLime;
      case AlertType.warning:
        return LignColors.warning;
      case AlertType.blocked:
        return LignColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: LignColors.primaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LignColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(alert.icon, size: 16, color: _accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              alert.message,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: LignColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: LignColors.textSecondary),
        ],
      ),
    );
  }
}

// =============================================================================
// 5. RECENT ACTIVITY
// =============================================================================

class _RecentActivitySection extends StatelessWidget {
  final List<Transaction> transactions;

  const _RecentActivitySection({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
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
                  _TransactionTile(transaction: tx),
                  if (index < transactions.length - 1)
                    const Divider(
                      height: 1,
                      indent: 60,
                      color: LignColors.border,
                    ),
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
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final isPositive = transaction.amount > 0;
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Icon
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
              isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              size: 16,
              color: isPositive ? const Color(0xFF2E7D32) : LignColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),

          // Merchant & description
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

          // Amount & status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}${currencyFormat.format(transaction.amount.abs())}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? const Color(0xFF2E7D32) : LignColors.textPrimary,
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

// =============================================================================
// 6. INSIGHT CARD
// =============================================================================

class _InsightCard extends StatelessWidget {
  final String text;

  const _InsightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: LignColors.electricLime.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: LignColors.electricLime.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: LignColors.electricLime.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.insights_outlined,
              size: 16,
              color: LignColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: LignColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
