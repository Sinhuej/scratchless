import '../models/purchase_log.dart';
import '../models/spend_cap_plan.dart';

class SpendCapProgress {
  final double todaySpent;
  final double weekSpent;
  final double dailyProgress;
  final double weeklyProgress;
  final bool dailyExceeded;
  final bool weeklyExceeded;

  const SpendCapProgress({
    required this.todaySpent,
    required this.weekSpent,
    required this.dailyProgress,
    required this.weeklyProgress,
    required this.dailyExceeded,
    required this.weeklyExceeded,
  });
}

class SpendCapService {
  static const double _pressureThreshold = 0.8;

  static SpendCapProgress build({
    required List<PurchaseLog> logs,
    required SpendCapPlan plan,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final today = DateTime(current.year, current.month, current.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    double todaySpent = 0;
    double weekSpent = 0;

    for (final log in logs) {
      final created = log.createdAt;
      final logDay = DateTime(created.year, created.month, created.day);

      if (logDay == today) {
        todaySpent += log.amount;
      }

      if (!logDay.isBefore(weekStart) && logDay.isBefore(weekEnd)) {
        weekSpent += log.amount;
      }
    }

    final dailyProgress = plan.dailyCapEnabled && plan.dailyCapAmount > 0
        ? (todaySpent / plan.dailyCapAmount).clamp(0.0, 1.0)
        : 0.0;

    final weeklyProgress = plan.weeklyCapEnabled && plan.weeklyCapAmount > 0
        ? (weekSpent / plan.weeklyCapAmount).clamp(0.0, 1.0)
        : 0.0;

    return SpendCapProgress(
      todaySpent: todaySpent,
      weekSpent: weekSpent,
      dailyProgress: dailyProgress,
      weeklyProgress: weeklyProgress,
      dailyExceeded:
          plan.dailyCapEnabled && todaySpent > plan.dailyCapAmount,
      weeklyExceeded:
          plan.weeklyCapEnabled && weekSpent > plan.weeklyCapAmount,
    );
  }

  static String dailyMessage({
    required SpendCapPlan plan,
    required SpendCapProgress progress,
  }) {
    if (!plan.dailyCapEnabled) {
      return 'Daily cap is off.';
    }

    if (progress.dailyExceeded) {
      return 'Today is over the daily cap.';
    }

    final remaining =
        (plan.dailyCapAmount - progress.todaySpent).clamp(0.0, double.infinity);
    return '\$${remaining.toStringAsFixed(0)} left in today’s cap.';
  }

  static String weeklyMessage({
    required SpendCapPlan plan,
    required SpendCapProgress progress,
  }) {
    if (!plan.weeklyCapEnabled) {
      return 'Weekly cap is off.';
    }

    if (progress.weeklyExceeded) {
      return 'This week is over the weekly cap.';
    }

    final remaining =
        (plan.weeklyCapAmount - progress.weekSpent).clamp(0.0, double.infinity);
    return '\$${remaining.toStringAsFixed(0)} left in this week’s cap.';
  }

  static bool dailyNear({
    required SpendCapPlan plan,
    required SpendCapProgress progress,
  }) {
    return plan.dailyCapEnabled &&
        !progress.dailyExceeded &&
        plan.dailyCapAmount > 0 &&
        progress.dailyProgress >= _pressureThreshold;
  }

  static bool weeklyNear({
    required SpendCapPlan plan,
    required SpendCapProgress progress,
  }) {
    return plan.weeklyCapEnabled &&
        !progress.weeklyExceeded &&
        plan.weeklyCapAmount > 0 &&
        progress.weeklyProgress >= _pressureThreshold;
  }

  static bool hasPressureWarning({
    required SpendCapPlan plan,
    required SpendCapProgress progress,
  }) {
    return progress.dailyExceeded ||
        progress.weeklyExceeded ||
        dailyNear(plan: plan, progress: progress) ||
        weeklyNear(plan: plan, progress: progress);
  }

  static String pressureHeadline({
    required SpendCapPlan plan,
    required SpendCapProgress progress,
  }) {
    final nearDaily = dailyNear(plan: plan, progress: progress);
    final nearWeekly = weeklyNear(plan: plan, progress: progress);

    if (progress.dailyExceeded && progress.weeklyExceeded) {
      return 'You are over both spending caps.';
    }
    if (progress.dailyExceeded) {
      return 'You crossed today’s cap.';
    }
    if (progress.weeklyExceeded) {
      return 'You crossed this week’s cap.';
    }
    if (nearDaily && nearWeekly) {
      return 'You are getting close to both caps.';
    }
    if (nearDaily) {
      return 'You are getting close to today’s cap.';
    }
    if (nearWeekly) {
      return 'You are getting close to this week’s cap.';
    }

    return 'Caps look stable right now.';
  }

  static String pressureBody({
    required SpendCapPlan plan,
    required SpendCapProgress progress,
  }) {
    final nearDaily = dailyNear(plan: plan, progress: progress);
    final nearWeekly = weeklyNear(plan: plan, progress: progress);

    if (progress.dailyExceeded && progress.weeklyExceeded) {
      return '${dailyMessage(plan: plan, progress: progress)} ${weeklyMessage(plan: plan, progress: progress)}';
    }
    if (progress.dailyExceeded) {
      return dailyMessage(plan: plan, progress: progress);
    }
    if (progress.weeklyExceeded) {
      return weeklyMessage(plan: plan, progress: progress);
    }
    if (nearDaily && nearWeekly) {
      return '${dailyMessage(plan: plan, progress: progress)} ${weeklyMessage(plan: plan, progress: progress)}';
    }
    if (nearDaily) {
      return dailyMessage(plan: plan, progress: progress);
    }
    if (nearWeekly) {
      return weeklyMessage(plan: plan, progress: progress);
    }

    return 'Caps look stable right now.';
  }
}
