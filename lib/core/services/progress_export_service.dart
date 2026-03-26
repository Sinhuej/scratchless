import '../services/thirty_day_insight_service.dart';
import '../services/weekly_summary_service.dart';

class ProgressExportReport {
  final String title;
  final String body;

  const ProgressExportReport({
    required this.title,
    required this.body,
  });
}

class ProgressExportService {
  static ProgressExportReport build({
    required WeeklySummary weeklySummary,
    required ThirtyDayInsight thirtyDayInsight,
    required int currentStreakDays,
    required int bestStreakDays,
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();

    final title = 'ScratchLess progress summary';

    final lines = <String>[
      'ScratchLess Progress Summary',
      'Generated: ${today.month}/${today.day}/${today.year}',
      '',
      'Weekly snapshot',
      '- Spent this week: \$${weeklySummary.spentThisWeek.toStringAsFixed(0)}',
      '- Estimated cash kept this week: \$${weeklySummary.cashKeptThisWeek.toStringAsFixed(0)}',
      '- Purchases this week: ${weeklySummary.purchasesThisWeek}',
      '- Urge wins this week: ${weeklySummary.urgeWinsThisWeek}',
      '- Top trigger this week: ${weeklySummary.topTriggerThisWeek}',
      '',
      'Streaks',
      '- Current streak: $currentStreakDays day${currentStreakDays == 1 ? '' : 's'}',
      '- Best streak: $bestStreakDays day${bestStreakDays == 1 ? '' : 's'}',
      '',
      'Last 30 days',
      '- Total spent: \$${thirtyDayInsight.totalSpent.toStringAsFixed(0)}',
      '- Purchase count: ${thirtyDayInsight.purchaseCount}',
      '- Average purchase amount: \$${thirtyDayInsight.averagePurchaseAmount.toStringAsFixed(0)}',
      '- Top purchase window: ${thirtyDayInsight.topTimeWindow}',
      '',
      'Notes',
      '- ${weeklySummary.comparisonMessage}',
      '- This summary is meant to support honest tracking and accountability.',
    ];

    if (thirtyDayInsight.triggerBreakdown.isNotEmpty) {
      lines.add('');
      lines.add('30-day trigger breakdown');
      for (final item in thirtyDayInsight.triggerBreakdown) {
        lines.add('- ${item.label}: ${item.count}');
      }
    }

    return ProgressExportReport(
      title: title,
      body: lines.join('\n'),
    );
  }
}
