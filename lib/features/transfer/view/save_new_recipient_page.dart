import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/features/transfer/viewmodel/transfer_success_vm.dart';

/// Page 6: Save new recipient with alias input.
class SaveNewRecipientPage extends ConsumerStatefulWidget {
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountHolderName;

  const SaveNewRecipientPage({
    super.key,
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountHolderName,
  });

  @override
  ConsumerState<SaveNewRecipientPage> createState() =>
      _SaveNewRecipientPageState();
}

class _SaveNewRecipientPageState extends ConsumerState<SaveNewRecipientPage> {
  final _aliasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(transferSuccessProvider.notifier).setResult(
            bankName: widget.bankName,
            accountNumber: widget.accountNumber,
            accountHolderName: widget.accountHolderName,
            amount: 0,
            isExistingRecipient: false,
          );
    });
  }

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferSuccessProvider);

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: Text(
          'Save Recipient',
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
            // Read-only info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: LignColors.primaryBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: LignColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.accountHolderName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: LignColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.bankName} • ${widget.accountNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: LignColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Alias input
            LignTextInput(
              label: 'Recipient Alias',
              controller: _aliasController,
              hintText: 'e.g. Supplier Jaya',
            ),

            const Spacer(),

            LignButton(
              text: 'Save',
              isLoading: state.isSaving,
              onPressed: () async {
                if (_aliasController.text.isEmpty) return;

                final vm = ref.read(transferSuccessProvider.notifier);
                final success =
                    await vm.saveRecipient(_aliasController.text);

                if (success && context.mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: LignColors.electricLime),
                          const SizedBox(width: 8),
                          Text(
                            'Saved!',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      content: Text(
                        'Recipient "${_aliasController.text}" has been saved.',
                        style: GoogleFonts.inter(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => context.go('/home'),
                          child: Text(
                            'Back to Home',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: LignColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
