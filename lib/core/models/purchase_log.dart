class PurchaseLog {
  final String id;
  final DateTime createdAt;
  final double amount;
  final String? note;
  final List<String> tags;

  const PurchaseLog({
    required this.id,
    required this.createdAt,
    required this.amount,
    this.note,
    this.tags = const <String>[],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

    final fallbackId = parsedDate == null
        ? DateTime.now().microsecondsSinceEpoch.toString()
        : parsedDate.microsecondsSinceEpoch.toString();

    return PurchaseLog(
      id: json['id']?.toString() ?? fallbackId,
      createdAt: parsedDate ?? DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      note: json['note']?.toString(),
      tags: tags,
    );
  }

  PurchaseLog copyWith({
    String? id,
    DateTime? createdAt,
    double? amount,
    String? note,
    List<String>? tags,
  }) {
    return PurchaseLog(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      tags: tags ?? this.tags,
    );
  }
}
