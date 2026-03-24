class ReminderSettings {
  final bool dailyCheckInEnabled;
  final bool eveningSupportEnabled;
  final int dailyCheckInHour;

  const ReminderSettings({
    required this.dailyCheckInEnabled,
    required this.eveningSupportEnabled,
    required this.dailyCheckInHour,
  });

  factory ReminderSettings.defaults() {
    return const ReminderSettings(
      dailyCheckInEnabled: false,
      eveningSupportEnabled: false,
      dailyCheckInHour: 20,
    );
  }

  ReminderSettings copyWith({
    bool? dailyCheckInEnabled,
    bool? eveningSupportEnabled,
    int? dailyCheckInHour,
  }) {
    return ReminderSettings(
      dailyCheckInEnabled:
          dailyCheckInEnabled ?? this.dailyCheckInEnabled,
      eveningSupportEnabled:
          eveningSupportEnabled ?? this.eveningSupportEnabled,
      dailyCheckInHour:
          dailyCheckInHour ?? this.dailyCheckInHour,
    );
  }
}
