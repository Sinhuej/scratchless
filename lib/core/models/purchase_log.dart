class PurchaseLog {
  final DateTime createdAt;
  final double amount;
  final String? note;
  final List<String> tags;

  const PurchaseLog({
    required this.createdAt,
    required this.amount,
    this.note,
    this.tags = const <String>[],
  });

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'amount': amount,
      'note': note,
      'tags': tags,
    };
  }

  factory PurchaseLog.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt']?.toString();
    final parsedDate = createdAtRaw == null
        ? null
        : DateTime.tryParse(createdAtRaw);

    final rawTags = json['tags'];
    final tags = rawTags is List
        ? rawTags.map((item) => item.toString()).toList()
        : <String>[];

    return PurchaseLog(
      createdAt: parsedDate ?? DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      note: json['note']?.toString(),
      tags: tags,
    );
  }
}
