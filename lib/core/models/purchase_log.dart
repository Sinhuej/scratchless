class PurchaseLog {
  final DateTime createdAt;
  final double amount;
  final String? note;

  const PurchaseLog({
    required this.createdAt,
    required this.amount,
    this.note,
  });
}
