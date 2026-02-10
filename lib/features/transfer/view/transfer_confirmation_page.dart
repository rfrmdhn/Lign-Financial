import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/features/transfer/model/recipient_model.dart';
import 'package:lign_financial/features/transfer/viewmodel/transfer_confirmation_vm.dart';

/// Page 4: Confirmation page — shared by saved and new recipient flows.
class TransferConfirmationPage extends ConsumerStatefulWidget {
  final RecipientModel recipient;
  final bool isExistingRecipient;

  const TransferConfirmationPage({
    super.key,
    required this.recipient,
    required this.isExistingRecipient,
  });

  @override
  ConsumerState<TransferConfirmationPage> createState() =>
      _TransferConfirmationPageState();
}

class _TransferConfirmationPageState
    extends ConsumerState<TransferConfirmationPage> {
  final _amountController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transferConfirmationProvider.notifier).setRecipient(
            recipient: widget.recipient,
            isExisting: widget.isExistingRecipient,
          );
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferConfirmationProvider);
    final vm = ref.read(transferConfirmationProvider.notifier);

    ref.listen(transferConfirmationProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: Text(
          'Confirm Transfer',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient details (read-only)
            LignCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: LignColors.secondaryBackground,
                    child: Text(
                      widget.recipient.accountHolderName.isNotEmpty
                          ? widget.recipient.accountHolderName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: LignColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.recipient.accountHolderName,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: LignColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.recipient.bankName} • ${widget.recipient.accountNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: LignColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Amount input
            LignTextInput(
              label: 'Transfer Amount',
              controller: _amountController,
              hintText: '0',
              keyboardType: TextInputType.number,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Rp',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
              onChanged: (v) {
                final val = double.tryParse(v) ?? 0;
                vm.setAmount(val);
              },
            ),

            // Show formatted amount preview
            if (_amountController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  CurrencyFormatter.format(
                      double.tryParse(_amountController.text) ?? 0),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: LignColors.textSecondary,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // PIN input
            LignTextInput(
              label: 'Transaction PIN',
              controller: _pinController,
              hintText: '6-digit PIN',
              keyboardType: TextInputType.number,
              obscureText: true,
              onChanged: (v) => vm.setPin(v),
            ),

            const SizedBox(height: 36),

            // Transfer button
            LignButton(
              text: 'Transfer',
              isLoading: state.isLoading,
              onPressed: () async {
                final success = await vm.processTransfer();
                if (success && context.mounted) {
                  final r = widget.recipient;
                  context.pushReplacement('/transfer/success', extra: {
                    'bankName': r.bankName,
                    'accountNumber': r.accountNumber,
                    'accountHolderName': r.accountHolderName,
                    'amount': state.amount,
                    'isExisting': widget.isExistingRecipient,
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
