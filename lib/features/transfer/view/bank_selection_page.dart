import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/features/transfer/model/bank_model.dart';
import 'package:lign_financial/features/transfer/viewmodel/transfer_new_recipient_vm.dart';

/// Page 3: Bank selection list with search.
class BankSelectionPage extends ConsumerStatefulWidget {
  const BankSelectionPage({super.key});

  @override
  ConsumerState<BankSelectionPage> createState() => _BankSelectionPageState();
}

class _BankSelectionPageState extends ConsumerState<BankSelectionPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferNewRecipientProvider);
    final filtered = state.banks
        .where(
            (b) => b.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: Text(
          'Select Bank',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(20),
            child: LignTextInput(
              label: '',
              hintText: 'Search bank name',
              onChanged: (v) => setState(() => _search = v),
              prefixIcon: const Icon(Icons.search,
                  color: LignColors.textSecondary, size: 20),
            ),
          ),

          // Bank list
          Expanded(
            child: state.isLoadingBanks
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: LignColors.border,
                    ),
                    itemBuilder: (_, i) =>
                        _BankTile(bank: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BankTile extends StatelessWidget {
  final BankModel bank;
  const _BankTile({required this.bank});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: LignColors.primaryBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: LignColors.border),
        ),
        child: Center(
          child: Text(
            bank.code.substring(0, bank.code.length.clamp(0, 3)),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
            ),
          ),
        ),
      ),
      title: Text(
        bank.name,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: LignColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right,
          color: LignColors.textSecondary, size: 20),
      onTap: () => context.pop(bank),
    );
  }
}
