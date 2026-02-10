import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/features/auth/data/auth_repository.dart';
import 'package:lign_financial/features/auth/presentation/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lign Financial',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Corporate Banking & Spend Management',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              LignButton(
                text: 'Login as Employee',
                onPressed: () {
                  ref.read(authControllerProvider.notifier).login(UserRole.employee);
                },
              ),
              const SizedBox(height: 16),
              LignButton(
                text: 'Login as Finance',
                type: LignButtonType.secondary,
                onPressed: () {
                  ref.read(authControllerProvider.notifier).login(UserRole.finance);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
