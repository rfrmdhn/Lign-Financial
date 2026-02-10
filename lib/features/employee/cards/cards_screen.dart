import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';

class EmployeeCardsScreen extends StatelessWidget {
  const EmployeeCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cards'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardItem(
              context,
              cardName: 'Corporate Visa',
              last4: '4242',
              expiry: '12/28',
              status: 'Active',
              limit: 5000000,
              spent: 1500000,
            ),
            const SizedBox(height: 16),
            _buildCardItem(
              context,
              cardName: 'Travel Expense Card',
              last4: '8888',
              expiry: '10/27',
              status: 'Frozen',
              limit: 10000000,
              spent: 0,
              isFrozen: true,
            ),
            const SizedBox(height: 32),
            Text(
              'Recent Card Transactions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Reusing logic similar to Home's transaction list but specialized for cards
            _CardTransactionItem(
              merchant: 'Uber Technologies',
              date: 'Today, 2:30 PM',
              amount: -125000,
              cardLast4: '4242',
            ),
            _CardTransactionItem(
              merchant: 'AWS Web Services',
              date: 'Yesterday',
              amount: -850000,
              cardLast4: '4242',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(
    BuildContext context, {
    required String cardName,
    required String last4,
    required String expiry,
    required String status,
    required double limit,
    required double spent,
    bool isFrozen = false,
  }) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final remaining = limit - spent;
    final progress = limit > 0 ? (spent / limit) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isFrozen ? Colors.grey[800] : Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lign.',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isFrozen ? Colors.red.withValues(alpha: 0.2) : LignColors.electricLime.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: isFrozen ? Colors.redAccent : LignColors.electricLime,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            '**** **** **** $last4',
            style: GoogleFonts.sourceCodePro(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Card Holder', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(cardName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Expires', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  const SizedBox(height: 4),
                  Text(expiry, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          if (!isFrozen) ...[
            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Available Limit', style: TextStyle(color: Colors.white70)),
                Text(
                  currencyFormat.format(remaining),
                  style: const TextStyle(color: LignColors.electricLime, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 1.0 - progress, // progress shows remaining effectively in common UI, but here let's show usage
              backgroundColor: Colors.white12,
              color: LignColors.electricLime,
            ),
          ],
        ],
      ),
    );
  }
}

class _CardTransactionItem extends StatelessWidget {
  final String merchant;
  final String date;
  final double amount;
  final String cardLast4;

  const _CardTransactionItem({
    required this.merchant,
    required this.date,
    required this.amount,
    required this.cardLast4,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return LignCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: LignColors.secondaryBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.credit_card, size: 20, color: LignColors.textPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(merchant, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$date • Card ending $cardLast4', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(
            currencyFormat.format(amount),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
