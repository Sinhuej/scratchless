import '../models/purchase_log.dart';

class StreakService {
  static int currentStreakDays({
    required DateTime? startedAt,
    required List<PurchaseLog> logs,
    DateTime? now,
  }) {
    if (startedAt == null) {
      return 0;
    }

    final today = _dateOnly(now ?? DateTime.now());
    final purchaseDays = _distinctPurchaseDays(logs);

    if (purchaseDays.isEmpty) {
      final startDay = _dateOnly(startedAt);
      return today.difference(startDay).inDays;
    }

    final lastPurchaseDay = purchaseDays.last;
    return today.difference(lastPurchaseDay).inDays;
  }

  static int bestStreakDays({
    required DateTime? startedAt,
    required List<PurchaseLog> logs,
    DateTime? now,
  }) {
    if (startedAt == null) {
      return 0;
    }

    final today = _dateOnly(now ?? DateTime.now());
    final startDay = _dateOnly(startedAt);
    final purchaseDays = _distinctPurchaseDays(logs);

    if (purchaseDays.isEmpty) {
      return today.difference(startDay).inDays;
    }

    int best = 0;

    final beforeFirstPurchase =
        purchaseDays.first.difference(startDay).inDays;
    if (beforeFirstPurchase > best) {
      best = beforeFirstPurchase;
    }

    for (int i = 1; i < purchaseDays.length; i++) {
      final gap = purchaseDays[i].difference(purchaseDays[i - 1]).inDays - 1;
      if (gap > best) {
        best = gap;
      }
    }

    final currentGap = today.difference(purchaseDays.last).inDays;
    if (currentGap > best) {
      best = currentGap;
    }

    return best < 0 ? 0 : best;
  }

  static List<DateTime> _distinctPurchaseDays(List<PurchaseLog> logs) {
    final seen = <String>{};
    final days = <DateTime>[];

    for (final log in logs) {
      final day = _dateOnly(log.createdAt);
      final key = '${day.year}-${day.month}-${day.day}';
      if (seen.add(key)) {
        days.add(day);
      }
    }

    days.sort((a, b) => a.compareTo(b));
    return days;
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
