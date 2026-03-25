class PremiumState {
  final bool isPremium;
  final DateTime? trialStartedAt;

  const PremiumState({
    required this.isPremium,
    required this.trialStartedAt,
  });

  factory PremiumState.free() {
    return const PremiumState(
      isPremium: false,
      trialStartedAt: null,
    );
  }

  PremiumState copyWith({
    bool? isPremium,
    DateTime? trialStartedAt,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      trialStartedAt: trialStartedAt ?? this.trialStartedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPremium': isPremium,
      'trialStartedAt': trialStartedAt?.toIso8601String(),
    };
  }

  factory PremiumState.fromJson(Map<String, dynamic> json) {
    final rawTrialStartedAt = json['trialStartedAt']?.toString();
    final parsedTrialStartedAt = rawTrialStartedAt == null
        ? null
        : DateTime.tryParse(rawTrialStartedAt);

    return PremiumState(
      isPremium: json['isPremium'] as bool? ?? false,
      trialStartedAt: parsedTrialStartedAt,
    );
  }
}
