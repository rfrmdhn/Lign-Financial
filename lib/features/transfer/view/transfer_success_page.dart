import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';

/// Page 5: Transfer success with conditional "Save Recipient" button.
class TransferSuccessPage extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final double amount;
  final bool isExistingRecipient;

  const TransferSuccessPage({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    required this.amount,
    required this.isExistingRecipient,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: LignColors.electricLime.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: LignColors.electricLime,
                  size: 56,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Transfer Successful',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                CurrencyFormatter.format(amount),
                style: GoogleFonts.outfit(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),

              const SizedBox(height: 32),

              // Transfer details card
              LignCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(label: 'Recipient', value: accountHolderName),
                    const Divider(height: 24, color: LignColors.border),
                    _DetailRow(label: 'Bank', value: bankName),
                    const Divider(height: 24, color: LignColors.border),
                    _DetailRow(label: 'Account', value: accountNumber),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Buttons
              LignButton(
                text: 'Download Receipt',
                type: LignButtonType.secondary,
                icon: Icons.download_outlined,
                onPressed: () {
                  // Mock — no-op
                },
              ),
              const SizedBox(height: 12),

              // Conditional: Save new recipient
              if (!isExistingRecipient) ...[
                LignButton(
                  text: 'Save as New Recipient',
                  type: LignButtonType.secondary,
                  icon: Icons.person_add_outlined,
                  onPressed: () {
                    context.push('/transfer/save-recipient', extra: {
                      'bankName': bankName,
                      'bankCode': bankName,
                      'accountNumber': accountNumber,
                      'accountHolderName': accountHolderName,
                    });
                  },
                ),
                const SizedBox(height: 12),
              ],

              LignButton(
                text: 'Back to Home',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

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
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: LignColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
