class MoneyComparison {
  final String label;
  final String valueText;

  const MoneyComparison({
    required this.label,
    required this.valueText,
  });
}

class MoneyConverterReport {
  final double amount;
  final String headline;
  final List<MoneyComparison> comparisons;

  const MoneyConverterReport({
    required this.amount,
    required this.headline,
    required this.comparisons,
  });
}

class MoneyConverterService {
  static const List<_ConverterTemplate> _templates = [
    _ConverterTemplate(
      label: 'coffee runs',
      unitCost: 4,
    ),
    _ConverterTemplate(
      label: 'fast-food meals',
      unitCost: 10,
    ),
    _ConverterTemplate(
      label: 'takeout nights',
      unitCost: 25,
    ),
    _ConverterTemplate(
      label: 'movie tickets',
      unitCost: 15,
    ),
    _ConverterTemplate(
      label: 'streaming months',
      unitCost: 10,
    ),
    _ConverterTemplate(
      label: 'grocery bag trips',
      unitCost: 25,
    ),
    _ConverterTemplate(
      label: 'phone bill chunks',
      unitCost: 50,
    ),
  ];

  static MoneyConverterReport build(double amount) {
    final safeAmount = amount < 0 ? 0.0 : amount;

    if (safeAmount <= 0) {
      return const MoneyConverterReport(
        amount: 0,
        headline: 'No amount available yet',
        comparisons: [],
      );
    }

    final comparisons = _templates.map((template) {
      final units = safeAmount / template.unitCost;
      return MoneyComparison(
        label: template.label,
        valueText: _formatUnits(units),
      );
    }).toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    return MoneyConverterReport(
      amount: safeAmount,
      headline:
          '\$${safeAmount.toStringAsFixed(0)} could roughly become something more real.',
      comparisons: comparisons,
    );
  }

  static String _formatUnits(double value) {
    if (value >= 10) {
      return value.toStringAsFixed(0);
    }

    if (value >= 2) {
      return value.toStringAsFixed(1);
    }

    if (value >= 1) {
      return value.toStringAsFixed(1);
    }

    return 'part of 1';
  }
}

class _ConverterTemplate {
  final String label;
  final double unitCost;

  const _ConverterTemplate({
    required this.label,
    required this.unitCost,
  });
}
