import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lign_financial/core/design_system/colors.dart';

class FinanceScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const FinanceScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.approval_outlined), // Using check_circle as approx
            selectedIcon: Icon(Icons.approval),
            label: 'Approvals',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            selectedIcon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
           NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'AI',
          ),
        ],
        backgroundColor: LignColors.primaryBackground,
        indicatorColor: LignColors.electricLime,
      ),
    );
  }
}
