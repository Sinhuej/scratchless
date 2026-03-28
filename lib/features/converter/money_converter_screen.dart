import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/services/money_converter_service.dart';
import '../../shared/widgets/app_card.dart';

class MoneyConverterScreen extends StatefulWidget {
  final double averageSpend;
  final double weeklyCashKept;
  final double estimatedCashKept;
  final double monthlySpendEstimate;

  const MoneyConverterScreen({
    super.key,
    required this.averageSpend,
    required this.weeklyCashKept,
    required this.estimatedCashKept,
    required this.monthlySpendEstimate,
  });

  @override
  State<MoneyConverterScreen> createState() => _MoneyConverterScreenState();
}

class _MoneyConverterScreenState extends State<MoneyConverterScreen> {
  late double _selectedAmount;
  late String _selectedLabel;

  @override
  void initState() {
    super.initState();
    _selectedAmount = widget.averageSpend > 0 ? widget.averageSpend : 10;
    _selectedLabel = 'This urge';
  }

  @override
  Widget build(BuildContext context) {
    final report = MoneyConverterService.build(_selectedAmount);

    final options = <_MoneyOption>[
      _MoneyOption('This urge', widget.averageSpend),
      _MoneyOption('This week kept', widget.weeklyCashKept),
      _MoneyOption('Total kept', widget.estimatedCashKept),
      _MoneyOption('Monthly estimate', widget.monthlySpendEstimate),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('What that money could buy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Turn the urge into something real',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This is not exact pricing. It is a practical way to make the money feel real again.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use it as an interruption tool, not a calculator.',
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
                  'Choose an amount',
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
                  children: options.map((option) {
                    final selected = _selectedLabel == option.label;
                    return ChoiceChip(
                      label: Text(
                        '${option.label}  •  \$${option.amount.toStringAsFixed(0)}',
                      ),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          _selectedLabel = option.label;
                          _selectedAmount = option.amount;
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
                  _selectedLabel,
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
                const SizedBox(height: 14),
                if (report.comparisons.isEmpty)
                  const Text(
                    'No comparisons available yet.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.mutedText,
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

class _MoneyOption {
  final String label;
  final double amount;

  const _MoneyOption(this.label, this.amount);
}
