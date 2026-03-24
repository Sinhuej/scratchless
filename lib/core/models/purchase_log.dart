class PurchaseLog {
  final DateTime createdAt;
  final double amount;
  final String? note;

  const PurchaseLog({
    required this.createdAt,
    required this.amount,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'amount': amount,
      'note': note,
    };
  }

  factory PurchaseLog.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt']?.toString();
    final parsedDate = createdAtRaw == null
        ? null
        : DateTime.tryParse(createdAtRaw);

    return PurchaseLog(
      createdAt: parsedDate ?? DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      note: json['note']?.toString(),
    );
  }
}
