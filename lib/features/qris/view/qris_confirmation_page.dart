import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';
import 'package:lign_financial/features/qris/viewmodel/qris_viewmodel.dart';

/// Payment Confirmation Page — displays merchant info and amount input.
class QrisConfirmationPage extends ConsumerStatefulWidget {
  const QrisConfirmationPage({super.key});

  @override
  ConsumerState<QrisConfirmationPage> createState() =>
      _QrisConfirmationPageState();
}

class _QrisConfirmationPageState extends ConsumerState<QrisConfirmationPage> {
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
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onPayTap() async {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final vm = ref.read(qrisViewModelProvider.notifier);
    vm.setAmount(_amountController.text);

    final success = await vm.processPayment();
    if (success && mounted) {
      context.pushReplacement('/qris/success');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qrisViewModelProvider);
    final response = state.paymentResponse;

    // If somehow navigated without response data, pop back.
    if (response == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final merchantName = response.merchantName;
    final merchantLocation = response.merchantLocation ?? '';
    final walletName = response.walletName;
    final feeAmount = response.feeAmount;
    final currencyCode = response.currencyCode ?? 'IDR';

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: Text(
          'Payment Confirmation',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Merchant Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(20),
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
                  // Merchant avatar
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
                      radius: 28,
                      backgroundColor:
                          LignColors.electricLime.withValues(alpha: 0.15),
                      child: const Icon(
                        Icons.store,
                        color: LignColors.electricLime,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Merchant name
                  Text(
                    merchantName,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (merchantLocation.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      merchantLocation,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  const SizedBox(height: 14),

                  // Transaction details
                  _buildDetailRow(
                    Icons.account_balance_wallet_outlined,
                    'Wallet',
                    walletName,
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    Icons.swap_horiz,
                    'Direction',
                    'Payment to Merchant',
                  ),
                  if (feeAmount > 0) ...[
                    const SizedBox(height: 10),
                    _buildDetailRow(
                      Icons.receipt_long_outlined,
                      'Fee',
                      CurrencyFormatter.format(feeAmount),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    Icons.monetization_on_outlined,
                    'Currency',
                    currencyCode,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Amount input
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
                      'Payment Amount',
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
                    // Hidden text field
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

            // Fee info
            if (feeAmount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: LignCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: LignColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Admin fee of ${CurrencyFormatter.format(feeAmount)} will be applied.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: LignColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Error display
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  state.errorMessage!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: LignColors.error,
                  ),
                ),
              ),

            // Pay button
            LignButton(
              text: 'Pay',
              isLoading: state.isPaymentProcessing,
              onPressed: state.isPaymentProcessing ? null : _onPayTap,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: Colors.white54),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 10, color: Colors.white38),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
