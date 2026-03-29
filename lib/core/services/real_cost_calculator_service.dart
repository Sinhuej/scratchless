class RealCostWindow {
  final String id;
  final String label;
  final double amount;
  final String description;

  const RealCostWindow({
    required this.id,
    required this.label,
    required this.amount,
    required this.description,
  });
}

class RealCostComparison {
  final String label;
  final String valueText;

  const RealCostComparison({
    required this.label,
    required this.valueText,
  });
}

class RealCostReport {
  final String headline;
  final String body;
  final List<RealCostComparison> comparisons;

  const RealCostReport({
    required this.headline,
    required this.body,
    required this.comparisons,
  });
}

class RealCostCalculatorService {
  static const List<_CostTemplate> _templates = [
    _CostTemplate(label: 'fast-food meals', unitCost: 10),
    _CostTemplate(label: 'takeout nights', unitCost: 25),
    _CostTemplate(label: 'grocery bag trips', unitCost: 25),
    _CostTemplate(label: 'phone bill chunks', unitCost: 50),
    _CostTemplate(label: 'tanks of gas', unitCost: 40),
    _CostTemplate(label: 'streaming months', unitCost: 10),
    _CostTemplate(label: 'school-supply trips', unitCost: 35),
  ];

  static List<RealCostWindow> buildWindows({
    required double weeklySpent,
    required double monthlyEstimate,
    required double totalLogged,
  }) {
    final projectedYearly = monthlyEstimate * 12;

    return [
      RealCostWindow(
        id: 'week',
        label: 'This week logged',
        amount: weeklySpent,
        description: 'What tickets cost this week alone.',
      ),
      RealCostWindow(
        id: 'month',
        label: 'Monthly estimate',
        amount: monthlyEstimate,
        description: 'Based on your current baseline pattern.',
      ),
      RealCostWindow(
        id: 'total',
        label: 'Total logged',
        amount: totalLogged,
        description: 'What your entered history has already cost.',
      ),
      RealCostWindow(
        id: 'year',
        label: 'Projected yearly cost',
        amount: projectedYearly,
        description: 'What the pattern could become over a year.',
      ),
    ];
  }

  static RealCostReport build({
    required RealCostWindow window,
  }) {
    final safeAmount = window.amount < 0 ? 0.0 : window.amount;

    if (safeAmount <= 0) {
      return RealCostReport(
        headline: '${window.label} has no meaningful amount yet',
        body: window.description,
        comparisons: const [],
      );
    }

    final comparisons = _templates.map((template) {
      final units = safeAmount / template.unitCost;
      return RealCostComparison(
        label: template.label,
        valueText: _formatUnits(units),
      );
    }).toList();

    return RealCostReport(
      headline:
          '\$${safeAmount.toStringAsFixed(0)} is what this pattern can pull out of real life.',
      body: window.description,
      comparisons: comparisons,
    );
  }

  static String _formatUnits(double value) {
    if (value >= 10) {
      return value.toStringAsFixed(0);
    }
    if (value >= 1) {
      return value.toStringAsFixed(1);
    }
    return 'part of 1';
  }
}

class _CostTemplate {
  final String label;
  final double unitCost;

  const _CostTemplate({
    required this.label,
    required this.unitCost,
  });
}
