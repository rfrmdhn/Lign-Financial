import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/constants/app_strings.dart';
import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/features/transfer/model/transfer_state.dart';
import 'package:lign_financial/features/transfer/viewmodel/transfer_viewmodel.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferViewModelProvider);
    final viewModel = ref.read(transferViewModelProvider.notifier);

    // Show error snackbar if needed
    ref.listen(transferViewModelProvider, (prev, next) {
      if (next.errorMessage != null && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: state.currentStep == TransferStep.success 
          ? null 
          : AppBar(
        title: Text(_getTitle(state.currentStep)),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (state.currentStep == TransferStep.menu) {
              context.pop();
            } else {
              viewModel.goBack();
            }
          },
        ),
      ),
      body: _buildBody(state, viewModel),
    );
  }

  String _getTitle(TransferStep step) {
    switch (step) {
      case TransferStep.menu: return AppStrings.transfer;
      case TransferStep.input: return AppStrings.transferInputDetails;
      case TransferStep.review: return AppStrings.transferReview;
      default: return '';
    }
  }

  Widget _buildBody(TransferState state, TransferViewModel viewModel) {
    switch (state.currentStep) {
      case TransferStep.menu: return _buildMenuStep(viewModel);
      case TransferStep.input: return _buildInputStep(state, viewModel);
      case TransferStep.review: return _buildReviewStep(state, viewModel);
      case TransferStep.success: return _buildSuccessStep(viewModel);
    }
  }

  Widget _buildMenuStep(TransferViewModel viewModel) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Select Transfer Type',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: LignColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        _TransferMenuCard(
          icon: Icons.account_balance_outlined,
          title: 'Internal Transfer',
          subtitle: 'Transfer to other Lign accounts',
          onTap: () => viewModel.selectType('Internal Transfer'),
        ),
        const SizedBox(height: 12),
        _TransferMenuCard(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Bank Transfer',
          subtitle: 'Transfer to other banks',
          onTap: () => viewModel.selectType('Bank Transfer'),
        ),
      ],
    );
  }

  Widget _buildInputStep(TransferState state, TransferViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: LignColors.primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: LignColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: LignColors.electricLime),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.selectedType, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text('Remaining Limit: Rp 10.000.000', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          LignTextInput(
            label: 'Destination Account',
            controller: _accountController,
            hintText: 'Enter account number',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          LignTextInput(
            label: 'Amount',
            controller: _amountController,
            hintText: '0',
            keyboardType: TextInputType.number,
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Rp', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          
          LignTextInput(
            label: 'Notes (Optional)',
            controller: _notesController,
            hintText: 'Add a note',
          ),
          
          const SizedBox(height: 32),
          LignButton(
            text: 'Continue',
            onPressed: () {
              if (_amountController.text.isNotEmpty && _accountController.text.isNotEmpty) {
                 viewModel.goToReview();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(TransferState state, TransferViewModel viewModel) {
     final amount = double.tryParse(_amountController.text) ?? 0;
     
     return Padding(
       padding: const EdgeInsets.all(24),
       child: Column(
         children: [
           Container(
             padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
               color: LignColors.primaryBackground,
               borderRadius: BorderRadius.circular(16),
               border: Border.all(color: LignColors.border),
             ),
             child: Column(
               children: [
                 Text('Total Transfer', style: GoogleFonts.inter(color: LignColors.textSecondary)),
                 const SizedBox(height: 8),
                 Text(
                   CurrencyFormatter.format(amount),
                   style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold),
                 ),
                 const Divider(height: 32),
                 _ReviewRow(label: 'Type', value: state.selectedType),
                 const SizedBox(height: 12),
                 _ReviewRow(label: 'Destination', value: _accountController.text),
                 const SizedBox(height: 12),
                 _ReviewRow(label: 'Notes', value: _notesController.text.isEmpty ? '-' : _notesController.text),
               ],
             ),
           ),
           const Spacer(),
           LignButton(
             text: 'Confirm Transfer',
             isLoading: state.isLoading,
             onPressed: () {
               viewModel.processTransfer(
                 amount: _amountController.text,
                 destination: _accountController.text,
                 notes: _notesController.text,
               );
             },
           ),
         ],
       ),
     );
  }

  Widget _buildSuccessStep(TransferViewModel viewModel) {
    final amount = double.tryParse(_amountController.text) ?? 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: LignColors.electricLime, size: 80),
            const SizedBox(height: 24),
            Text(
              'Transfer Successful',
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(amount),
              style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            LignButton(
              text: 'Done',
              onPressed: () {
                viewModel.reset();
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TransferMenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TransferMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LignColors.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LignColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: LignColors.secondaryBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: LignColors.textPrimary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: LignColors.textSecondary)),
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

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: LignColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
