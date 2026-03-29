class RiskyPlace {
  final String id;
  final String label;
  final String note;
  final bool isTopRisk;

  const RiskyPlace({
    required this.id,
    required this.label,
    required this.note,
    required this.isTopRisk,
  });

  RiskyPlace copyWith({
    String? id,
    String? label,
    String? note,
    bool? isTopRisk,
  }) {
    return RiskyPlace(
      id: id ?? this.id,
      label: label ?? this.label,
      note: note ?? this.note,
      isTopRisk: isTopRisk ?? this.isTopRisk,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'note': note,
      'isTopRisk': isTopRisk,
    };
  }

  factory RiskyPlace.fromJson(Map<String, dynamic> json) {
    return RiskyPlace(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      isTopRisk: json['isTopRisk'] == true,
    );
  }
}
