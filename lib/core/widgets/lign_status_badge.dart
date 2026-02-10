import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/features/home/model/transaction.dart';

/// Shared status badge used across transaction lists.
/// Displays a colored pill indicating the transaction status.
class LignStatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const LignStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status) {
      TransactionStatus.completed => (
          LignColors.electricLime.withValues(alpha: 0.2),
          const Color(0xFF2E7D32),
          'Completed',
        ),
      TransactionStatus.pending => (
          LignColors.warning.withValues(alpha: 0.15),
          const Color(0xFFB8860B),
          'Pending',
        ),
      TransactionStatus.rejected => (
          LignColors.error.withValues(alpha: 0.12),
          LignColors.error,
          'Rejected',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
