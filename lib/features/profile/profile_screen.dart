import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/accountability_partner.dart';
import '../../core/models/premium_state.dart';
import '../../core/models/reminder_settings.dart';
import '../../features/premium/premium_screen.dart';
import '../../shared/widgets/app_button.dart';
import '../urge/urge_scripts_screen.dart';
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
  final VoidCallback onOpenGoals;
  final VoidCallback onOpenMilestones;
  final VoidCallback onOpenPreStoreMode;
  final ValueChanged<String> onUpdateGoal;

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
    required this.onOpenGoals,
    required this.onOpenMilestones,
    required this.onOpenPreStoreMode,
    required this.onUpdateGoal,
  });

  void _openUrgeScriptsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const UrgeScriptsScreen(),
      ),
    );
  }

  Future<void> _showEditGoalSheet(BuildContext context) async {
    final controller = TextEditingController(text: goal);

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              20,
              16,
              16 + MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit current focus',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Keep it short, honest, and useful for right now.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Current focus',
                    hintText: 'Stop the spiral before the next ticket',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      label: const Text('Stop the spiral before the next ticket'),
                      onPressed: () {
                        controller.text =
                            'Stop the spiral before the next ticket';
                      },
                    ),
                    ActionChip(
                      label: const Text('Cut lottery spending without white-knuckling it'),
                      onPressed: () {
                        controller.text =
                            'Cut lottery spending without white-knuckling it';
                      },
                    ),
                    ActionChip(
                      label: const Text('Keep more cash for real life'),
                      onPressed: () {
                        controller.text = 'Keep more cash for real life';
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Save focus',
                  icon: Icons.check_rounded,
                  onPressed: () {
                    FocusScope.of(sheetContext).unfocus();
                    Navigator.of(sheetContext).pop(controller.text.trim());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();

    if (result == null) {
      return;
    }

    final nextGoal = result.trim();
    if (nextGoal.isEmpty || nextGoal == goal) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    onUpdateGoal(nextGoal);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Current focus updated'),
        ),
      );
    });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            onTap: onOpenMilestones,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Milestones',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Celebrate progress on purpose',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Open your milestone list and reinforce the wins you have actually earned.',
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
            onTap: onOpenPreStoreMode,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pre-store mode',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Interrupt it before the stop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use a fast intervention mode before the parking lot becomes a purchase.',
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
            onTap: onOpenGoals,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goals & spend caps',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Plan spending ahead of time',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Set optional daily and weekly caps so the app can help you spot when things are drifting.',
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
            onTap: () => _openUrgeScriptsScreen(context),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scratch-off urge scripts',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use situation-based urge scripts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Open short scripts for payday urges, seeing a display, recent wins, passing a store, and the “only one” trap.',
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
                  premiumState.isPremium ? 'Premium active' : 'Premium available',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  premiumState.isPremium
                      ? 'You have access to premium scaffolding and deeper tools.'
                      : 'Unlock deeper insights, longer history, custom reminders, and more support tools.',
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
            onTap: () => _showEditGoalSheet(context),
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
                  'Progress is still progress. Tap here to change this goal anytime.',
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
        ],
      ),
    );
  }
}
