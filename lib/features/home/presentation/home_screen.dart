import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/design_system/colors.dart';
import 'package:lign_financial/features/auth/data/auth_repository.dart';
import 'package:lign_financial/features/auth/presentation/auth_controller.dart';
import 'package:lign_financial/features/home/presentation/finance_home_content.dart';
import 'package:lign_financial/features/home/presentation/employee_home_content.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final userName = authState.user?.name ?? 'User';
    final isFinanceMode = authState.activeMode == AppMode.finance;

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _HomeHeader(
              userName: userName,
              isFinanceMode: isFinanceMode,
              onSwitchMode: () {
                ref.read(authControllerProvider.notifier).switchMode();
              },
            ),

            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isFinanceMode
                    ? const FinanceHomeContent(key: ValueKey('finance'))
                    : const EmployeeHomeContent(key: ValueKey('employee')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final String userName;
  final bool isFinanceMode;
  final VoidCallback onSwitchMode;

  const _HomeHeader({
    required this.userName,
    required this.isFinanceMode,
    required this.onSwitchMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LignColors.primaryBackground,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          // Greeting + Mode badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $userName',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: LignColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: isFinanceMode
                        ? LignColors.electricLime.withValues(alpha: 0.2)
                        : const Color(0xFF3B82F6).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isFinanceMode ? 'Finance Mode' : 'Karyawan Mode',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isFinanceMode
                          ? LignColors.textPrimary
                          : const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Switch mode button
          GestureDetector(
            onTap: onSwitchMode,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: LignColors.secondaryBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: LignColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swap_horiz, size: 16, color: LignColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(
                    'Switch',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: LignColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Notification bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: LignColors.secondaryBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LignColors.border),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: LignColors.textPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
