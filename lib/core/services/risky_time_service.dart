import '../models/purchase_log.dart';

class RiskyTimeInsight {
  final bool hasEnoughData;
  final bool isActiveNow;
  final int? anchorHour;
  final String windowLabel;
  final String anchorLabel;
  final String profileSummary;
  final String activeHeadline;
  final String activeBody;

  const RiskyTimeInsight({
    required this.hasEnoughData,
    required this.isActiveNow,
    required this.anchorHour,
    required this.windowLabel,
    required this.anchorLabel,
    required this.profileSummary,
    required this.activeHeadline,
    required this.activeBody,
  });

  factory RiskyTimeInsight.empty() {
    return const RiskyTimeInsight(
      hasEnoughData: false,
      isActiveNow: false,
      anchorHour: null,
      windowLabel: 'No clear pattern yet',
      anchorLabel: '',
      profileSummary:
          'Keep logging honestly and ScratchLess will learn your harder hours.',
      activeHeadline: 'No risky-time pattern yet',
      activeBody:
          'Keep logging honestly and ScratchLess will learn your harder hours.',
    );
  }
}

class RiskyTimeService {
  static RiskyTimeInsight build({
    required List<PurchaseLog> logs,
    DateTime? now,
  }) {
    if (logs.length < 3) {
      return RiskyTimeInsight.empty();
    }

    final counts = List<int>.filled(24, 0);
    for (final log in logs) {
      counts[log.createdAt.hour] += 1;
    }

    int bestHour = 0;
    int bestScore = -1;

    for (int hour = 0; hour < 24; hour++) {
      final prev = counts[(hour + 23) % 24];
      final current = counts[hour];
      final next = counts[(hour + 1) % 24];
      final score = prev + current + next;

      if (score > bestScore) {
        bestScore = score;
        bestHour = hour;
      }
    }

    if (bestScore < 2) {
      return RiskyTimeInsight.empty();
    }

    final currentHour = (now ?? DateTime.now()).hour;
    final hourDiff = _wrappedHourDiff(currentHour, bestHour);
    final isActiveNow = hourDiff <= 1;

    final windowLabel = _windowLabel(bestHour);
    final anchorLabel = _hourLabel(bestHour);

    return RiskyTimeInsight(
      hasEnoughData: true,
      isActiveNow: isActiveNow,
      anchorHour: bestHour,
      windowLabel: windowLabel,
      anchorLabel: anchorLabel,
      profileSummary:
          'Your logs lean toward $windowLabel, especially around $anchorLabel.',
      activeHeadline: '$windowLabel looks like a harder window.',
      activeBody: isActiveNow
          ? 'This is one of your harder hours. Pause before the usual stop.'
          : 'Your logs point to risk around $anchorLabel. Keep extra distance during this window.',
    );
  }

  static int _wrappedHourDiff(int a, int b) {
    final raw = (a - b).abs();
    return raw <= 12 ? raw : 24 - raw;
  }

  static String _windowLabel(int hour) {
    if (hour >= 5 && hour <= 11) {
      return 'Morning';
    }
    if (hour >= 12 && hour <= 16) {
      return 'Afternoon';
    }
    if (hour >= 17 && hour <= 21) {
      return 'Evening';
    }
    return 'Late night';
  }

  static String _hourLabel(int hour) {
    final normalized = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    return '$normalized:00 $suffix';
  }
}
