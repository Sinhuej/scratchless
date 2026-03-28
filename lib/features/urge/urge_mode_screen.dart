import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/stop_reason.dart';
import '../../core/services/money_converter_service.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class UrgeModeScreen extends StatefulWidget {
  final double averageSpend;
  final VoidCallback onComplete;
  final VoidCallback onOpenCopingStrategies;
  final VoidCallback onOpenNearMissEducation;
  final List<StopReason> reasons;

  const UrgeModeScreen({
    super.key,
    required this.averageSpend,
    required this.onComplete,
    required this.onOpenCopingStrategies,
    required this.onOpenNearMissEducation,
    required this.reasons,
  });

  @override
  State<UrgeModeScreen> createState() => _UrgeModeScreenState();
}

class _UrgeModeScreenState extends State<UrgeModeScreen> {
  int _secondsLeft = 20;
  bool _completed = false;

  static const List<String> _starterReasons = <String>[
    'I want to keep more money for real life.',
    'I do not want one ticket to turn into a spiral.',
    'I want more peace than the urge gives me.',
  ];

  @override
  void initState() {
    super.initState();
    _tick();
  }

  Future<void> _tick() async {
    while (mounted && _secondsLeft > 0) {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) {
        return;
      }

      setState(() {
        _secondsLeft -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayReasons = widget.reasons.isEmpty
        ? _starterReasons
        : widget.reasons.take(3).map((reason) => reason.text).toList();

    final converterReport =
        MoneyConverterService.build(widget.averageSpend);

    final previewComparisons = converterReport.comparisons.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Urge mode'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              children: [
                const Text(
                  'Pause first',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_secondsLeft',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _secondsLeft > 0
                      ? 'You do not have to decide in the next few seconds.'
                      : 'The first wave passed. That matters.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 16,
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
                  'What this ticket really risks',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${widget.averageSpend.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'That amount can stay yours if you get through this urge without buying.',
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
                  'What that money could buy instead',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (previewComparisons.isEmpty)
                  const Text(
                    'No comparison available yet.',
                    style: TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 14,
                    ),
                  )
                else
                  ...previewComparisons.map((comparison) {
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
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Near-miss psychology',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'If an almost-win is pulling you back in, open the explainer and break the spell a little.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Open near-miss explainer',
                  icon: Icons.lightbulb_rounded,
                  isPrimary: false,
                  onPressed: widget.onOpenNearMissEducation,
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
                  'Coping strategies',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Need a next move? Open short strategies for what to do during the urge.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Open coping strategies',
                  icon: Icons.psychology_rounded,
                  isPrimary: false,
                  onPressed: widget.onOpenCopingStrategies,
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
                  'Reasons to stop right now',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...displayReasons.map(
                  (reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 14,
                            color: AppTheme.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reason,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: _completed ? 'Urge already interrupted' : 'I got through this urge',
            icon: Icons.check_circle_rounded,
            onPressed: _completed
                ? null
                : () {
                    setState(() {
                      _completed = true;
                    });
                    widget.onComplete();
                  },
          ),
        ],
      ),
    );
  }
}
