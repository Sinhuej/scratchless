import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../core/services/weekly_summary_service.dart';

class SimpleSpendChart extends StatelessWidget {
  final List<DailySpendPoint> points;

  const SimpleSpendChart({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final maxAmount = points.isEmpty
        ? 0.0
        : points
            .map((point) => point.amount)
            .reduce((a, b) => a > b ? a : b);

    return LayoutBuilder(
      builder: (context, constraints) {
        const double topLabelHeight = 18;
        const double topGap = 6;
        const double bottomGap = 8;
        const double dayLabelHeight = 16;

        final usableBarArea = constraints.maxHeight -
            topLabelHeight -
            topGap -
            bottomGap -
            dayLabelHeight;

        final safeBarArea = usableBarArea < 24 ? 24.0 : usableBarArea;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: points.map((point) {
            final ratio = maxAmount <= 0 ? 0.0 : point.amount / maxAmount;

            final barHeight = point.amount <= 0
                ? 8.0
                : (safeBarArea * (0.18 + (ratio * 0.82)));

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: topLabelHeight,
                      child: Center(
                        child: Text(
                          point.amount > 0
                              ? '\$${point.amount.toStringAsFixed(0)}'
                              : '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: topGap),
                    SizedBox(
                      height: safeBarArea,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: point.amount > 0
                                ? AppTheme.accent
                                : Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: bottomGap),
                    SizedBox(
                      height: dayLabelHeight,
                      child: Center(
                        child: Text(
                          _dayLabel(point.day.weekday),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  static String _dayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'M';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'W';
      case DateTime.thursday:
        return 'T';
      case DateTime.friday:
        return 'F';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'S';
      default:
        return '?';
    }
  }
}
