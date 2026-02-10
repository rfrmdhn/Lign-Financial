import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/features/auth/viewmodel/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) return;

    await ref.read(authViewModelProvider.notifier).login(username, password);
    
    if (mounted) {
      final state = ref.read(authViewModelProvider);
      if (state.user != null) {
        context.go('/home');
      } else if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: LignColors.primaryBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Icon
              Center(
                child: Image.asset(
                  'assets/icon/Logo-1.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Lign',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: LignColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Corporate Banking',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: LignColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              LignTextInput(
                label: 'Username',
                controller: _usernameController,
                hintText: 'Enter your username',
              ),
              const SizedBox(height: 16),
              LignTextInput(
                label: 'Password',
                controller: _passwordController,
                hintText: 'Enter your password',
                obscureText: true,
              ),
              const SizedBox(height: 32),
              LignButton(
                text: 'Login',
                isLoading: state.isLoading,
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
