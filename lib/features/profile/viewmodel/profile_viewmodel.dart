import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/domain/user.dart';
// import 'package:lign_financial/features/auth/domain/app_mode.dart'; // If needed for logic

class ProfileState {
  final bool isLoading;
  final User? user;
  final bool isFinanceMode;
  final String? errorMessage;

  const ProfileState({
    this.isLoading = false,
    this.user,
    this.isFinanceMode = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    User? user,
    bool? isFinanceMode,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isFinanceMode: isFinanceMode ?? this.isFinanceMode,
      errorMessage: errorMessage,
    );
  }
}

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    loadProfile();
    return const ProfileState(isLoading: true);
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock Data (Consistent with Home)
    state = state.copyWith(
      isLoading: false,
      user: const User(id: 'u1', name: 'User', email: 'user@lign.com'), // Using mocked User
      isFinanceMode: false, // Default or fetch from shared pref/global state
    );
  }

  Future<void> logout() async {
     // Clear session logic here
     state = const ProfileState(); // Reset
  }
}

final profileViewModelProvider = NotifierProvider<ProfileViewModel, ProfileState>(() {
  return ProfileViewModel();
});
