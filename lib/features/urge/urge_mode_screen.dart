import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class UrgeModeScreen extends StatefulWidget {
  final double averageSpend;
  final VoidCallback onComplete;

  const UrgeModeScreen({
    super.key,
    required this.averageSpend,
    required this.onComplete,
  });

  @override
  State<UrgeModeScreen> createState() => _UrgeModeScreenState();
}

class _UrgeModeScreenState extends State<UrgeModeScreen> {
  static const int _startSeconds = 20;

  int _secondsLeft = _startSeconds;
  int _tapCount = 0;
  bool _complete = false;
  bool _reported = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        if (!_reported) {
          _reported = true;
          widget.onComplete();
        }
        setState(() {
          _secondsLeft = 0;
          _complete = true;
        });
      } else {
        setState(() {
          _secondsLeft -= 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsLeft / _startSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Urge Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _complete ? _buildCompleteView(context) : _buildActiveView(progress),
      ),
    );
  }

  Widget _buildActiveView(double progress) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text(
          'Pause the impulse.\nStay here for 20 seconds.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Do not buy a ticket right now. Just keep tapping until the timer ends.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.mutedText,
          ),
        ),
        const SizedBox(height: 24),
        LinearProgressIndicator(
          value: progress,
          minHeight: 12,
          borderRadius: BorderRadius.circular(999),
        ),
        const SizedBox(height: 10),
        Text(
          '$_secondsLeft seconds left',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.mutedText,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(() {
              _tapCount += 1;
            });
          },
          child: Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              color: AppTheme.card,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              'Tap\n$_tapCount',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Every interruption counts.',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.mutedText,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildCompleteView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        AppCard(
          child: Column(
            children: [
              const Icon(
                Icons.shield_rounded,
                size: 48,
                color: AppTheme.accent,
              ),
              const SizedBox(height: 12),
              const Text(
                'You made it through the moment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Estimated cash kept: \$${widget.averageSpend.toStringAsFixed(0)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.mutedText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Focus taps: $_tapCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.mutedText,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        AppButton(
          label: 'Done',
          icon: Icons.check_rounded,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
