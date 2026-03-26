import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_theme.dart';
import '../../core/models/purchase_log.dart';
import '../../core/services/progress_export_service.dart';
import '../../core/services/thirty_day_insight_service.dart';
import '../../core/services/weekly_summary_service.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class ExportSummaryScreen extends StatelessWidget {
  final WeeklySummary weeklySummary;
  final List<PurchaseLog> logs;
  final int currentStreakDays;
  final int bestStreakDays;

  const ExportSummaryScreen({
    super.key,
    required this.weeklySummary,
    required this.logs,
    required this.currentStreakDays,
    required this.bestStreakDays,
  });

  @override
  Widget build(BuildContext context) {
    final thirtyDayInsight = ThirtyDayInsightService.build(logs: logs);
    final report = ProgressExportService.build(
      weeklySummary: weeklySummary,
      thirtyDayInsight: thirtyDayInsight,
      currentStreakDays: currentStreakDays,
      bestStreakDays: bestStreakDays,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Export summary'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share-ready summary',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Copy this summary and paste it into a text, email, or notes app for accountability.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Copy summary',
                  icon: Icons.copy_rounded,
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: report.body),
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Progress summary copied'),
                        ),
                      );
                    }
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
                Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                SelectableText(
                  report.body,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Colors.white,
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
