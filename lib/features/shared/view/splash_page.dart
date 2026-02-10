import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/features/auth/viewmodel/auth_viewmodel.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Simulate checking local storage or secure storage
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, we would read from storage here and set the user in AuthViewModel
    // For now, we always redirect to login since we don't have persistence yet
    // The previous logic relied on AuthViewModel already having a user, which we removed.
    
    if (mounted) {
       // Force check: if user is null, go to Login
       final authState = ref.read(authViewModelProvider);
       if (authState.user != null) {
         context.go('/home');
       } else {
         context.go('/login');
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LignColors.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/Logo-1.png',
              width: 160,
              height: 160,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(LignColors.electricLime),
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
