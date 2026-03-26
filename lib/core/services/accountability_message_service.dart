import 'progress_export_service.dart';
import 'weekly_summary_service.dart';

class AccountabilityMessageService {
  static String buildProgressSummaryMessage({
    required String? partnerName,
    required ProgressExportReport report,
  }) {
    final intro = _nameIntro(
      partnerName,
      fallback: 'I wanted to share a quick ScratchLess progress update.',
    );

    return '$intro\n\n${report.body}';
  }

  static String buildCheckInMessage({
    required String? partnerName,
    required WeeklySummary weeklySummary,
    required int currentStreakDays,
  }) {
    final intro = _nameIntro(
      partnerName,
      fallback: 'I wanted to send a quick check-in.',
    );

    return '$intro\n\n'
        'This week I logged ${weeklySummary.purchasesThisWeek} purchase'
        '${weeklySummary.purchasesThisWeek == 1 ? '' : 's'}, '
        'spent \$${weeklySummary.spentThisWeek.toStringAsFixed(0)}, '
        'and kept an estimated \$${weeklySummary.cashKeptThisWeek.toStringAsFixed(0)}.\n'
        'My current streak is $currentStreakDays day${currentStreakDays == 1 ? '' : 's'}.\n\n'
        'I’m sharing this to stay honest and accountable.';
  }

  static String buildSupportNowMessage({
    required String? partnerName,
  }) {
    final intro = _nameIntro(
      partnerName,
      fallback: 'I need support right now.',
    );

    return '$intro\n\n'
        'I’m having a strong urge to buy scratch-offs right now.\n'
        'Can you check in with me for a few minutes or help me pause before I make it worse?';
  }

  static String _nameIntro(
    String? partnerName, {
    required String fallback,
  }) {
    final name = partnerName?.trim() ?? '';
    if (name.isEmpty) {
      return fallback;
    }

    return 'Hey $name, $fallback';
  }
}
