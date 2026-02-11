import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/features/qris/viewmodel/qris_viewmodel.dart';

/// Payment Success Page — shown after payment is completed.
class QrisSuccessPage extends ConsumerWidget {
  const QrisSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qrisViewModelProvider);
    final response = state.paymentResponse;

    final merchantName = response?.merchantName ?? 'Merchant';
    final amount = state.amount;
    final paymentDate = state.paymentDate ?? DateTime.now();
    final referenceId = response?.id ?? '-';

    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(paymentDate);

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
                'Payment Successful',
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

              // Details card
              LignCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _DetailRow(label: 'Merchant', value: merchantName),
                    const Divider(height: 24, color: LignColors.border),
                    _DetailRow(label: 'Date', value: formattedDate),
                    const Divider(height: 24, color: LignColors.border),
                    _DetailRow(label: 'Reference ID', value: referenceId),
                    const Divider(height: 24, color: LignColors.border),
                    _DetailRow(
                      label: 'Status',
                      value: 'SUCCESS',
                      valueColor: const Color(0xFF16A34A),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // Done button
              LignButton(
                text: 'Done',
                onPressed: () {
                  ref.read(qrisViewModelProvider.notifier).reset();
                  context.go('/home');
                },
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
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
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
        Flexible(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? LignColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
