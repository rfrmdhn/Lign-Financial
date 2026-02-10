import 'package:flutter/material.dart';
import 'package:lign_financial/core/design_system/colors.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Employee Home'));
}

class EmployeeCardsScreen extends StatelessWidget {
  const EmployeeCardsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Employee Cards'));
}

class EmployeeQRISScreen extends StatelessWidget {
  const EmployeeQRISScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('QRIS Scanner Placeholder', style: TextStyle(color: LignColors.textPrimary)));
}

class EmployeeExpensesScreen extends StatelessWidget {
  const EmployeeExpensesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Employee Expenses'));
}

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Employee Profile'));
}
