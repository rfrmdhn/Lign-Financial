
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/data/auth_repository.dart';
import 'package:lign_financial/features/auth/presentation/login_screen.dart';
import 'package:lign_financial/features/shared/scaffold_with_navigation.dart';
import 'package:lign_financial/features/shared/finance_scaffold_with_navigation.dart';
import 'package:lign_financial/features/employee/employee_screens.dart';
import 'package:lign_financial/features/finance/finance_screens.dart';

import 'package:lign_financial/features/auth/presentation/auth_controller.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      
      if (isLoggedIn && isLoggingIn) {
        if (authState.user!.role == UserRole.employee) return '/employee/home';
        if (authState.user!.role == UserRole.finance) return '/finance/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Employee Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/employee/home', builder: (context, state) => const EmployeeHomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/employee/cards', builder: (context, state) => const EmployeeCardsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/employee/qris', builder: (context, state) => const EmployeeQRISScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/employee/expenses', builder: (context, state) => const EmployeeExpensesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/employee/profile', builder: (context, state) => const EmployeeProfileScreen()),
          ]),
        ],
      ),
      // Finance Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return FinanceScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/finance/home', builder: (context, state) => const FinanceHomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/finance/approvals', builder: (context, state) => const FinanceApprovalsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/finance/cards', builder: (context, state) => const FinanceCardsScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/finance/expenses', builder: (context, state) => const FinanceExpensesScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/finance/ai', builder: (context, state) => const FinanceAIScreen()),
          ]),
        ],
      ),
    ],
  );
});
