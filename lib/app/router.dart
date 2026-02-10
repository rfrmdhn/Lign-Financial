import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lign_financial/features/auth/presentation/auth_controller.dart';
import 'package:lign_financial/features/auth/presentation/login_screen.dart';
import 'package:lign_financial/features/home/presentation/home_screen.dart';
import 'package:lign_financial/features/account/presentation/account_screen.dart';
import 'package:lign_financial/features/qris/presentation/qris_screen.dart';
import 'package:lign_financial/features/activity/presentation/activity_screen.dart';
import 'package:lign_financial/features/profile/presentation/profile_screen.dart';
import 'package:lign_financial/features/shared/scaffold_with_navigation.dart';
import 'package:lign_financial/features/transfer/presentation/transfer_screen.dart';
import 'package:lign_financial/features/budget/presentation/budget_screen.dart';
import 'package:lign_financial/features/notifications/presentation/notifications_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
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
