import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/premium_state.dart';
import '../../core/models/purchase_log.dart';
import '../../core/services/feature_gate_service.dart';
import '../../core/services/trigger_insight_service.dart';
import '../../core/services/weekly_summary_service.dart';
import '../../features/premium/export_summary_screen.dart';
import '../../features/premium/premium_history_screen.dart';
import '../../features/premium/premium_screen.dart';
import '../../features/premium/weekly_reflection_screen.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../logging/purchase_log_sheet.dart';
import 'widgets/simple_spend_chart.dart';

class StatsScreen extends StatelessWidget {
  final List<PurchaseLog> logs;
  final int currentStreakDays;
  final int bestStreakDays;
  final double monthlySpendEstimate;
  final double estimatedCashKept;
  final WeeklySummary weeklySummary;
  final PremiumState premiumState;
  final VoidCallback onStartPremiumTrial;
  final void Function(String id, double amount, String? note, List<String> tags)
      onEditPurchase;
  final void Function(String id) onDeletePurchase;

  const StatsScreen({
    super.key,
    required this.logs,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.monthlySpendEstimate,
    required this.estimatedCashKept,
    required this.weeklySummary,
    required this.premiumState,
    required this.onStartPremiumTrial,
    required this.onEditPurchase,
    required this.onDeletePurchase,
  });

  void _showEditSheet(BuildContext context, PurchaseLog log) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return PurchaseLogSheet(
          initialLog: log,
          onSave: (amount, note, tags) {
            onEditPurchase(log.id, amount, note, tags);
          },
          onDelete: () {
            onDeletePurchase(log.id);
          },
        );
      },
    );
  }

  void _openPremiumScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PremiumScreen(
          premiumState: premiumState,
          onStartTrial: onStartPremiumTrial,
        ),
      ),
    );
  }

  void _openPremiumHistoryScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PremiumHistoryScreen(
          logs: logs,
        ),
      ),
    );
  }

  void _openWeeklyReflectionScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => WeeklyReflectionScreen(
          weeklySummary: weeklySummary,
          logs: logs,
        ),
      ),
    );
  }

  void _openExportSummaryScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ExportSummaryScreen(
          weeklySummary: weeklySummary,
          logs: logs,
          currentStreakDays: currentStreakDays,
          bestStreakDays: bestStreakDays,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = logs.fold<double>(
      0,
      (sum, log) => sum + log.amount,
    );

    final purchaseCount = logs.length;
    final triggerWindow = TriggerInsightService.riskWindow(logs);
    final noteInsight = TriggerInsightService.noteInsight(logs);

    final advancedUnlocked =
        FeatureGateService.advancedInsightsUnlocked(premiumState);
    final reflectionUnlocked =
        FeatureGateService.reflectionReportsUnlocked(premiumState);
    final exportUnlocked =
        FeatureGateService.exportProgressUnlocked(premiumState);

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
                  'Weekly snapshot',
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
                      value: '\$${weeklySummary.spentThisWeek.toStringAsFixed(0)}',
                    ),
                    _metric(
                      label: 'Kept',
                      value: '\$${weeklySummary.cashKeptThisWeek.toStringAsFixed(0)}',
                    ),
                    _metric(
                      label: 'Purchases',
                      value: '${weeklySummary.purchasesThisWeek}',
                    ),
                    _metric(
                      label: 'Urge wins',
                      value: '${weeklySummary.urgeWinsThisWeek}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  weeklySummary.comparisonMessage,
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Top trigger this week: ${weeklySummary.topTriggerThisWeek}',
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
                  '7-day spend chart',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: SimpleSpendChart(
                    points: weeklySummary.spendPoints,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () {
              if (advancedUnlocked) {
                _openPremiumHistoryScreen(context);
              } else {
                _openPremiumScreen(context);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium insights',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                if (advancedUnlocked) ...[
                  const Text(
                    '30-day trigger breakdown is active.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Open your 30-day insights to see the trigger breakdown and longer history view.',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Open 30-day insights',
                    icon: Icons.insights_rounded,
                    onPressed: () => _openPremiumHistoryScreen(context),
                  ),
                ] else ...[
                  const _LockedLine('30-day trigger breakdown'),
                  const _LockedLine('Longer history view'),
                  const _LockedLine('Weekly reflection report'),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Unlock Premium',
                    icon: Icons.lock_open_rounded,
                    onPressed: () => _openPremiumScreen(context),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () {
              if (reflectionUnlocked) {
                _openWeeklyReflectionScreen(context);
              } else {
                _openPremiumScreen(context);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly reflection report',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                if (reflectionUnlocked) ...[
                  const Text(
                    'Your guided weekly reflection is ready.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Open a calmer interpretation of this week’s spending, triggers, and support signals.',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Open weekly reflection',
                    icon: Icons.auto_awesome_rounded,
                    onPressed: () => _openWeeklyReflectionScreen(context),
                  ),
                ] else ...[
                  const Text(
                    'Premium feature',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Weekly reflection turns raw numbers into guided interpretation in a calmer, more human way.',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Unlock Premium',
                    icon: Icons.lock_open_rounded,
                    onPressed: () => _openPremiumScreen(context),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () {
              if (exportUnlocked) {
                _openExportSummaryScreen(context);
              } else {
                _openPremiumScreen(context);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Exportable progress summary',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                if (exportUnlocked) ...[
                  const Text(
                    'Your share-ready progress summary is ready.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Copy a calmer summary for notes, text messages, or accountability check-ins.',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Open export summary',
                    icon: Icons.ios_share_rounded,
                    onPressed: () => _openExportSummaryScreen(context),
                  ),
                ] else ...[
                  const Text(
                    'Premium feature',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Export a clean summary of streaks, spending, trigger patterns, and progress for accountability.',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: 'Unlock Premium',
                    icon: Icons.lock_open_rounded,
                    onPressed: () => _openPremiumScreen(context),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
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
                  'Streaks',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current streak: $currentStreakDays day${currentStreakDays == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Best streak: $bestStreakDays day${bestStreakDays == 1 ? '' : 's'}',
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
                Text(
                  noteInsight,
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
                    return InkWell(
                      onTap: () {
                        _showEditSheet(context, log);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
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
                                      color: AppTheme.mutedText,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Tap to edit or delete.',
                                    style: TextStyle(
                                      color: AppTheme.mutedText,
                                      fontSize: 12,
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

class _LockedLine extends StatelessWidget {
  final String text;

  const _LockedLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.lock_rounded,
            size: 16,
            color: AppTheme.mutedText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
