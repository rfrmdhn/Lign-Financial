import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class NotificationsState {
  final bool isLoading;
  final List<NotificationItem> notifications;
  final String? errorMessage;

  const NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.errorMessage,
  });

  NotificationsState copyWith({
    bool? isLoading,
    List<NotificationItem>? notifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage,
    );
  }
}

class NotificationsViewModel extends Notifier<NotificationsState> {
  @override
  NotificationsState build() {
    loadNotifications();
    return const NotificationsState(isLoading: true);
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 600));

    state = state.copyWith(
      isLoading: false,
      notifications: [
        const NotificationItem(
          id: '1',
          title: 'Payment Successful',
          message: 'Your payment to Starbucks Indonesia was successful.',
          time: '2 mins ago',
          isRead: false,
        ),
        const NotificationItem(
          id: '2',
          title: 'Transfer Received',
          message: 'You received Rp 500.000 from Ahmad.',
          time: '1 hour ago',
          isRead: true,
        ),
        const NotificationItem(
          id: '3',
          title: 'Budget Alert',
          message: 'You have used 80% of your transportation budget.',
          time: 'Yesterday',
          isRead: true,
        ),
      ],
    );
  }
}

final notificationsViewModelProvider = NotifierProvider<NotificationsViewModel, NotificationsState>(() {
  return NotificationsViewModel();
});
