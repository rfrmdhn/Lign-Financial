import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/transfer/model/recipient_model.dart';
import 'package:lign_financial/features/transfer/model/transfer_repository.dart';

/// State for the recipient list page.
class RecipientListState {
  final bool isLoading;
  final List<RecipientModel> recipients;

  const RecipientListState({
    this.isLoading = true,
    this.recipients = const [],
  });

  RecipientListState copyWith({
    bool? isLoading,
    List<RecipientModel>? recipients,
  }) {
    return RecipientListState(
      isLoading: isLoading ?? this.isLoading,
      recipients: recipients ?? this.recipients,
    );
  }
}

/// ViewModel for the saved-recipient list page.
class TransferRecipientListViewModel extends Notifier<RecipientListState> {
  @override
  RecipientListState build() {
    Future.microtask(() => loadRecipients());
    return const RecipientListState();
  }

  Future<void> loadRecipients() async {
    state = state.copyWith(isLoading: true);
    final repo = ref.read(transferRepositoryProvider);
    final recipients = await repo.getSavedRecipients();
    state = state.copyWith(isLoading: false, recipients: recipients);
  }
}

final transferRecipientListProvider =
    NotifierProvider<TransferRecipientListViewModel, RecipientListState>(() {
  return TransferRecipientListViewModel();
});
