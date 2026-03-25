class UrgeSessionLog {
  final DateTime completedAt;

  const UrgeSessionLog({
    required this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory UrgeSessionLog.fromJson(Map<String, dynamic> json) {
    final raw = json['completedAt']?.toString();
    final parsed = raw == null ? null : DateTime.tryParse(raw);

    return UrgeSessionLog(
      completedAt: parsed ?? DateTime.now(),
    );
  }
}
