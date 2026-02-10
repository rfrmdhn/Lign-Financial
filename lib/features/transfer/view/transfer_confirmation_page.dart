import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';

import 'package:lign_financial/core/widgets/lign_button.dart';


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
  final _amountFocusNode = FocusNode();

  /// Formats raw digits into dot-separated groups, e.g. "1500000" → "1.500.000".
  String get _formattedAmount {
    final raw = _amountController.text;
    if (raw.isEmpty) return '0';
    final number = int.tryParse(raw);
    if (number == null) return raw;
    final chars = number.toString().split('');
    final buffer = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i > 0 && (chars.length - i) % 3 == 0) buffer.write('.');
      buffer.write(chars[i]);
    }
    return buffer.toString();
  }

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
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onTransferTap() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final vm = ref.read(transferConfirmationProvider.notifier);
    vm.setAmount(amount);

    // Show the PIN dial pad
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => _PinDialPad(
        onComplete: (pin) async {
          Navigator.of(context).pop(); // close bottom sheet
          vm.setPin(pin);
          final success = await vm.processTransfer();
          if (success && mounted) {
            final r = widget.recipient;
            final state = ref.read(transferConfirmationProvider);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferConfirmationProvider);

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipient details (premium card)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar with accent ring
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: LignColors.electricLime.withValues(alpha: 0.6),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          LignColors.electricLime.withValues(alpha: 0.15),
                      child: Text(
                        widget.recipient.accountHolderName.isNotEmpty
                            ? widget.recipient.accountHolderName[0]
                                .toUpperCase()
                            : '?',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: LignColors.electricLime,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    widget.recipient.accountHolderName,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  const SizedBox(height: 14),

                  // Bank row
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.account_balance_outlined,
                            size: 16, color: Colors.white54),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white38,
                            ),
                          ),
                          Text(
                            widget.recipient.bankName,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Account number row
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.credit_card_outlined,
                            size: 16, color: Colors.white54),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Number',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: Colors.white38,
                            ),
                          ),
                          Text(
                            widget.recipient.accountNumber,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Hero amount display
            GestureDetector(
              onTap: () => _amountFocusNode.requestFocus(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: LignColors.primaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _amountFocusNode.hasFocus
                        ? LignColors.electricLime
                        : LignColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Transfer Amount',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: LignColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Rp',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: LignColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formattedAmount,
                          style: GoogleFonts.outfit(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: _amountController.text.isEmpty
                                ? LignColors.textDisabled
                                : LignColors.textPrimary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    // Hidden text field for keyboard input
                    SizedBox(
                      height: 0,
                      child: TextField(
                        controller: _amountController,
                        focusNode: _amountFocusNode,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          color: Colors.transparent,
                          height: 0.01,
                          fontSize: 1,
                        ),
                        cursorColor: Colors.transparent,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    if (_amountController.text.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Tap to enter amount',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: LignColors.textDisabled,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Transfer button → opens PIN dial pad
            LignButton(
              text: 'Transfer',
              isLoading: state.isLoading,
              onPressed: _onTransferTap,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── PIN Dial Pad Bottom Sheet ───────────────────────────────────────────────

class _PinDialPad extends StatefulWidget {
  final void Function(String pin) onComplete;

  const _PinDialPad({required this.onComplete});

  @override
  State<_PinDialPad> createState() => _PinDialPadState();
}

class _PinDialPadState extends State<_PinDialPad> {
  String _pin = '';
  static const int _pinLength = 6;

  void _onDigit(String digit) {
    if (_pin.length >= _pinLength) return;
    setState(() => _pin += digit);

    if (_pin.length == _pinLength) {
      // Small delay so user sees the last dot fill
      Future.delayed(const Duration(milliseconds: 250), () {
        widget.onComplete(_pin);
      });
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: LignColors.primaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: LignColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Enter Transaction PIN',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your 6-digit PIN to confirm',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: LignColors.textSecondary,
            ),
          ),

          const SizedBox(height: 28),

          // PIN dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pinLength, (i) {
              final filled = i < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? LignColors.textPrimary : Colors.transparent,
                  border: Border.all(
                    color: filled ? LignColors.textPrimary : LignColors.border,
                    width: 2,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 36),

          // Number grid: 1-9, then [empty, 0, backspace]
          _buildNumberGrid(),
        ],
      ),
    );
  }

  Widget _buildNumberGrid() {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 12),
        // Row 2: 4, 5, 6
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 12),
        // Row 3: 7, 8, 9
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 12),
        // Row 4: empty, 0, backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Empty spacer
            SizedBox(
              width: 80,
              height: 72,
              child: Container(),
            ),
            // 0
            _DialButton(
              label: '0',
              onTap: () => _onDigit('0'),
            ),
            // Backspace
            SizedBox(
              width: 80,
              height: 72,
              child: InkWell(
                onTap: _onBackspace,
                borderRadius: BorderRadius.circular(16),
                child: const Center(
                  child: Icon(
                    Icons.backspace_outlined,
                    size: 26,
                    color: LignColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits
          .map((d) => _DialButton(
                label: d,
                onTap: () => _onDigit(d),
              ))
          .toList(),
    );
  }
}

class _DialButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DialButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 72,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: LignColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
