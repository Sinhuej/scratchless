import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/reminder_settings.dart';
import '../../shared/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  final String goal;
  final int frequencyPerWeek;
  final double averageSpend;
  final double monthlySpendEstimate;
  final int currentStreakDays;
  final int bestStreakDays;
  final ReminderSettings reminderSettings;
  final ValueChanged<ReminderSettings> onUpdateReminderSettings;

  const ProfileScreen({
    super.key,
    required this.goal,
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.monthlySpendEstimate,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.reminderSettings,
    required this.onUpdateReminderSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current focus',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  goal,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Progress is still progress. The goal can change later.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Streak summary',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current: $currentStreakDays day${currentStreakDays == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Best: $bestStreakDays day${bestStreakDays == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Starting baseline',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$frequencyPerWeek purchase periods per week',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'About \$${averageSpend.toStringAsFixed(0)} each time',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimated starting monthly spend: \$${monthlySpendEstimate.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Reminder scaffolding',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'These settings save now. Actual notification delivery comes in a later step.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Daily check-in reminder'),
                  subtitle: const Text('Gentle nudge to log how the day went.'),
                  value: reminderSettings.dailyCheckInEnabled,
                  onChanged: (value) {
                    onUpdateReminderSettings(
                      reminderSettings.copyWith(
                        dailyCheckInEnabled: value,
                      ),
                    );
                  },
                ),
                if (reminderSettings.dailyCheckInEnabled) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Preferred hour',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const <int>[17, 19, 20, 21].map((hour) {
                      return _HourChip(hour: hour);
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Evening support reminder'),
                  subtitle: const Text('Scaffold a future reminder during common risk hours.'),
                  value: reminderSettings.eveningSupportEnabled,
                  onChanged: (value) {
                    onUpdateReminderSettings(
                      reminderSettings.copyWith(
                        eveningSupportEnabled: value,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 4 notes',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Quick trigger tags make logging easier and improve insight quality without forcing long notes.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Reminder settings are saved now so notification delivery can be added cleanly in a later step.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HourChip extends StatelessWidget {
  final int hour;

  const _HourChip({
    required this.hour,
  });

  @override
  Widget build(BuildContext context) {
    final profile =
        context.findAncestorWidgetOfExactType<ProfileScreen>()!;
    final selected = profile.reminderSettings.dailyCheckInHour == hour;

    return ChoiceChip(
      label: Text(_label(hour)),
      selected: selected,
      onSelected: (_) {
        profile.onUpdateReminderSettings(
          profile.reminderSettings.copyWith(
            dailyCheckInHour: hour,
          ),
        );
      },
    );
  }

  static String _label(int hour) {
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final value = hour > 12 ? hour - 12 : hour;
    return '$value:00 $suffix';
  }
}
