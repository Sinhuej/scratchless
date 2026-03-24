import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/purchase_log.dart';
import '../../shared/widgets/app_card.dart';

class StatsScreen extends StatelessWidget {
  final List<PurchaseLog> logs;
  final double monthlySpendEstimate;
  final double estimatedCashKept;

  const StatsScreen({
    super.key,
    required this.logs,
    required this.monthlySpendEstimate,
    required this.estimatedCashKept,
  });

  @override
  Widget build(BuildContext context) {
    final totalSpent = logs.fold<double>(
      0,
      (sum, log) => sum + log.amount,
    );

    final purchaseCount = logs.length;
    final triggerWindow = _buildRiskWindow(logs);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress snapshot',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$${estimatedCashKept.toStringAsFixed(0)} estimated cash kept',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${totalSpent.toStringAsFixed(0)} logged spent so far',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.mutedText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${monthlySpendEstimate.toStringAsFixed(0)} monthly starting estimate',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.mutedText,
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
                  'Behavior insight',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  triggerWindow,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This becomes more useful as you honestly log purchases and notes.',
                  style: TextStyle(
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
                  'Recent entries',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (purchaseCount == 0)
                  const Text(
                    'No purchases logged yet.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  ...logs.take(8).map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 10, color: AppTheme.accent),
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
                                    color: AppTheme.mutedText,
                                    fontSize: 13,
                                  ),
                                ),
                                if (log.note != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      log.note!,
                                      style: const TextStyle(
                                        color: AppTheme.mutedText,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
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

  static String _buildRiskWindow(List<PurchaseLog> logs) {
    if (logs.isEmpty) {
      return 'No trigger pattern yet';
    }

    final Map<String, int> buckets = {
      'Morning is your lightest risk window right now.': 0,
      'Afternoon looks like a recurring purchase window.': 0,
      'Evening looks like your strongest purchase window.': 0,
      'Late night may be a vulnerable purchase window.': 0,
    };

    for (final log in logs) {
      final hour = log.createdAt.hour;
      if (hour >= 5 && hour < 12) {
        buckets['Morning is your lightest risk window right now.'] =
            buckets['Morning is your lightest risk window right now.']! + 1;
      } else if (hour >= 12 && hour < 17) {
        buckets['Afternoon looks like a recurring purchase window.'] =
            buckets['Afternoon looks like a recurring purchase window.']! + 1;
      } else if (hour >= 17 && hour < 22) {
        buckets['Evening looks like your strongest purchase window.'] =
            buckets['Evening looks like your strongest purchase window.']! + 1;
      } else {
        buckets['Late night may be a vulnerable purchase window.'] =
            buckets['Late night may be a vulnerable purchase window.']! + 1;
      }
    }

    final sorted = buckets.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
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
