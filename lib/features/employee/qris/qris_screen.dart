import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';

class EmployeeQRISScreen extends StatefulWidget {
  const EmployeeQRISScreen({super.key});

  @override
  State<EmployeeQRISScreen> createState() => _EmployeeQRISScreenState();
}

enum QRISStep { scan, input, review, success }

class _EmployeeQRISScreenState extends State<EmployeeQRISScreen> {
  QRISStep _currentStep = QRISStep.scan;
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  // Mock Data
  final String _merchantName = "Starbucks Indonesia";
  final String _merchantCategory = "Food & Beverage";
  final double _remainingLimit = 3500000;

  @override
  void initState() {
    super.initState();
    // Simulate scanning delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _currentStep = QRISStep.input;
        });
      }
    });
  }

  void _processPayment() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = QRISStep.success;
        });
      }
    });
  }

  void _validateAmount(String value) {
    // Basic validation logic
    final amount = double.tryParse(value) ?? 0;
    setState(() {
      if (amount > _remainingLimit) {
        _errorMessage = "Amount exceeds remaining limit (Rp ${NumberFormat.decimalPattern('id').format(_remainingLimit)})";
      } else {
        _errorMessage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRIS Payment'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_currentStep) {
      case QRISStep.scan:
        return _buildScanStep();
      case QRISStep.input:
        return _buildInputStep();
      case QRISStep.review:
        return _buildReviewStep();
      case QRISStep.success:
        return _buildSuccessStep();
    }
  }

  Widget _buildScanStep() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: const Center(
            child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 80),
          ),
        ),
        const Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Text(
            'Scanning QR Code...',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildInputStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMerchantInfo(),
          const SizedBox(height: 32),
          LignTextInput(
            label: 'Amount',
            controller: _amountController,
            keyboardType: TextInputType.number,
            hintText: '0',
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Rp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            errorText: _errorMessage,
            onChanged: _validateAmount,
          ),
          const Spacer(),
          LignButton(
            text: 'Continue',
            onPressed: _errorMessage == null && _amountController.text.isNotEmpty
                ? () {
                    setState(() {
                      _currentStep = QRISStep.review;
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review Payment', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          _buildMerchantInfo(),
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
                _buildReviewRow('Amount', currencyFormat.format(amount)),
                const SizedBox(height: 12),
                _buildReviewRow('Admin Fee', 'Rp 0'),
                const Divider(height: 24),
                _buildReviewRow(
                  'Total',
                  currencyFormat.format(amount),
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
               color: LignColors.electricLime.withValues(alpha: 0.1),
               borderRadius: BorderRadius.circular(8),
               border: Border.all(color: LignColors.electricLime),
             ),
             child: const Row(
               children: [
                 Icon(Icons.check_circle, color: Colors.green),
                 SizedBox(width: 12),
                 Expanded(child: Text('Policy Check Passed: Within limit and allowed category.', style: TextStyle(fontSize: 12))),
               ],
             ),
          ),
          const Spacer(),
          LignButton(
            text: 'Confirm & Pay',
            isLoading: _isLoading,
            onPressed: _processPayment,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: LignColors.electricLime, size: 80),
            const SizedBox(height: 24),
            Text('Payment Successful', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(currencyFormat.format(amount), style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
             Text('To $_merchantName', style: const TextStyle(color: LignColors.textSecondary)),
            const SizedBox(height: 48),
            LignButton(
              text: 'Done',
              onPressed: () {
                context.go('/employee/home');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantInfo() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.store, color: Colors.grey),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_merchantName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(_merchantCategory, style: const TextStyle(color: LignColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: LignColors.textSecondary)),
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
