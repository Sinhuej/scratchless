import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/stop_reason.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class UrgeModeScreen extends StatefulWidget {
  final double averageSpend;
  final VoidCallback onComplete;
  final List<StopReason> reasons;

  const UrgeModeScreen({
    super.key,
    required this.averageSpend,
    required this.onComplete,
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
