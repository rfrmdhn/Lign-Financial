class AccountData {
  final String companyName;
  final String accountNumber;
  final double balance;
  final String accountType;
  final List<BankAccount> linkedAccounts;
  final List<VirtualAccount> virtualAccounts;

  const AccountData({
    required this.companyName,
    required this.accountNumber,
    required this.balance,
    required this.accountType,
    required this.linkedAccounts,
    required this.virtualAccounts,
  });
}

class BankAccount {
  final String bankName;
  final String accountNumber;
  final bool isPrimary;

  const BankAccount({
    required this.bankName,
    required this.accountNumber,
    required this.isPrimary,
  });
}

class VirtualAccount {
  final String label;
  final String number;

  const VirtualAccount({
    required this.label,
    required this.number,
  });
}

abstract class AccountRepository {
  Future<AccountData> getAccountData();
}

class AccountRepositoryImpl implements AccountRepository {
  @override
  Future<AccountData> getAccountData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const AccountData(
      companyName: 'PT Lign Teknologi',
      accountNumber: '888 0012 3456 789',
      balance: 2450000000,
      accountType: 'Corporate Business',
      linkedAccounts: [
        BankAccount(bankName: 'Bank Central Asia (BCA)', accountNumber: '*** **** 4567', isPrimary: true),
        BankAccount(bankName: 'Bank Mandiri', accountNumber: '*** **** 8901', isPrimary: false),
      ],
      virtualAccounts: [
        VirtualAccount(label: 'Payment Collection', number: '8800 1234 5678 9012'),
        VirtualAccount(label: 'Payroll Disbursement', number: '8800 9876 5432 1098'),
      ],
    );
  }
}
