import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/services/real_cost_calculator_service.dart';
import '../../shared/widgets/app_card.dart';

class RealCostCalculatorScreen extends StatefulWidget {
  final double weeklySpent;
  final double monthlyEstimate;
  final double totalLogged;

  const RealCostCalculatorScreen({
    super.key,
    required this.weeklySpent,
    required this.monthlyEstimate,
    required this.totalLogged,
  });

  @override
  State<RealCostCalculatorScreen> createState() =>
      _RealCostCalculatorScreenState();
}

class _RealCostCalculatorScreenState extends State<RealCostCalculatorScreen> {
  late final List<RealCostWindow> _windows;
  late String _selectedWindowId;

  @override
  void initState() {
    super.initState();

    _windows = RealCostCalculatorService.buildWindows(
      weeklySpent: widget.weeklySpent,
      monthlyEstimate: widget.monthlyEstimate,
      totalLogged: widget.totalLogged,
    );

    final firstUseful = _windows.firstWhere(
      (window) => window.amount > 0,
      orElse: () => _windows.first,
    );

    _selectedWindowId = firstUseful.id;
  }

  @override
  Widget build(BuildContext context) {
    final selectedWindow = _windows.firstWhere(
      (window) => window.id == _selectedWindowId,
    );

    final report = RealCostCalculatorService.build(
      window: selectedWindow,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Real cost calculator'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What this habit is really costing',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This is a consequence view, not an urge interrupter.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use this screen to see what the pattern adds up to over time in real-life tradeoffs.',
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
                  'Choose a time window',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _windows.map((window) {
                    final selected = _selectedWindowId == window.id;
                    return ChoiceChip(
                      label: Text(
                        '${window.label}  •  \$${window.amount.toStringAsFixed(0)}',
                      ),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedWindowId = window.id;
                        });
                      },
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
                Text(
                  selectedWindow.label,
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.headline,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  report.body,
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
                  'Real-life tradeoffs',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (report.comparisons.isEmpty)
                  const Text(
                    'No meaningful amount available yet.',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  )
                else
                  ...report.comparisons.map((comparison) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.circle,
                              size: 8,
                              color: AppTheme.accent,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${comparison.valueText} ${comparison.label}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
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
}
