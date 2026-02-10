import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lign_financial/features/transfer/model/bank_model.dart';
import 'package:lign_financial/features/transfer/model/recipient_model.dart';

/// Repository for transfer operations (mock implementation).
class TransferRepository {
  Future<List<RecipientModel>> getSavedRecipients() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      RecipientModel(
        id: '1',
        alias: 'Andi Payroll',
        bankName: 'BCA',
        bankCode: 'BCA',
        accountNumber: '1234567890',
        accountHolderName: 'Andi Wijaya',
      ),
      RecipientModel(
        id: '2',
        alias: 'Supplier Jaya',
        bankName: 'Mandiri',
        bankCode: 'MANDIRI',
        accountNumber: '0987654321',
        accountHolderName: 'PT Jaya Abadi',
      ),
      RecipientModel(
        id: '3',
        alias: 'Kantor Cabang',
        bankName: 'BNI',
        bankCode: 'BNI',
        accountNumber: '1122334455',
        accountHolderName: 'Lign Branch Office',
      ),
    ];
  }

  Future<List<BankModel>> getBanks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      BankModel(code: 'BCA', name: 'Bank Central Asia'),
      BankModel(code: 'MANDIRI', name: 'Bank Mandiri'),
      BankModel(code: 'BNI', name: 'Bank Negara Indonesia'),
      BankModel(code: 'BRI', name: 'Bank Rakyat Indonesia'),
      BankModel(code: 'CIMB', name: 'CIMB Niaga'),
      BankModel(code: 'DANAMON', name: 'Bank Danamon'),
      BankModel(code: 'PERMATA', name: 'Bank Permata'),
      BankModel(code: 'MEGA', name: 'Bank Mega'),
      BankModel(code: 'BTN', name: 'Bank Tabungan Negara'),
      BankModel(code: 'OCBC', name: 'OCBC NISP'),
    ];
  }

  /// Simulates looking up account holder name from bank + account number.
  Future<String> lookupAccountHolder({
    required String bankCode,
    required String accountNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock — return a name based on last digit
    final names = [
      'Budi Santoso', 'Siti Rahayu', 'Agus Pratama', 'Dewi Lestari',
      'Rudi Hermawan', 'Maya Sari', 'Dian Kusuma', 'Eka Putri',
      'Hendra Gunawan', 'Nadia Safitri',
    ];
    final idx = int.tryParse(accountNumber.substring(accountNumber.length - 1)) ?? 0;
    return names[idx % names.length];
  }

  Future<void> performTransfer({
    required String bankCode,
    required String accountNumber,
    required double amount,
    required String pin,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock — always succeeds
  }

  Future<void> saveRecipient({
    required String alias,
    required String bankName,
    required String bankCode,
    required String accountNumber,
    required String accountHolderName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock — always succeeds
  }
}

final transferRepositoryProvider = Provider<TransferRepository>((ref) {
  return TransferRepository();
});
