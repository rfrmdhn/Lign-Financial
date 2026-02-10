import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';



import 'package:lign_financial/features/profile/viewmodel/profile_viewmodel.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    final viewModel = ref.read(profileViewModelProvider.notifier);
    
    final user = state.user;
    final isFinance = state.isFinanceMode;

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: state.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: LignColors.electricLime.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : 'U',
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: LignColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  user?.name ?? 'User',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: LignColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // Email
                Text(
                  user?.email ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: LignColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Active Mode Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: isFinance
                        ? LignColors.electricLime.withValues(alpha: 0.2)
                        : const Color(0xFF3B82F6).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isFinance ? 'Finance Mode' : 'Employee Mode',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isFinance
                          ? LignColors.textPrimary
                          : const Color(0xFF3B82F6),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // User Info Section
                _ProfileSection(
                  title: 'User Information',
                  items: [
                    _ProfileItem(
                      icon: Icons.person_outline,
                      label: 'Full Name',
                      value: user?.name ?? '-',
                    ),
                    _ProfileItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? '-',
                    ),
                    _ProfileItem(
                      icon: Icons.business_outlined,
                      label: 'Company',
                      value: 'PT Lign Teknologi',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Role Info Section
                _ProfileSection(
                  title: 'Role & Access',
                  items: [
                    _ProfileItem(
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Role',
                      value: 'Finance & Employee',
                    ),
                    _ProfileItem(
                      icon: Icons.toggle_on_outlined,
                      label: 'Active Mode',
                      value: isFinance ? 'Finance' : 'Employee',
                    ),
                    _ProfileItem(
                      icon: Icons.verified_user_outlined,
                      label: 'Status',
                      value: 'Active',
                      valueColor: const Color(0xFF2E7D32),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Settings Section
                _ProfileSection(
                  title: 'Settings',
                  items: const [
                    _ProfileItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      value: 'Enabled',
                    ),
                    _ProfileItem(
                      icon: Icons.security_outlined,
                      label: 'Security',
                      value: 'Manage',
                      isAction: true,
                    ),
                    _ProfileItem(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      value: '',
                      isAction: true,
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Logout
                LignButton(
                  text: 'Logout',
                  type: LignButtonType.secondary,
                  icon: Icons.logout,
                  onPressed: () async {
                    await viewModel.logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
                const SizedBox(height: 16),

                Text(
                  'Lign Financial v1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: LignColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: LignColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: LignColors.primaryBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LignColors.border),
          ),
          child: Column(
            children: List.generate(items.length, (index) {
              return Column(
                children: [
                  items[index],
                  if (index < items.length - 1)
                    const Divider(height: 1, indent: 52, color: LignColors.border),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isAction;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: LignColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: LignColors.textPrimary,
              ),
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ?? LignColors.textSecondary,
              ),
            ),
          if (isAction)
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.chevron_right, size: 18, color: LignColors.textSecondary),
            ),
        ],
      ),
    );
  }
}
