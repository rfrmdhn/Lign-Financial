import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_card.dart';

class FinanceApprovalsScreen extends StatefulWidget {
  const FinanceApprovalsScreen({super.key});

  @override
  State<FinanceApprovalsScreen> createState() => _FinanceApprovalsScreenState();
}

class _FinanceApprovalsScreenState extends State<FinanceApprovalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approvals'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: LignColors.textPrimary,
          indicatorColor: LignColors.electricLime,
          tabs: const [
            Tab(text: 'Pending (12)'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
           _PendingApprovalsList(),
           Center(child: Text('History Data Placeholder')),
        ],
      ),
    );
  }
}

class _PendingApprovalsList extends StatelessWidget {
  const _PendingApprovalsList();

  @override
  Widget build(BuildContext context) {
     return ListView(
       padding: const EdgeInsets.all(16),
       children: const [
         _ApprovalItem(
           employeeName: 'Budi Santoso',
           description: 'Flight ticket to Singapore',
           amount: 2500000,
           date: 'Today',
           category: 'Travel',
         ),
         SizedBox(height: 16),
         _ApprovalItem(
           employeeName: 'Siti Aminah',
           description: 'New Monitor',
           amount: 3500000,
           date: 'Yesterday',
           category: 'Equipment',
         ),
       ],
     );
  }
}

class _ApprovalItem extends StatelessWidget {
  final String employeeName;
  final String description;
  final double amount;
  final String date;
  final String category;

  const _ApprovalItem({
    required this.employeeName,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return LignCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 12, backgroundColor: LignColors.border, child: Icon(Icons.person, size: 16, color: Colors.white)),
                  const SizedBox(width: 8),
                  Text(employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Text(date, style: const TextStyle(fontSize: 12, color: LignColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(color: LignColors.textSecondary, fontSize: 12)),
              Text(currencyFormat.format(amount), style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LignButton(text: 'Reject', type: LignButtonType.secondary, onPressed: () {}, isFullWidth: true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LignButton(text: 'Approve', onPressed: () {}, isFullWidth: true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
