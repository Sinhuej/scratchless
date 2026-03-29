class MilestoneState {
  final List<String> celebratedIds;

  const MilestoneState({
    required this.celebratedIds,
  });

  factory MilestoneState.empty() {
    return const MilestoneState(
      celebratedIds: <String>[],
    );
  }

  bool isCelebrated(String id) {
    return celebratedIds.contains(id);
  }

  MilestoneState copyWith({
    List<String>? celebratedIds,
  }) {
    return MilestoneState(
      celebratedIds: celebratedIds ?? this.celebratedIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'celebratedIds': celebratedIds,
    };
  }

  factory MilestoneState.fromJson(Map<String, dynamic> json) {
    final ids = (json['celebratedIds'] as List<dynamic>?)
            ?.map((item) => item.toString())
            .toList() ??
        <String>[];

    return MilestoneState(
      celebratedIds: ids,
    );
  }
}
