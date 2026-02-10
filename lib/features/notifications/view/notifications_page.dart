import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/notifications/viewmodel/notifications_viewmodel.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationsViewModelProvider);

    return Scaffold(
      backgroundColor: LignColors.secondaryBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: LignColors.primaryBackground,
        foregroundColor: LignColors.textPrimary,
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text(state.errorMessage!))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = state.notifications[index];
                    return _NotificationItem(
                      title: item.title,
                      message: item.message,
                      time: item.time,
                      isRead: item.isRead,
                    );
                  },
                ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;

  const _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead 
             ? LignColors.secondaryBackground 
             : LignColors.electricLime.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? LignColors.border : LignColors.electricLime,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: LignColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: LignColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
