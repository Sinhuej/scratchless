import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class OnboardingResult {
  final int frequencyPerWeek;
  final double averageSpend;
  final String goal;

  const OnboardingResult({
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.goal,
  });
}

class OnboardingScreen extends StatefulWidget {
  final ValueChanged<OnboardingResult> onComplete;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  int _frequencyPerWeek = 3;
  double _averageSpend = 10;
  String _goal = 'Spend less';

  final Map<int, String> _frequencyLabels = const {
    1: '1–2 times per week',
    3: '3–5 times per week',
    7: 'About daily',
    14: 'Multiple times per day',
  };

  final List<double> _spendOptions = const [5, 10, 20, 50];

  final List<String> _goalOptions = const [
    'Spend less',
    'Stop completely',
    'Track for now',
    'Beat urges in the moment',
  ];

  double get _estimatedMonthlySpend {
    return _frequencyPerWeek * _averageSpend * 4.33;
  }

  bool get _isLastStep => _step == 3;

  void _next() {
    if (_isLastStep) {
      widget.onComplete(
        OnboardingResult(
          frequencyPerWeek: _frequencyPerWeek,
          averageSpend: _averageSpend,
          goal: _goal,
        ),
      );
      return;
    }

    setState(() {
      _step += 1;
    });
  }

  void _back() {
    if (_step == 0) {
      return;
    }

    setState(() {
      _step -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_step + 1) / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ScratchLess'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildStepContent(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Back',
                      isPrimary: false,
                      onPressed: _step == 0 ? null : _back,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: _isLastStep ? 'Start free' : 'Next',
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildFrequencyStep();
      case 1:
        return _buildSpendStep();
      case 2:
        return _buildImpactStep();
      case 3:
        return _buildGoalStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFrequencyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How often do you buy scratch-offs?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'This helps us estimate the real cost and build your starting baseline.',
          style: TextStyle(
            color: AppTheme.mutedText,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 20),
        ..._frequencyLabels.entries.map((entry) {
          final selected = _frequencyPerWeek == entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () {
                setState(() {
                  _frequencyPerWeek = entry.key;
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSpendStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About how much do you spend each time?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pick the amount that feels closest to your usual purchase.',
          style: TextStyle(
            color: AppTheme.mutedText,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _spendOptions.map((amount) {
            final selected = _averageSpend == amount;
            return ChoiceChip(
              label: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('\$${amount.toStringAsFixed(0)}'),
              ),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _averageSpend = amount;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImpactStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Here is your starting estimate',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'This is not for guilt. It is just a clear starting point.',
          style: TextStyle(
            color: AppTheme.mutedText,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estimated monthly spend',
                style: TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '\$${_estimatedMonthlySpend.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Based on $_frequencyPerWeek purchase periods per week at about \$${_averageSpend.toStringAsFixed(0)} each.',
                style: const TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What would help most right now?',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'You can change this later. Start with what feels realistic.',
          style: TextStyle(
            color: AppTheme.mutedText,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 20),
        ..._goalOptions.map((goal) {
          final selected = _goal == goal;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () {
                setState(() {
                  _goal = goal;
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      goal,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
