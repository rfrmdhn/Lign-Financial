import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/features/qris/viewmodel/qris_viewmodel.dart';

class QRISScreen extends ConsumerStatefulWidget {
  const QRISScreen({super.key});

  @override
  ConsumerState<QRISScreen> createState() => _QRISScreenState();
}

class _QRISScreenState extends ConsumerState<QRISScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qrisViewModelProvider);
    final viewModel = ref.read(qrisViewModelProvider.notifier);

    return Scaffold(
      appBar: state.step != QRISStep.scan
          ? AppBar(
              title: const Text('QRIS Payment'),
              backgroundColor: LignColors.primaryBackground,
              foregroundColor: LignColors.textPrimary,
              elevation: 0,
              leading: state.step == QRISStep.success
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        if (state.step == QRISStep.review) {
                          viewModel.backToInput();
                        } else {
                          context.go('/home');
                        }
                      },
                    ),
            )
          : null,
      body: _buildBody(state, viewModel),
    );
  }

  Widget _buildBody(QRISState state, QRISViewModel viewModel) {
    switch (state.step) {
      case QRISStep.scan:
        return _buildScanStep();
      case QRISStep.input:
        return _buildInputStep(state, viewModel);
      case QRISStep.review:
        return _buildReviewStep(state, viewModel);
      case QRISStep.success:
        return _buildSuccessStep(state);
    }
  }

  Widget _buildScanStep() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: LignColors.electricLime, width: 3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.qr_code_scanner,
                    color: Colors.white, size: 80),
              ),
              const SizedBox(height: 32),
              Text(
                'Scanning QR Code...',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Point your camera at a QRIS code',
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputStep(QRISState state, QRISViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMerchantInfo(state),
          const SizedBox(height: 12),

          // Remaining limit info
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: LignColors.electricLime.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    size: 16, color: LignColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  'Remaining limit: ${CurrencyFormatter.format(state.remainingLimit)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: LignColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          LignTextInput(
            label: 'Amount',
            controller: _amountController,
            keyboardType: TextInputType.number,
            hintText: '0',
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Rp',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            errorText: state.errorMessage,
            onChanged: (val) => viewModel.setAmount(val),
          ),
          const Spacer(),
          LignButton(
            text: 'Continue',
            onPressed:
                state.errorMessage == null && state.amount > 0
                    ? viewModel.proceedToReview
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(QRISState state, QRISViewModel viewModel) {
    final formattedAmount = CurrencyFormatter.format(state.amount);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Payment',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          _buildMerchantInfo(state),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: LignColors.secondaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: LignColors.border),
            ),
            child: Column(
              children: [
                _buildReviewRow('Amount', formattedAmount),
                const SizedBox(height: 12),
                _buildReviewRow('Admin Fee', 'Rp 0'),
                const Divider(height: 24),
                _buildReviewRow(
                  'Total',
                  formattedAmount,
                  isBold: true,
                  color: LignColors.textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: state.needsApproval
                  ? LignColors.warning.withValues(alpha: 0.1)
                  : LignColors.electricLime.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: state.needsApproval
                    ? LignColors.warning
                    : LignColors.electricLime,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  state.needsApproval ? Icons.schedule : Icons.check_circle,
                  color: state.needsApproval ? LignColors.warning : Colors.green,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.needsApproval
                        ? 'Requires approval: Amount > Rp 1.000.000. Status will be Pending.'
                        : 'Policy Check Passed: Within limit and allowed category.',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          LignButton(
            text: state.needsApproval ? 'Submit for Approval' : 'Confirm & Pay',
            isLoading: state.isLoading,
            onPressed: viewModel.processPayment,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep(QRISState state) {
    final formattedAmount = CurrencyFormatter.format(state.amount);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.needsApproval ? Icons.schedule : Icons.check_circle,
              color: state.needsApproval
                  ? LignColors.warning
                  : LignColors.electricLime,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              state.needsApproval ? 'Payment Submitted' : 'Payment Successful',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(formattedAmount,
                style: GoogleFonts.inter(
                    fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('To ${state.merchantName}',
                style: const TextStyle(color: LignColors.textSecondary)),
            if (state.needsApproval) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: LignColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Status: Pending Approval',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB8860B),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 48),
            LignButton(
              text: 'Done',
              onPressed: () {
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantInfo(QRISState state) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: LignColors.secondaryBackground,
            shape: BoxShape.circle,
            border: Border.all(color: LignColors.border),
          ),
          child: const Icon(Icons.store, color: LignColors.textSecondary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.merchantName,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            Text(state.merchantCategory,
                style: const TextStyle(color: LignColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: LignColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? LignColors.textPrimary,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
