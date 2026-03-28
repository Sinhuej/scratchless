import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/accountability_partner.dart';
import '../../core/models/premium_state.dart';
import '../../core/models/reminder_settings.dart';
import '../../core/services/feature_gate_service.dart';
import '../../features/premium/premium_screen.dart';
import '../../shared/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  final String goal;
  final int frequencyPerWeek;
  final double averageSpend;
  final double monthlySpendEstimate;
  final int currentStreakDays;
  final int bestStreakDays;
  final ReminderSettings reminderSettings;
  final PremiumState premiumState;
  final AccountabilityPartner accountabilityPartner;
  final ValueChanged<ReminderSettings> onUpdateReminderSettings;
  final VoidCallback onStartPremiumTrial;
  final VoidCallback onOpenHelp;
  final VoidCallback onOpenAccountability;
  final VoidCallback onOpenReasons;
  final VoidCallback onOpenCopingStrategies;
  final VoidCallback onOpenNearMissEducation;

  const ProfileScreen({
    super.key,
    required this.goal,
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.monthlySpendEstimate,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.reminderSettings,
    required this.premiumState,
    required this.accountabilityPartner,
    required this.onUpdateReminderSettings,
    required this.onStartPremiumTrial,
    required this.onOpenHelp,
    required this.onOpenAccountability,
    required this.onOpenReasons,
    required this.onOpenCopingStrategies,
    required this.onOpenNearMissEducation,
  });

  void _openPremiumScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PremiumScreen(
          premiumState: premiumState,
          onStartTrial: onStartPremiumTrial,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customReminderUnlocked =
        FeatureGateService.customReminderSchedulesUnlocked(premiumState);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            onTap: onOpenHelp,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get help now',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Open support options',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Call, text, or chat help when an urge feels too big to handle alone.',
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
            onTap: onOpenCopingStrategies,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coping strategies',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'What to do during the urge',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Open short, practical strategies for slowing the urge down and choosing something else.',
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
            onTap: onOpenNearMissEducation,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Near-miss psychology',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Why almost winning can pull you back in',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Open a calm explanation of why near misses can feel powerful even when they still cost you money.',
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
            onTap: onOpenReasons,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reasons to stop',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep your reasons close',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Save the words you want to hear when the urge gets loud.',
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
            onTap: onOpenAccountability,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Accountability partner',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  accountabilityPartner.hasName
                      ? accountabilityPartner.name
                      : 'Set up accountability',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  accountabilityPartner.hasName
                      ? 'Save quick check-in, support, and progress-sharing messages for a trusted person.'
                      : 'Save one trusted person and use ready-to-send support and accountability messages.',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => _openPremiumScreen(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ScratchLess Premium',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  FeatureGateService.premiumStatusLabel(premiumState),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  premiumState.isPremium
                      ? 'You have access to premium scaffolding and upcoming deeper insight tools.'
                      : 'Unlock deeper insights, longer history, custom reminder schedules, and more support tools.',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to view Premium',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 12,
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
                  'Reminders',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'These schedule real local reminders after permission is granted.',
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
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    customReminderUnlocked
                        ? Icons.lock_open_rounded
                        : Icons.lock_rounded,
                  ),
                  title: const Text('Custom reminder schedules'),
                  subtitle: Text(
                    customReminderUnlocked
                        ? 'Premium scaffold unlocked. Expanded reminder scheduling comes next.'
                        : 'Premium feature',
                  ),
                  onTap: customReminderUnlocked
                      ? null
                      : () => _openPremiumScreen(context),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Evening support reminder'),
                  subtitle: const Text('Daily 7:00 PM pause-first reminder.'),
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
                  'Step 8 notes',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Premium is scaffolded softly here: the core path stays free while deeper tools are positioned as an optional upgrade.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Billing and store purchases come later. This step is about fair structure and feature gating.',
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
