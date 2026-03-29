class ReminderSettings {
  final bool dailyCheckInEnabled;
  final bool eveningSupportEnabled;
  final int dailyCheckInHour;
  final bool habitTimeWarningsEnabled;

  const ReminderSettings({
    required this.dailyCheckInEnabled,
    required this.eveningSupportEnabled,
    required this.dailyCheckInHour,
    required this.habitTimeWarningsEnabled,
  });

  factory ReminderSettings.defaults() {
    return const ReminderSettings(
      dailyCheckInEnabled: false,
      eveningSupportEnabled: false,
      dailyCheckInHour: 20,
      habitTimeWarningsEnabled: false,
    );
  }

  ReminderSettings copyWith({
    bool? dailyCheckInEnabled,
    bool? eveningSupportEnabled,
    int? dailyCheckInHour,
    bool? habitTimeWarningsEnabled,
  }) {
    return ReminderSettings(
      dailyCheckInEnabled:
          dailyCheckInEnabled ?? this.dailyCheckInEnabled,
      eveningSupportEnabled:
          eveningSupportEnabled ?? this.eveningSupportEnabled,
      dailyCheckInHour: dailyCheckInHour ?? this.dailyCheckInHour,
      habitTimeWarningsEnabled:
          habitTimeWarningsEnabled ?? this.habitTimeWarningsEnabled,
    );
  }
}
