import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/spend_cap_plan.dart';
import '../../core/services/spend_cap_service.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class GoalsScreen extends StatefulWidget {
  final SpendCapPlan plan;
  final SpendCapProgress progress;
  final ValueChanged<SpendCapPlan> onSavePlan;

  const GoalsScreen({
    super.key,
    required this.plan,
    required this.progress,
    required this.onSavePlan,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late bool _dailyEnabled;
  late bool _weeklyEnabled;
  late final TextEditingController _dailyController;
  late final TextEditingController _weeklyController;

  @override
  void initState() {
    super.initState();
    _dailyEnabled = widget.plan.dailyCapEnabled;
    _weeklyEnabled = widget.plan.weeklyCapEnabled;
    _dailyController = TextEditingController(
      text: _formatAmount(widget.plan.dailyCapAmount),
    );
    _weeklyController = TextEditingController(
      text: _formatAmount(widget.plan.weeklyCapAmount),
    );
  }

  @override
  void dispose() {
    _dailyController.dispose();
    _weeklyController.dispose();
    super.dispose();
  }

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  double? _parseAmount(String raw) {
    final normalized = raw.trim().replaceAll(',', '');
    if (normalized.isEmpty) {
      return null;
    }
    final parsed = double.tryParse(normalized);
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  void _save() {
    final dailyAmount = _parseAmount(_dailyController.text);
    final weeklyAmount = _parseAmount(_weeklyController.text);

    if (_dailyEnabled && dailyAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid daily cap amount.'),
        ),
      );
      return;
    }

    if (_weeklyEnabled && weeklyAmount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid weekly cap amount.'),
        ),
      );
      return;
    }

    final nextPlan = widget.plan.copyWith(
      dailyCapEnabled: _dailyEnabled,
      dailyCapAmount: dailyAmount ?? widget.plan.dailyCapAmount,
      weeklyCapEnabled: _weeklyEnabled,
      weeklyCapAmount: weeklyAmount ?? widget.plan.weeklyCapAmount,
    );

    widget.onSavePlan(nextPlan);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Spend cap plan saved'),
      ),
    );
  }

  Widget _progressCard({
    required String title,
    required bool enabled,
    required double spent,
    required double cap,
    required double progress,
    required bool exceeded,
    required String message,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            enabled
                ? '\$${spent.toStringAsFixed(0)} / \$${cap.toStringAsFixed(0)}'
                : 'Not active',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: enabled ? progress : 0,
              backgroundColor: Colors.white.withOpacity(0.08),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            exceeded ? 'Cap exceeded.' : message,
            style: const TextStyle(
              color: AppTheme.mutedText,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.progress;
    final previewPlan = widget.plan.copyWith(
      dailyCapEnabled: _dailyEnabled,
      weeklyCapEnabled: _weeklyEnabled,
      dailyCapAmount: _parseAmount(_dailyController.text) ?? widget.plan.dailyCapAmount,
      weeklyCapAmount: _parseAmount(_weeklyController.text) ?? widget.plan.weeklyCapAmount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & spend caps'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan ahead, not just after',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use simple caps to put a boundary around risky spending.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This is a planning tool, not a perfection test.',
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
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Use daily cap'),
                  subtitle: const Text('Set a daily spending ceiling.'),
                  value: _dailyEnabled,
                  onChanged: (value) {
                    setState(() {
                      _dailyEnabled = value;
                    });
                  },
                ),
                if (_dailyEnabled) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dailyController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Daily cap amount',
                      prefixText: '\$',
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Use weekly cap'),
                  subtitle: const Text('Set a weekly spending ceiling.'),
                  value: _weeklyEnabled,
                  onChanged: (value) {
                    setState(() {
                      _weeklyEnabled = value;
                    });
                  },
                ),
                if (_weeklyEnabled) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: _weeklyController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Weekly cap amount',
                      prefixText: '\$',
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                AppButton(
                  label: 'Save plan',
                  icon: Icons.check_rounded,
                  onPressed: _save,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _progressCard(
            title: 'Today’s cap progress',
            enabled: previewPlan.dailyCapEnabled,
            spent: progress.todaySpent,
            cap: previewPlan.dailyCapAmount,
            progress: previewPlan.dailyCapEnabled && previewPlan.dailyCapAmount > 0
                ? (progress.todaySpent / previewPlan.dailyCapAmount).clamp(0.0, 1.0)
                : 0,
            exceeded: previewPlan.dailyCapEnabled &&
                progress.todaySpent > previewPlan.dailyCapAmount,
            message: SpendCapService.dailyMessage(
              plan: previewPlan,
              progress: SpendCapProgress(
                todaySpent: progress.todaySpent,
                weekSpent: progress.weekSpent,
                dailyProgress: previewPlan.dailyCapEnabled && previewPlan.dailyCapAmount > 0
                    ? (progress.todaySpent / previewPlan.dailyCapAmount).clamp(0.0, 1.0)
                    : 0,
                weeklyProgress: previewPlan.weeklyCapEnabled && previewPlan.weeklyCapAmount > 0
                    ? (progress.weekSpent / previewPlan.weeklyCapAmount).clamp(0.0, 1.0)
                    : 0,
                dailyExceeded: previewPlan.dailyCapEnabled &&
                    progress.todaySpent > previewPlan.dailyCapAmount,
                weeklyExceeded: previewPlan.weeklyCapEnabled &&
                    progress.weekSpent > previewPlan.weeklyCapAmount,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _progressCard(
            title: 'This week’s cap progress',
            enabled: previewPlan.weeklyCapEnabled,
            spent: progress.weekSpent,
            cap: previewPlan.weeklyCapAmount,
            progress: previewPlan.weeklyCapEnabled && previewPlan.weeklyCapAmount > 0
                ? (progress.weekSpent / previewPlan.weeklyCapAmount).clamp(0.0, 1.0)
                : 0,
            exceeded: previewPlan.weeklyCapEnabled &&
                progress.weekSpent > previewPlan.weeklyCapAmount,
            message: SpendCapService.weeklyMessage(
              plan: previewPlan,
              progress: SpendCapProgress(
                todaySpent: progress.todaySpent,
                weekSpent: progress.weekSpent,
                dailyProgress: previewPlan.dailyCapEnabled && previewPlan.dailyCapAmount > 0
                    ? (progress.todaySpent / previewPlan.dailyCapAmount).clamp(0.0, 1.0)
                    : 0,
                weeklyProgress: previewPlan.weeklyCapEnabled && previewPlan.weeklyCapAmount > 0
                    ? (progress.weekSpent / previewPlan.weeklyCapAmount).clamp(0.0, 1.0)
                    : 0,
                dailyExceeded: previewPlan.dailyCapEnabled &&
                    progress.todaySpent > previewPlan.dailyCapAmount,
                weeklyExceeded: previewPlan.weeklyCapEnabled &&
                    progress.weekSpent > previewPlan.weeklyCapAmount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
