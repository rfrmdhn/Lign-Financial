import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/features/transfer/model/recipient_model.dart';
import 'package:lign_financial/features/transfer/viewmodel/transfer_new_recipient_vm.dart';

/// Page 2: Form for entering a new recipient's bank and account number.
class TransferNewRecipientFormPage extends ConsumerStatefulWidget {
  const TransferNewRecipientFormPage({super.key});

  @override
  ConsumerState<TransferNewRecipientFormPage> createState() =>
      _TransferNewRecipientFormPageState();
}

class _TransferNewRecipientFormPageState
    extends ConsumerState<TransferNewRecipientFormPage> {
  final _accountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferNewRecipientProvider);
    final vm = ref.read(transferNewRecipientProvider.notifier);

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: Text(
          'New Recipient',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank selector
            Text(
              'Bank',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: LignColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final result = await context.push<dynamic>('/transfer/banks');
                if (result != null) {
                  vm.selectBank(result);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: LignColors.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: LignColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.selectedBank?.name ?? 'Select bank',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: state.selectedBank != null
                              ? LignColors.textPrimary
                              : LignColors.textSecondary,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: LignColors.textSecondary, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Account number input
            LignTextInput(
              label: 'Account Number',
              controller: _accountController,
              hintText: 'Enter account number',
              keyboardType: TextInputType.number,
              onChanged: (v) => vm.setAccountNumber(v),
            ),

            if (state.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                style: GoogleFonts.inter(
                    color: LignColors.error, fontSize: 12),
              ),
            ],

            const Spacer(),

            // Continue button
            LignButton(
              text: state.isLookingUp ? 'Looking up…' : 'Continue',
              isLoading: state.isLookingUp,
              onPressed: state.canContinue
                  ? () async {
                      final name = await vm.lookupAccount();
                      if (name != null && context.mounted) {
                        final recipient = RecipientModel(
                          id: '',
                          alias: '',
                          bankName: state.selectedBank!.name,
                          bankCode: state.selectedBank!.code,
                          accountNumber: state.accountNumber,
                          accountHolderName: name,
                        );
                        context.push('/transfer/confirm', extra: {
                          'recipient': recipient,
                          'isExisting': false,
                        });
                      }
                    }
                  : null,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
