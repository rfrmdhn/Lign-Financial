import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lign_financial/features/login/view/login_page.dart';
import 'package:lign_financial/features/home/view/home_page.dart';
import 'package:lign_financial/features/account/view/account_page.dart';
import 'package:lign_financial/features/qris/view/qris_page.dart';
import 'package:lign_financial/features/qris/view/qris_confirmation_page.dart';
import 'package:lign_financial/features/qris/view/qris_success_page.dart';
import 'package:lign_financial/features/activity/view/activity_page.dart';
import 'package:lign_financial/features/profile/view/profile_page.dart';
import 'package:lign_financial/features/shared/view/scaffold_with_navigation.dart';
import 'package:lign_financial/features/transfer/view/transfer_recipient_list_page.dart';
import 'package:lign_financial/features/transfer/view/transfer_new_recipient_form_page.dart';
import 'package:lign_financial/features/transfer/view/bank_selection_page.dart';
import 'package:lign_financial/features/transfer/view/transfer_confirmation_page.dart';
import 'package:lign_financial/features/transfer/view/transfer_success_page.dart';
import 'package:lign_financial/features/transfer/view/save_new_recipient_page.dart';
import 'package:lign_financial/features/transfer/model/recipient_model.dart';
import 'package:lign_financial/features/budget/view/budget_page.dart';
import 'package:lign_financial/features/notifications/view/notifications_page.dart';
import 'package:lign_financial/features/shared/view/splash_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {


  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      // Transfer — Recipient-First Flow
      GoRoute(
        path: '/transfer',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TransferRecipientListPage(),
      ),
      GoRoute(
        path: '/transfer/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TransferNewRecipientFormPage(),
      ),
      GoRoute(
        path: '/transfer/banks',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BankSelectionPage(),
      ),
      GoRoute(
        path: '/transfer/confirm',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TransferConfirmationPage(
            recipient: extra['recipient'] as RecipientModel,
            isExistingRecipient: extra['isExisting'] as bool,
          );
        },
      ),
      GoRoute(
        path: '/transfer/success',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return TransferSuccessPage(
            bankName: extra['bankName'] as String,
            accountNumber: extra['accountNumber'] as String,
            accountHolderName: extra['accountHolderName'] as String,
            amount: extra['amount'] as double,
            isExistingRecipient: extra['isExisting'] as bool,
          );
        },
      ),
      GoRoute(
        path: '/transfer/save-recipient',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SaveNewRecipientPage(
            bankName: extra['bankName'] as String,
            bankCode: extra['bankCode'] as String,
            accountNumber: extra['accountNumber'] as String,
            accountHolderName: extra['accountHolderName'] as String,
          );
        },
      ),
      GoRoute(
        path: '/budget',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BudgetScreen(),
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // QRIS — Payment Flow
      GoRoute(
        path: '/qris/confirm',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const QrisConfirmationPage(),
      ),
      GoRoute(
        path: '/qris/success',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const QrisSuccessPage(),
      ),

      // Unified Shell — single bottom navigation for all modes
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          // 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // 1: Account
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),

          // 2: QRIS (center tab)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/qris',
                builder: (context, state) => const QRISScreen(),
              ),
            ],
          ),

          // 3: Activity
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/activity',
                builder: (context, state) => const ActivityScreen(),
              ),
            ],
          ),

          // 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
