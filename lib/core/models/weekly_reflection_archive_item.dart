class WeeklyReflectionArchiveItem {
  final String id;
  final DateTime savedAt;
  final DateTime weekEnding;
  final String title;
  final String summary;
  final String strongestWindow;
  final String topTrigger;
  final List<String> reflections;
  final String nextStep;

  const WeeklyReflectionArchiveItem({
    required this.id,
    required this.savedAt,
    required this.weekEnding,
    required this.title,
    required this.summary,
    required this.strongestWindow,
    required this.topTrigger,
    required this.reflections,
    required this.nextStep,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'savedAt': savedAt.toIso8601String(),
      'weekEnding': weekEnding.toIso8601String(),
      'title': title,
      'summary': summary,
      'strongestWindow': strongestWindow,
      'topTrigger': topTrigger,
      'reflections': reflections,
      'nextStep': nextStep,
    };
  }

  factory WeeklyReflectionArchiveItem.fromJson(Map<String, dynamic> json) {
    final savedAtRaw = json['savedAt']?.toString();
    final weekEndingRaw = json['weekEnding']?.toString();

    final savedAt = savedAtRaw == null
        ? DateTime.now()
        : DateTime.tryParse(savedAtRaw) ?? DateTime.now();

    final weekEnding = weekEndingRaw == null
        ? DateTime.now()
        : DateTime.tryParse(weekEndingRaw) ?? DateTime.now();

    final rawReflections = json['reflections'];
    final reflections = rawReflections is List
        ? rawReflections.map((item) => item.toString()).toList()
        : <String>[];

    return WeeklyReflectionArchiveItem(
      id: json['id']?.toString() ?? weekEnding.microsecondsSinceEpoch.toString(),
      savedAt: savedAt,
      weekEnding: weekEnding,
      title: json['title']?.toString() ?? 'Weekly reflection',
      summary: json['summary']?.toString() ?? '',
      strongestWindow: json['strongestWindow']?.toString() ?? '',
      topTrigger: json['topTrigger']?.toString() ?? '',
      reflections: reflections,
      nextStep: json['nextStep']?.toString() ?? '',
    );
  }
}
