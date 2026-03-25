import '../models/purchase_log.dart';

class ThirtyDaySpendPoint {
  final DateTime day;
  final double amount;

  const ThirtyDaySpendPoint({
    required this.day,
    required this.amount,
  });
}

class TriggerBreakdownItem {
  final String label;
  final int count;

  const TriggerBreakdownItem({
    required this.label,
    required this.count,
  });
}

class ThirtyDayInsight {
  final double totalSpent;
  final int purchaseCount;
  final double averagePurchaseAmount;
  final String topTimeWindow;
  final List<TriggerBreakdownItem> triggerBreakdown;
  final List<ThirtyDaySpendPoint> spendPoints;
  final List<PurchaseLog> recentLogs;

  const ThirtyDayInsight({
    required this.totalSpent,
    required this.purchaseCount,
    required this.averagePurchaseAmount,
    required this.topTimeWindow,
    required this.triggerBreakdown,
    required this.spendPoints,
    required this.recentLogs,
  });
}

class ThirtyDayInsightService {
  static ThirtyDayInsight build({
    required List<PurchaseLog> logs,
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final start = today.subtract(const Duration(days: 29));
    final end = today;

    final filteredLogs = logs.where((log) {
      final day = _dateOnly(log.createdAt);
      return !_isBefore(day, start) && !_isAfter(day, end);
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final totalSpent = filteredLogs.fold<double>(
      0,
      (sum, log) => sum + log.amount,
    );

    final purchaseCount = filteredLogs.length;

    final averagePurchaseAmount =
        purchaseCount == 0 ? 0 : totalSpent / purchaseCount;

    return ThirtyDayInsight(
      totalSpent: totalSpent,
      purchaseCount: purchaseCount,
      averagePurchaseAmount: averagePurchaseAmount,
      topTimeWindow: _topTimeWindow(filteredLogs),
      triggerBreakdown: _buildTriggerBreakdown(filteredLogs),
      spendPoints: _buildSpendPoints(
        start: start,
        end: end,
        logs: filteredLogs,
      ),
      recentLogs: filteredLogs,
    );
  }

  static List<TriggerBreakdownItem> _buildTriggerBreakdown(
    List<PurchaseLog> logs,
  ) {
    final counts = <String, int>{};

    for (final log in logs) {
      for (final tag in log.tags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) {
        final countCompare = b.value.compareTo(a.value);
        if (countCompare != 0) {
          return countCompare;
        }
        return a.key.compareTo(b.key);
      });

    return sorted
        .take(8)
        .map(
          (entry) => TriggerBreakdownItem(
            label: entry.key,
            count: entry.value,
          ),
        )
        .toList();
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

  static List<ThirtyDaySpendPoint> _buildSpendPoints({
    required DateTime start,
    required DateTime end,
    required List<PurchaseLog> logs,
  }) {
    final points = <ThirtyDaySpendPoint>[];
    var day = start;

    while (!_isAfter(day, end)) {
      final amount = logs
          .where((log) {
            final logDay = _dateOnly(log.createdAt);
            return logDay.year == day.year &&
                logDay.month == day.month &&
                logDay.day == day.day;
          })
          .fold<double>(0, (sum, log) => sum + log.amount);

      points.add(
        ThirtyDaySpendPoint(
          day: day,
          amount: amount,
        ),
      );

      day = day.add(const Duration(days: 1));
    }

    return points;
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
