import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Account Info
            _SectionHeader(title: 'Company Account'),
            const SizedBox(height: 12),
            LignCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _InfoRow(label: 'Company Name', value: 'PT Lign Teknologi'),
                  const Divider(height: 24, color: LignColors.border),
                  _InfoRow(label: 'Account Number', value: '888 0012 3456 789'),
                  const Divider(height: 24, color: LignColors.border),
                  _InfoRow(
                    label: 'Account Balance',
                    value: CurrencyFormatter.format(2450000000),
                    isHighlight: true,
                  ),
                  const Divider(height: 24, color: LignColors.border),
                  _InfoRow(label: 'Account Type', value: 'Corporate Business'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Linked Bank Accounts
            _SectionHeader(title: 'Linked Bank Accounts'),
            const SizedBox(height: 12),
            _BankAccountCard(
              bankName: 'Bank Central Asia (BCA)',
              accountNumber: '*** **** 4567',
              isPrimary: true,
            ),
            const SizedBox(height: 10),
            _BankAccountCard(
              bankName: 'Bank Mandiri',
              accountNumber: '*** **** 8901',
              isPrimary: false,
            ),
            const SizedBox(height: 28),

            // Virtual Accounts
            _SectionHeader(title: 'Virtual Accounts'),
            const SizedBox(height: 12),
            LignCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _VirtualAccountRow(
                    label: 'Payment Collection',
                    vaNumber: '8800 1234 5678 9012',
                  ),
                  const Divider(height: 24, color: LignColors.border),
                  _VirtualAccountRow(
                    label: 'Payroll Disbursement',
                    vaNumber: '8800 9876 5432 1098',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: LignColors.textPrimary,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: LignColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isHighlight
                ? const Color(0xFF2E7D32)
                : LignColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _BankAccountCard extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final bool isPrimary;

  const _BankAccountCard({
    required this.bankName,
    required this.accountNumber,
    required this.isPrimary,
  });

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
              Icons.account_balance,
              size: 20,
              color: LignColors.textSecondary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LignColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  accountNumber,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: LignColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isPrimary)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: LignColors.electricLime.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Primary',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: LignColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VirtualAccountRow extends StatelessWidget {
  final String label;
  final String vaNumber;

  const _VirtualAccountRow({
    required this.label,
    required this.vaNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: LignColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              vaNumber,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: LignColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: const Icon(Icons.copy, size: 18, color: LignColors.textSecondary),
        ),
      ],
    );
  }
}
