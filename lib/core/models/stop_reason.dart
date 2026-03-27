class StopReason {
  final String id;
  final String text;

  const StopReason({
    required this.id,
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  factory StopReason.fromJson(Map<String, dynamic> json) {
    return StopReason(
      id: json['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      text: json['text']?.toString() ?? '',
    );
  }

  StopReason copyWith({
    String? id,
    String? text,
  }) {
    return StopReason(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }
}
