import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lign_financial/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:lign_financial/features/login/view/login_page.dart';
import 'package:lign_financial/features/home/view/home_page.dart';
import 'package:lign_financial/features/account/view/account_page.dart';
import 'package:lign_financial/features/qris/view/qris_page.dart';
import 'package:lign_financial/features/activity/view/activity_page.dart';
import 'package:lign_financial/features/profile/view/profile_page.dart';
import 'package:lign_financial/features/shared/view/scaffold_with_navigation.dart';
import 'package:lign_financial/features/transfer/view/transfer_page.dart';
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
      GoRoute(
        path: '/transfer',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TransferScreen(),
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
