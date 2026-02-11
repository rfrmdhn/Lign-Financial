import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/auth/domain/user.dart';
import 'package:lign_financial/features/auth/viewmodel/auth_viewmodel.dart';

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
    final authState = ref.watch(authViewModelProvider);
    return ProfileState(
      isLoading: false,
      user: authState.user,
      isFinanceMode: false,
    );
  }

  Future<void> logout() async {
    await ref.read(authViewModelProvider.notifier).logout();
    state = const ProfileState();
  }
}

final profileViewModelProvider = NotifierProvider<ProfileViewModel, ProfileState>(() {
  return ProfileViewModel();
});
