/// Model representing a saved transfer recipient.
class RecipientModel {
  final String id;
  final String alias;
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountHolderName;

  const RecipientModel({
    required this.id,
    required this.alias,
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountHolderName,
  });
}
