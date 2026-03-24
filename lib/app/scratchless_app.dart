import 'package:flutter/material.dart';

import '../core/models/purchase_log.dart';
import '../core/services/streak_service.dart';
import '../core/storage/app_storage.dart';
import '../features/home/home_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import 'app_theme.dart';

class ScratchLessApp extends StatefulWidget {
  const ScratchLessApp({super.key});

  @override
  State<ScratchLessApp> createState() => _ScratchLessAppState();
}

class _ScratchLessAppState extends State<ScratchLessApp> {
  bool _isLoading = true;
  bool _isOnboarded = false;
  DateTime? _startedAt;

  int _frequencyPerWeek = 3;
  double _averageSpend = 10;
  String _goal = 'Spend less';

  int _urgesDefeated = 0;
  List<PurchaseLog> _logs = <PurchaseLog>[];

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

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
    return StreakService.currentStreakDays(
      startedAt: _startedAt,
      logs: _logs,
    );
  }

  int get _bestStreakDays {
    return StreakService.bestStreakDays(
      startedAt: _startedAt,
      logs: _logs,
    );
  }

  Future<void> _loadSavedState() async {
    final stored = await AppStorage.load();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _isOnboarded = stored.isOnboarded;
      _startedAt = stored.startedAt;
      _frequencyPerWeek = stored.frequencyPerWeek;
      _averageSpend = stored.averageSpend;
      _goal = stored.goal;
      _urgesDefeated = stored.urgesDefeated;
      _logs = stored.logs;
    });
  }

  Future<void> _persistState() async {
    await AppStorage.save(
      StoredAppState(
        isOnboarded: _isOnboarded,
        startedAt: _startedAt,
        frequencyPerWeek: _frequencyPerWeek,
        averageSpend: _averageSpend,
        goal: _goal,
        urgesDefeated: _urgesDefeated,
        logs: _logs,
      ),
    );
  }

  void _completeOnboarding(OnboardingResult result) {
    setState(() {
      _isOnboarded = true;
      _startedAt = DateTime.now();
      _frequencyPerWeek = result.frequencyPerWeek;
      _averageSpend = result.averageSpend;
      _goal = result.goal;
    });

    _persistState();
  }

  void _logPurchase(double amount, String? note) {
    setState(() {
      _logs = <PurchaseLog>[
        PurchaseLog(
          createdAt: DateTime.now(),
          amount: amount,
          note: note,
        ),
        ..._logs,
      ];
    });

    _persistState();
  }

  void _completeUrgeSession() {
    setState(() {
      _urgesDefeated += 1;
    });

    _persistState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScratchLess',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: _isLoading
          ? const _LoadingScreen()
          : _isOnboarded
              ? HomeShell(
                  currentStreakDays: _currentStreakDays,
                  bestStreakDays: _bestStreakDays,
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

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
