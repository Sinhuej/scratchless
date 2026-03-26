import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/purchase_log.dart';
import '../../core/services/weekly_reflection_service.dart';
import '../../core/services/weekly_summary_service.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class WeeklyReflectionScreen extends StatelessWidget {
  final WeeklySummary weeklySummary;
  final List<PurchaseLog> logs;
  final VoidCallback onSaveToHistory;

  const WeeklyReflectionScreen({
    super.key,
    required this.weeklySummary,
    required this.logs,
    required this.onSaveToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final report = WeeklyReflectionService.build(
      weeklySummary: weeklySummary,
      logs: logs,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly reflection'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This week may be telling you...',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.summary,
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Save to reflection history',
                  icon: Icons.bookmark_add_rounded,
                  onPressed: () {
                    onSaveToHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Weekly reflection saved to history'),
                      ),
                    );
                  },
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
                  'Week at a glance',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  children: [
                    _metric(
                      label: 'Spent',
                      value: '\$${weeklySummary.spentThisWeek.toStringAsFixed(0)}',
                    ),
                    _metric(
                      label: 'Kept',
                      value: '\$${weeklySummary.cashKeptThisWeek.toStringAsFixed(0)}',
                    ),
                    _metric(
                      label: 'Purchases',
                      value: '${weeklySummary.purchasesThisWeek}',
                    ),
                    _metric(
                      label: 'Urge wins',
                      value: '${weeklySummary.urgeWinsThisWeek}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Strongest window: ${report.strongestWindow}',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Top trigger: ${report.topTrigger}',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What this week may be telling you',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...report.reflections.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: AppTheme.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  'Gentle next step',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.nextStep,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _metric({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
