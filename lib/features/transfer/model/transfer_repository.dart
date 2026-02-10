import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferRepository {
  Future<void> performTransfer({
    required String amount,
    required String destination,
    required String notes,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    return;
  }
}

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepository();
});
