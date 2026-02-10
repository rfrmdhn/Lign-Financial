import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/core/utils/currency_formatter.dart';
import 'package:lign_financial/features/transfer/data/transfer_repository.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

enum TransferStep { menu, input, review, success }

class _TransferScreenState extends ConsumerState<TransferScreen> {
  TransferStep _currentStep = TransferStep.menu;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedType = '';

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _processTransfer() async {
    setState(() => _isLoading = true);
    
    try {
      await ref.read(transferRepositoryProvider).performTransfer(
        amount: _amountController.text,
        destination: _accountController.text,
        notes: _notesController.text,
      );
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = TransferStep.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Transfer failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: _currentStep == TransferStep.success 
          ? null 
          : AppBar(
        title: Text(_getTitle()),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == TransferStep.input) {
              setState(() => _currentStep = TransferStep.menu);
            } else if (_currentStep == TransferStep.review) {
              setState(() => _currentStep = TransferStep.input);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  String _getTitle() {
    switch (_currentStep) {
      case TransferStep.menu: return 'Transfer';
      case TransferStep.input: return 'Input Details';
      case TransferStep.review: return 'Review Transfer';
      default: return '';
    }
  }

  Widget _buildBody() {
    switch (_currentStep) {
      case TransferStep.menu: return _buildMenuStep();
      case TransferStep.input: return _buildInputStep();
      case TransferStep.review: return _buildReviewStep();
      case TransferStep.success: return _buildSuccessStep();
    }
  }

  Widget _buildMenuStep() {
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
          onTap: () {
            setState(() {
              _selectedType = 'Internal Transfer';
              _currentStep = TransferStep.input;
            });
          },
        ),
        const SizedBox(height: 12),
        _TransferMenuCard(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Bank Transfer',
          subtitle: 'Transfer to other banks',
          onTap: () {
            setState(() {
              _selectedType = 'Bank Transfer';
              _currentStep = TransferStep.input;
            });
          },
        ),
      ],
    );
  }

  Widget _buildInputStep() {
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
                    Text(_selectedType, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                 setState(() => _currentStep = TransferStep.review);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
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
                 _ReviewRow(label: 'Type', value: _selectedType),
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
             isLoading: _isLoading,
             onPressed: _processTransfer,
           ),
         ],
       ),
     );
  }

  Widget _buildSuccessStep() {
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
              onPressed: () => context.go('/home'),
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
