import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';
import '../../../core/services/thirty_day_insight_service.dart';

class ThirtyDaySpendChart extends StatelessWidget {
  final List<ThirtyDaySpendPoint> points;

  const ThirtyDaySpendChart({
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
        const double barAreaHeight = 110;
        const double labelHeight = 18;
        const double columnWidth = 22;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(points.length, (index) {
                final point = points[index];
                final ratio = maxAmount <= 0 ? 0.0 : point.amount / maxAmount;
                final barHeight =
                    point.amount <= 0 ? 6.0 : 10 + (ratio * (barAreaHeight - 10));

                return SizedBox(
                  width: columnWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: barAreaHeight,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 14,
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
                      const SizedBox(height: 8),
                      SizedBox(
                        height: labelHeight,
                        child: Center(
                          child: Text(
                            _showLabel(index, points.length)
                                ? '${point.day.day}'
                                : '',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.mutedText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  static bool _showLabel(int index, int length) {
    if (index == length - 1) {
      return true;
    }
    return index % 5 == 0;
  }
}
