import '../models/purchase_log.dart';
import 'weekly_summary_service.dart';

class WeeklyReflectionReport {
  final String title;
  final String summary;
  final String strongestWindow;
  final String topTrigger;
  final List<String> reflections;
  final String nextStep;

  const WeeklyReflectionReport({
    required this.title,
    required this.summary,
    required this.strongestWindow,
    required this.topTrigger,
    required this.reflections,
    required this.nextStep,
  });
}

class WeeklyReflectionService {
  static WeeklyReflectionReport build({
    required WeeklySummary weeklySummary,
    required List<PurchaseLog> logs,
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final start = today.subtract(const Duration(days: 6));

    final weekLogs = logs.where((log) {
      final day = _dateOnly(log.createdAt);
      return !_isBefore(day, start) && !_isAfter(day, today);
    }).toList();

    final strongestWindow = _topTimeWindow(weekLogs);
    final topTrigger = weeklySummary.topTriggerThisWeek;

    final title = _title(
      purchasesThisWeek: weeklySummary.purchasesThisWeek,
      purchasesPreviousWeek: weeklySummary.purchasesPreviousWeek,
      spentThisWeek: weeklySummary.spentThisWeek,
      spentPreviousWeek: weeklySummary.spentPreviousWeek,
      urgeWinsThisWeek: weeklySummary.urgeWinsThisWeek,
    );

    final summary =
        'You logged ${weeklySummary.purchasesThisWeek} purchase${weeklySummary.purchasesThisWeek == 1 ? '' : 's'}, spent \$${weeklySummary.spentThisWeek.toStringAsFixed(0)}, and kept an estimated \$${weeklySummary.cashKeptThisWeek.toStringAsFixed(0)} this week.';

    final reflections = _buildReflections(
      weeklySummary: weeklySummary,
      strongestWindow: strongestWindow,
      topTrigger: topTrigger,
    );

    final nextStep = _nextStep(
      strongestWindow: strongestWindow,
      topTrigger: topTrigger,
      urgeWinsThisWeek: weeklySummary.urgeWinsThisWeek,
    );

    return WeeklyReflectionReport(
      title: title,
      summary: summary,
      strongestWindow: strongestWindow,
      topTrigger: topTrigger,
      reflections: reflections,
      nextStep: nextStep,
    );
  }

  static String _title({
    required int purchasesThisWeek,
    required int purchasesPreviousWeek,
    required double spentThisWeek,
    required double spentPreviousWeek,
    required int urgeWinsThisWeek,
  }) {
    if (purchasesThisWeek == 0 && urgeWinsThisWeek > 0) {
      return 'This week showed real interruption';
    }

    if (purchasesThisWeek == 0) {
      return 'This week stayed quiet';
    }

    if (purchasesThisWeek < purchasesPreviousWeek &&
        spentThisWeek <= spentPreviousWeek) {
      return 'This week looked lighter';
    }

    if (purchasesThisWeek > purchasesPreviousWeek ||
        spentThisWeek > spentPreviousWeek) {
      return 'This week looked heavier';
    }

    return 'This week showed useful signals';
  }

  static List<String> _buildReflections({
    required WeeklySummary weeklySummary,
    required String strongestWindow,
    required String topTrigger,
  }) {
    final lines = <String>[
      weeklySummary.comparisonMessage,
    ];

    if (strongestWindow != 'No purchase window pattern yet') {
      lines.add(
        'The strongest purchase window this week was $strongestWindow.',
      );
    }

    if (!topTrigger.startsWith('No common')) {
      lines.add(
        'The most repeated trigger tag this week was $topTrigger.',
      );
    } else {
      lines.add(
        'There was not a dominant trigger tag this week yet.',
      );
    }

    if (weeklySummary.urgeWinsThisWeek > 0) {
      lines.add(
        'You interrupted ${weeklySummary.urgeWinsThisWeek} urge${weeklySummary.urgeWinsThisWeek == 1 ? '' : 's'} this week, which still matters.',
      );
    } else {
      lines.add(
        'There were no logged urge wins this week, which may mean support tools were used less or the week stayed quiet.',
      );
    }

    return lines;
  }

  static String _nextStep({
    required String strongestWindow,
    required String topTrigger,
    required int urgeWinsThisWeek,
  }) {
    if (topTrigger == 'Money pressure') {
      return 'When money pressure shows up, open ScratchLess before stopping anywhere tickets are sold.';
    }

    if (topTrigger == 'Stress') {
      return 'If stress is showing up again, use urge mode before the feeling turns into a ticket stop.';
    }

    if (topTrigger == 'After work') {
      return 'Try opening ScratchLess right after work before the usual routine starts.';
    }

    if (strongestWindow == 'Evening') {
      return 'Open ScratchLess before your evening window and let the reminder act as a pause cue.';
    }

    if (strongestWindow == 'Late night') {
      return 'Late hours may need more support. Use reminders and logging before the night feels impulsive.';
    }

    if (urgeWinsThisWeek > 0) {
      return 'Keep using urge mode early. The earlier you interrupt the loop, the easier it is to keep the cash.';
    }

    return 'Keep logging honestly for another week. Clearer patterns usually appear with repetition.';
  }

  static String _topTimeWindow(List<PurchaseLog> logs) {
    if (logs.isEmpty) {
      return 'No purchase window pattern yet';
    }

    final Map<String, int> buckets = {
      'Morning': 0,
      'Afternoon': 0,
      'Evening': 0,
      'Late night': 0,
    };

    for (final log in logs) {
      final hour = log.createdAt.hour;
      if (hour >= 5 && hour < 12) {
        buckets['Morning'] = buckets['Morning']! + 1;
      } else if (hour >= 12 && hour < 17) {
        buckets['Afternoon'] = buckets['Afternoon']! + 1;
      } else if (hour >= 17 && hour < 22) {
        buckets['Evening'] = buckets['Evening']! + 1;
      } else {
        buckets['Late night'] = buckets['Late night']! + 1;
      }
    }

    final sorted = buckets.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  static bool _isBefore(DateTime a, DateTime b) {
    return a.year < b.year ||
        (a.year == b.year && a.month < b.month) ||
        (a.year == b.year && a.month == b.month && a.day < b.day);
  }

  static bool _isAfter(DateTime a, DateTime b) {
    return a.year > b.year ||
        (a.year == b.year && a.month > b.month) ||
        (a.year == b.year && a.month == b.month && a.day > b.day);
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
