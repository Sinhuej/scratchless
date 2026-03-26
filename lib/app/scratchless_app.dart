import 'package:flutter/material.dart';

import '../core/models/premium_state.dart';
import '../core/models/purchase_log.dart';
import '../core/models/reminder_settings.dart';
import '../core/models/urge_session_log.dart';
import '../core/models/weekly_reflection_archive_item.dart';
import '../core/services/local_notification_service.dart';
import '../core/services/streak_service.dart';
import '../core/services/weekly_reflection_service.dart';
import '../core/services/weekly_summary_service.dart';
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
  List<UrgeSessionLog> _urgeSessions = <UrgeSessionLog>[];
  ReminderSettings _reminderSettings = ReminderSettings.defaults();
  PremiumState _premiumState = PremiumState.free();
  List<WeeklyReflectionArchiveItem> _weeklyReflectionArchive =
      <WeeklyReflectionArchiveItem>[];

  @override
  void initState() {
    super.initState();
    _bootstrap();
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

  WeeklySummary get _weeklySummary {
    return WeeklySummaryService.build(
      purchaseLogs: _logs,
      urgeSessions: _urgeSessions,
      averageSpend: _averageSpend,
    );
  }

  Future<void> _bootstrap() async {
    await LocalNotificationService.instance.initialize();
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
      _reminderSettings = stored.reminderSettings;
      _urgeSessions = stored.urgeSessions;
      _premiumState = stored.premiumState;
      _weeklyReflectionArchive = stored.weeklyReflectionArchive;
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
        reminderSettings: _reminderSettings,
        urgeSessions: _urgeSessions,
        premiumState: _premiumState,
        weeklyReflectionArchive: _weeklyReflectionArchive,
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

  void _logPurchase(double amount, String? note, List<String> tags) {
    setState(() {
      _logs = <PurchaseLog>[
        PurchaseLog(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          amount: amount,
          note: note,
          tags: tags,
        ),
        ..._logs,
      ];
    });

    _persistState();
  }

  void _editPurchase(
    String id,
    double amount,
    String? note,
    List<String> tags,
  ) {
    setState(() {
      _logs = _logs.map((log) {
        if (log.id != id) {
          return log;
        }

        return log.copyWith(
          amount: amount,
          note: note,
          tags: tags,
        );
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });

    _persistState();
  }

  void _deletePurchase(String id) {
    setState(() {
      _logs = _logs.where((log) => log.id != id).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });

    _persistState();
  }

  void _completeUrgeSession() {
    setState(() {
      _urgesDefeated += 1;
      _urgeSessions = <UrgeSessionLog>[
        UrgeSessionLog(
          completedAt: DateTime.now(),
        ),
        ..._urgeSessions,
      ];
    });

    _persistState();
  }

  void _updateReminderSettings(ReminderSettings settings) {
    setState(() {
      _reminderSettings = settings;
    });

    _persistState();
    LocalNotificationService.instance.syncReminderSettings(settings);
  }

  void _startPremiumTrial() {
    if (_premiumState.isPremium) {
      return;
    }

    setState(() {
      _premiumState = PremiumState(
        isPremium: true,
        trialStartedAt: DateTime.now(),
      );
    });

    _persistState();
  }

  void _saveWeeklyReflectionToHistory() {
    final report = WeeklyReflectionService.build(
      weeklySummary: _weeklySummary,
      logs: _logs,
    );

    final now = DateTime.now();
    final weekEnding = DateTime(now.year, now.month, now.day);
    final archiveId =
        '${weekEnding.year}-${weekEnding.month.toString().padLeft(2, '0')}-${weekEnding.day.toString().padLeft(2, '0')}';

    final item = WeeklyReflectionArchiveItem(
      id: archiveId,
      savedAt: now,
      weekEnding: weekEnding,
      title: report.title,
      summary: report.summary,
      strongestWindow: report.strongestWindow,
      topTrigger: report.topTrigger,
      reflections: report.reflections,
      nextStep: report.nextStep,
    );

    setState(() {
      _weeklyReflectionArchive = [
        item,
        ..._weeklyReflectionArchive.where((existing) => existing.id != archiveId),
      ]..sort((a, b) => b.weekEnding.compareTo(a.weekEnding));
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
                  reminderSettings: _reminderSettings,
                  weeklySummary: _weeklySummary,
                  premiumState: _premiumState,
                  weeklyReflectionArchive: _weeklyReflectionArchive,
                  onLogPurchase: _logPurchase,
                  onEditPurchase: _editPurchase,
                  onDeletePurchase: _deletePurchase,
                  onCompleteUrgeSession: _completeUrgeSession,
                  onUpdateReminderSettings: _updateReminderSettings,
                  onStartPremiumTrial: _startPremiumTrial,
                  onSaveWeeklyReflectionToHistory: _saveWeeklyReflectionToHistory,
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
