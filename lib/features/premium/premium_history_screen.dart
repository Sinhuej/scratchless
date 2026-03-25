import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/purchase_log.dart';
import '../../core/services/thirty_day_insight_service.dart';
import '../../shared/widgets/app_card.dart';
import 'widgets/thirty_day_spend_chart.dart';

class PremiumHistoryScreen extends StatelessWidget {
  final List<PurchaseLog> logs;

  const PremiumHistoryScreen({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    final insight = ThirtyDayInsightService.build(logs: logs);

    return Scaffold(
      appBar: AppBar(
        title: const Text('30-day insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '30-day snapshot',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  children: [
                    _metric(
                      label: 'Spent',
                      value: '\$${insight.totalSpent.toStringAsFixed(0)}',
                    ),
                    _metric(
                      label: 'Purchases',
                      value: '${insight.purchaseCount}',
                    ),
                    _metric(
                      label: 'Avg entry',
                      value: '\$${insight.averagePurchaseAmount.toStringAsFixed(0)}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Top purchase window: ${insight.topTimeWindow}',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '30-day trigger breakdown',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (insight.triggerBreakdown.isEmpty)
                  const Text(
                    'No repeated trigger tags yet in the last 30 days. Logging tags will make this more useful.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedText,
                    ),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: insight.triggerBreakdown.map((item) {
                      return Chip(
                        label: Text('${item.label} · ${item.count}'),
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '30-day spend trend',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ThirtyDaySpendChart(
                    points: insight.spendPoints,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Longer history view (${insight.recentLogs.length} entries)',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (insight.recentLogs.isEmpty)
                  const Text(
                    'No purchase entries in the last 30 days.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  ...insight.recentLogs.map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 10,
                            color: AppTheme.accent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${log.amount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  _formatDateTime(log.createdAt),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.mutedText,
                                  ),
                                ),
                                if (log.tags.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: log.tags.map((tag) {
                                      return Chip(
                                        label: Text(tag),
                                        visualDensity: VisualDensity.compact,
                                      );
                                    }).toList(),
                                  ),
                                ],
                                if (log.note != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    log.note!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.mutedText,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _metric({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
            ? dateTime.hour - 12
            : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}  $hour:$minute $suffix';
  }
}
