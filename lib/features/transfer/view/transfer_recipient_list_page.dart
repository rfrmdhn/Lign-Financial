import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/features/transfer/model/recipient_model.dart';
import 'package:lign_financial/features/transfer/viewmodel/transfer_recipient_list_vm.dart';

/// Page 1: Saved recipients list with "Transfer to new recipient" button.
class TransferRecipientListPage extends ConsumerWidget {
  const TransferRecipientListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transferRecipientListProvider);

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: Text(
          'Transfer',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // New recipient button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: InkWell(
                    onTap: () => context.push('/transfer/new'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: LignColors.primaryBackground,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: LignColors.electricLime.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: LignColors.electricLime
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_add_outlined,
                              color: LignColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transfer to New Recipient',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: LignColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Enter bank and account number',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: LignColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: LignColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ),

                // Section title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Saved Recipients',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LignColors.textSecondary,
                      ),
                    ),
                  ),
                ),

                // Recipient list
                Expanded(
                  child: state.recipients.isEmpty
                      ? Center(
                          child: Text(
                            'No saved recipients yet',
                            style: GoogleFonts.inter(
                                color: LignColors.textSecondary),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: state.recipients.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, i) => _RecipientCard(
                            recipient: state.recipients[i],
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class _RecipientCard extends StatelessWidget {
  final RecipientModel recipient;
  const _RecipientCard({required this.recipient});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/transfer/confirm', extra: {
        'recipient': recipient,
        'isExisting': true,
      }),
      borderRadius: BorderRadius.circular(14),
      child: LignCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: LignColors.secondaryBackground,
              child: Text(
                recipient.alias[0].toUpperCase(),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: LignColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipient.alias,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: LignColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${recipient.bankName} • ${recipient.accountNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: LignColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: LignColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
