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
                    barrierColor: Colors.black54,
                    builder: (_) => Dialog(
                      backgroundColor: LignColors.primaryBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      insetPadding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 36),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Success icon
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: LignColors.electricLime
                                    .withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                size: 44,
                                color: LignColors.electricLime,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Title
                            Text(
                              'Recipient Saved!',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: LignColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Message
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: LignColors.textSecondary,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(text: 'You can now quickly transfer to '),
                                  TextSpan(
                                    text: _aliasController.text,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: LignColors.textPrimary,
                                    ),
                                  ),
                                  const TextSpan(text: ' from your saved recipients.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () => context.go('/home'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: LignColors.textPrimary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Back to Home',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
