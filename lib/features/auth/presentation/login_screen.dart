import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/core/widgets/lign_button.dart';
import 'package:lign_financial/core/widgets/lign_text_input.dart';
import 'package:lign_financial/features/auth/presentation/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) return;

    setState(() => _isLoading = true);

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      ref.read(authControllerProvider.notifier).login(username, password);
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = _usernameController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: LignColors.primaryBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/icon/Logo-1.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 16),

                // App Name
                Text(
                  'Lign Financial',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: LignColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Tagline
                Text(
                  'Corporate Banking & Spend Management',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: LignColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Username
                LignTextInput(
                  label: 'Username',
                  hintText: 'Enter your username',
                  controller: _usernameController,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: LignColors.textSecondary,
                    size: 20,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),

                // Password
                LignTextInput(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: LignColors.textSecondary,
                    size: 20,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: LignColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 36),

                // Login Button
                LignButton(
                  text: 'Login',
                  isLoading: _isLoading,
                  onPressed: isFormValid ? _handleLogin : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
