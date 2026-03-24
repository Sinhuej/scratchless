import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../shared/widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  final String goal;
  final int frequencyPerWeek;
  final double averageSpend;
  final double monthlySpendEstimate;

  const ProfileScreen({
    super.key,
    required this.goal,
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.monthlySpendEstimate,
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
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 1 notes',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This MVP keeps the core path free: onboarding, logging, streaks, stats, and urge interruption.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Premium, reminders, persistence, and advanced trigger analysis should come later.',
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
