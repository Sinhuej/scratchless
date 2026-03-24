import 'package:flutter/material.dart';

import '../core/models/purchase_log.dart';
import '../features/home/home_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'app_theme.dart';

class ScratchLessApp extends StatefulWidget {
  const ScratchLessApp({super.key});

  @override
  State<ScratchLessApp> createState() => _ScratchLessAppState();
}

class _ScratchLessAppState extends State<ScratchLessApp> {
  bool _isOnboarded = false;
  DateTime? _startedAt;

  int _frequencyPerWeek = 3;
  double _averageSpend = 10;
  String _goal = 'Spend less';

  int _urgesDefeated = 0;
  final List<PurchaseLog> _logs = <PurchaseLog>[];

  double get _monthlySpendEstimate {
    return _frequencyPerWeek * _averageSpend * 4.33;
  }

  double get _estimatedCashKept {
    return _urgesDefeated * _averageSpend;
  }

  double get _totalSpent {
    return _logs.fold<double>(0, (sum, log) => sum + log.amount);
  }

  int get _currentStreakDays {
    if (_startedAt == null) {
      return 0;
    }

    final reference = _logs.isEmpty ? _startedAt! : _logs.first.createdAt;
    final now = DateTime.now();

    final referenceDay = DateTime(reference.year, reference.month, reference.day);
    final today = DateTime(now.year, now.month, now.day);

    return today.difference(referenceDay).inDays;
  }

  void _completeOnboarding(OnboardingResult result) {
    setState(() {
      _isOnboarded = true;
      _startedAt = DateTime.now();
      _frequencyPerWeek = result.frequencyPerWeek;
      _averageSpend = result.averageSpend;
      _goal = result.goal;
    });
  }

  void _logPurchase(double amount, String? note) {
    setState(() {
      _logs.insert(
        0,
        PurchaseLog(
          createdAt: DateTime.now(),
          amount: amount,
          note: note,
        ),
      );
    });
  }

  void _completeUrgeSession() {
    setState(() {
      _urgesDefeated += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScratchLess',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: _isOnboarded
          ? HomeShell(
              currentStreakDays: _currentStreakDays,
              urgesDefeated: _urgesDefeated,
              frequencyPerWeek: _frequencyPerWeek,
              averageSpend: _averageSpend,
              estimatedCashKept: _estimatedCashKept,
              totalSpent: _totalSpent,
              monthlySpendEstimate: _monthlySpendEstimate,
              goal: _goal,
              logs: _logs,
              onLogPurchase: _logPurchase,
              onCompleteUrgeSession: _completeUrgeSession,
            )
          : OnboardingScreen(
              onComplete: _completeOnboarding,
            ),
    );
  }
}
