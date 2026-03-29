class SpendCapPlan {
  final bool dailyCapEnabled;
  final double dailyCapAmount;
  final bool weeklyCapEnabled;
  final double weeklyCapAmount;

  const SpendCapPlan({
    required this.dailyCapEnabled,
    required this.dailyCapAmount,
    required this.weeklyCapEnabled,
    required this.weeklyCapAmount,
  });

  factory SpendCapPlan.defaults() {
    return const SpendCapPlan(
      dailyCapEnabled: false,
      dailyCapAmount: 20,
      weeklyCapEnabled: false,
      weeklyCapAmount: 100,
    );
  }

  SpendCapPlan copyWith({
    bool? dailyCapEnabled,
    double? dailyCapAmount,
    bool? weeklyCapEnabled,
    double? weeklyCapAmount,
  }) {
    return SpendCapPlan(
      dailyCapEnabled: dailyCapEnabled ?? this.dailyCapEnabled,
      dailyCapAmount: dailyCapAmount ?? this.dailyCapAmount,
      weeklyCapEnabled: weeklyCapEnabled ?? this.weeklyCapEnabled,
      weeklyCapAmount: weeklyCapAmount ?? this.weeklyCapAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyCapEnabled': dailyCapEnabled,
      'dailyCapAmount': dailyCapAmount,
      'weeklyCapEnabled': weeklyCapEnabled,
      'weeklyCapAmount': weeklyCapAmount,
    };
  }

  factory SpendCapPlan.fromJson(Map<String, dynamic> json) {
    return SpendCapPlan(
      dailyCapEnabled: json['dailyCapEnabled'] == true,
      dailyCapAmount: (json['dailyCapAmount'] as num?)?.toDouble() ?? 20,
      weeklyCapEnabled: json['weeklyCapEnabled'] == true,
      weeklyCapAmount: (json['weeklyCapAmount'] as num?)?.toDouble() ?? 100,
    );
  }
}
