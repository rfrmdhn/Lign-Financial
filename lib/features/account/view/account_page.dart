import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/features/account/viewmodel/account_viewmodel.dart';


import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountViewModelProvider);

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text(state.errorMessage!))
              : state.data == null
                  ? const SizedBox()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Company Account Info
                          const _SectionHeader(title: 'Company Account'),
                          const SizedBox(height: 12),
                          LignCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _InfoRow(label: 'Company Name', value: state.data!.companyName),
                                const Divider(height: 24, color: LignColors.border),
                                _InfoRow(label: 'Account Number', value: state.data!.accountNumber),
                                const Divider(height: 24, color: LignColors.border),
                                _InfoRow(
                                  label: 'Account Balance',
                                  value: CurrencyFormatter.format(state.data!.balance),
                                  isHighlight: true,
                                ),
                                const Divider(height: 24, color: LignColors.border),
                                _InfoRow(label: 'Account Type', value: state.data!.accountType),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Linked Bank Accounts
                          const _SectionHeader(title: 'Linked Bank Accounts'),
                          const SizedBox(height: 12),
                          ...state.data!.linkedAccounts.map((account) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _BankAccountCard(
                                  bankName: account.bankName,
                                  accountNumber: account.accountNumber,
                                  isPrimary: account.isPrimary,
                                ),
                              )),
                          const SizedBox(height: 28),

                          // Virtual Accounts
                          const _SectionHeader(title: 'Virtual Accounts'),
                          const SizedBox(height: 12),
                          LignCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ...state.data!.virtualAccounts.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final va = entry.value;
                                  return Column(
                                    children: [
                                      if (index > 0)
                                        const Divider(height: 24, color: LignColors.border),
                                      _VirtualAccountRow(
                                        label: va.label,
                                        vaNumber: va.number,
                                      ),
                                    ],
                                  );
                                }),
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
