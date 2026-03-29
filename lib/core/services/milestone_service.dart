import '../models/milestone_state.dart';
import '../models/purchase_log.dart';

enum _MilestoneMetric {
  logs,
  urgeWins,
  bestStreakDays,
  cashKept,
}

class MilestoneCardData {
  final String id;
  final String title;
  final String subtitle;
  final String progressLabel;
  final bool unlocked;
  final bool celebrated;

  const MilestoneCardData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progressLabel,
    required this.unlocked,
    required this.celebrated,
  });
}

class MilestoneService {
  static const List<_MilestoneDefinition> _definitions = [
    _MilestoneDefinition(
      id: 'first_log',
      title: 'First honest log',
      unlockedSubtitle: 'You logged a purchase honestly. That matters.',
      lockedSubtitle: 'Log your first purchase honestly.',
      metric: _MilestoneMetric.logs,
      target: 1,
    ),
    _MilestoneDefinition(
      id: 'three_logs',
      title: 'Three honest check-ins',
      unlockedSubtitle: 'You have started building a real pattern picture.',
      lockedSubtitle: 'Keep logging honestly to build a clearer pattern.',
      metric: _MilestoneMetric.logs,
      target: 3,
    ),
    _MilestoneDefinition(
      id: 'first_urge_win',
      title: 'First urge interrupted',
      unlockedSubtitle: 'You broke the loop once. That is a real win.',
      lockedSubtitle: 'Interrupt one urge without buying.',
      metric: _MilestoneMetric.urgeWins,
      target: 1,
    ),
    _MilestoneDefinition(
      id: 'five_urge_wins',
      title: 'Five urge wins',
      unlockedSubtitle: 'You are building a repeatable pause response.',
      lockedSubtitle: 'Stack a few more urge wins together.',
      metric: _MilestoneMetric.urgeWins,
      target: 5,
    ),
    _MilestoneDefinition(
      id: 'three_day_streak',
      title: '3-day streak',
      unlockedSubtitle: 'Three days is proof that a streak can begin.',
      lockedSubtitle: 'Reach a 3-day best streak.',
      metric: _MilestoneMetric.bestStreakDays,
      target: 3,
    ),
    _MilestoneDefinition(
      id: 'seven_day_streak',
      title: '7-day streak',
      unlockedSubtitle: 'A full week is a serious recovery marker.',
      lockedSubtitle: 'Reach a 7-day best streak.',
      metric: _MilestoneMetric.bestStreakDays,
      target: 7,
    ),
    _MilestoneDefinition(
      id: 'fifty_kept',
      title: '\$50 kept',
      unlockedSubtitle: 'That is real money staying in your life.',
      lockedSubtitle: 'Keep an estimated \$50 instead of spending it.',
      metric: _MilestoneMetric.cashKept,
      target: 50,
    ),
    _MilestoneDefinition(
      id: 'hundred_kept',
      title: '\$100 kept',
      unlockedSubtitle: 'This is becoming financially meaningful progress.',
      lockedSubtitle: 'Keep an estimated \$100 instead of spending it.',
      metric: _MilestoneMetric.cashKept,
      target: 100,
    ),
  ];

  static List<MilestoneCardData> buildItems({
    required List<PurchaseLog> logs,
    required int urgesDefeated,
    required int bestStreakDays,
    required double estimatedCashKept,
    required MilestoneState milestoneState,
  }) {
    return _definitions.map((definition) {
      final value = _metricValue(
        definition.metric,
        logs: logs,
        urgesDefeated: urgesDefeated,
        bestStreakDays: bestStreakDays,
        estimatedCashKept: estimatedCashKept,
      );

      final unlocked = value >= definition.target;

      return MilestoneCardData(
        id: definition.id,
        title: definition.title,
        subtitle:
            unlocked ? definition.unlockedSubtitle : definition.lockedSubtitle,
        progressLabel: _progressText(
          definition.metric,
          value: value,
          target: definition.target,
        ),
        unlocked: unlocked,
        celebrated: milestoneState.isCelebrated(definition.id),
      );
    }).toList();
  }

  static MilestoneCardData? firstUncelebrated(
    List<MilestoneCardData> items,
  ) {
    for (final item in items) {
      if (item.unlocked && !item.celebrated) {
        return item;
      }
    }
    return null;
  }

  static MilestoneCardData? nextLocked(
    List<MilestoneCardData> items,
  ) {
    for (final item in items) {
      if (!item.unlocked) {
        return item;
      }
    }
    return null;
  }

  static int _metricValue(
    _MilestoneMetric metric, {
    required List<PurchaseLog> logs,
    required int urgesDefeated,
    required int bestStreakDays,
    required double estimatedCashKept,
  }) {
    switch (metric) {
      case _MilestoneMetric.logs:
        return logs.length;
      case _MilestoneMetric.urgeWins:
        return urgesDefeated;
      case _MilestoneMetric.bestStreakDays:
        return bestStreakDays;
      case _MilestoneMetric.cashKept:
        return estimatedCashKept.floor();
    }
  }

  static String _progressText(
    _MilestoneMetric metric, {
    required int value,
    required int target,
  }) {
    switch (metric) {
      case _MilestoneMetric.logs:
        return '$value / $target logs';
      case _MilestoneMetric.urgeWins:
        return '$value / $target urge wins';
      case _MilestoneMetric.bestStreakDays:
        return '$value / $target streak days';
      case _MilestoneMetric.cashKept:
        return '\$$value / \$$target kept';
    }
  }
}

class _MilestoneDefinition {
  final String id;
  final String title;
  final String unlockedSubtitle;
  final String lockedSubtitle;
  final _MilestoneMetric metric;
  final int target;

  const _MilestoneDefinition({
    required this.id,
    required this.title,
    required this.unlockedSubtitle,
    required this.lockedSubtitle,
    required this.metric,
    required this.target,
  });
}
