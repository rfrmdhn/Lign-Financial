import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/features/auth/data/auth_repository.dart';

class EmployeeProfileScreen extends ConsumerWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: LignColors.secondaryBackground,
              child: Icon(Icons.person, size: 40, color: LignColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              authState.user?.name ?? 'Employee User',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: LignColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: LignColors.electricLime.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'EMPLOYEE',
                style: TextStyle(
                  color: LignColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('My Limits'),
            const SizedBox(height: 16),
            _buildInfoRow('Monthly Limit', currencyFormat.format(5000000)),
            _buildInfoRow('Transaction Limit', currencyFormat.format(2000000)),
            _buildInfoRow('Remaining', currencyFormat.format(3500000), isHighlight: true),
            
            const SizedBox(height: 32),
            _buildSectionHeader('Company Policy'),
            const SizedBox(height: 16),
            _buildPolicyItem('Expense approval required > Rp 1.000.000'),
            _buildPolicyItem('Receipts mandatory for all transactions'),
            _buildPolicyItem('Travel expenses need prior approval'),

            const SizedBox(height: 48),
            LignButton(
              text: 'Logout',
              type: LignButtonType.secondary,
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: LignColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: LignColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isHighlight ? LignColors.electricLime : LignColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: LignColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(color: LignColors.textPrimary, fontSize: 13))),
        ],
      ),
    );
  }
}
