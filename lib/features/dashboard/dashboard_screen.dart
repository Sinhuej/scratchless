import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/purchase_log.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../logging/purchase_log_sheet.dart';
import '../urge/urge_mode_screen.dart';
import 'widgets/primary_urge_button.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  final int currentStreakDays;
  final int urgesDefeated;
  final double averageSpend;
  final double estimatedCashKept;
  final double totalSpent;
  final double monthlySpendEstimate;
  final List<PurchaseLog> logs;
  final void Function(double amount, String? note) onLogPurchase;
  final VoidCallback onCompleteUrgeSession;

  const DashboardScreen({
    super.key,
    required this.currentStreakDays,
    required this.urgesDefeated,
    required this.averageSpend,
    required this.estimatedCashKept,
    required this.totalSpent,
    required this.monthlySpendEstimate,
    required this.logs,
    required this.onLogPurchase,
    required this.onCompleteUrgeSession,
  });

  @override
  Widget build(BuildContext context) {
    final lastLog = logs.isEmpty ? null : logs.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ScratchLess'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          StatCard(
            label: 'Ticket-free streak',
            value: '$currentStreakDays day${currentStreakDays == 1 ? '' : 's'}',
            icon: Icons.local_fire_department_rounded,
            subtitle: 'Based on your last logged purchase.',
          ),
          const SizedBox(height: 12),
          StatCard(
            label: 'Estimated cash kept',
            value: '\$${estimatedCashKept.toStringAsFixed(0)}',
            icon: Icons.savings_rounded,
            subtitle: 'Based on urge wins and your average spend.',
          ),
          const SizedBox(height: 12),
          StatCard(
            label: 'Urges interrupted',
            value: '$urgesDefeated',
            icon: Icons.shield_rounded,
            subtitle: 'Every interruption matters.',
          ),
          const SizedBox(height: 12),
          StatCard(
            label: 'Logged spend so far',
            value: '\$${totalSpent.toStringAsFixed(0)}',
            icon: Icons.receipt_long_rounded,
            subtitle: 'Track honestly. No shame.',
          ),
          const SizedBox(height: 18),
          PrimaryUrgeButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => UrgeModeScreen(
                    averageSpend: averageSpend,
                    onComplete: onCompleteUrgeSession,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Log a scratch-off',
            isPrimary: false,
            icon: Icons.edit_rounded,
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  return PurchaseLogSheet(
                    onSave: onLogPurchase,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Starting estimate',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${monthlySpendEstimate.toStringAsFixed(0)} per month',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'That estimate came from your onboarding answers. It becomes more useful as you log real behavior.',
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
                  'Latest check-in',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (lastLog == null)
                  const Text(
                    'No purchases logged yet. That is a good chance to start clean and honest.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${lastLog.amount.toStringAsFixed(0)} logged',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(lastLog.createdAt),
                        style: const TextStyle(
                          color: AppTheme.mutedText,
                          fontSize: 13,
                        ),
                      ),
                      if (lastLog.note != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          lastLog.note!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.mutedText,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
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
