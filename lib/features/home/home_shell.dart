import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/accountability_partner.dart';
import '../../core/models/premium_state.dart';
import '../../core/models/purchase_log.dart';
import '../../core/models/reminder_settings.dart';
import '../../core/models/stop_reason.dart';
import '../../core/models/weekly_reflection_archive_item.dart';
import '../../core/services/weekly_summary_service.dart';
import '../accountability/accountability_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../help/help_screen.dart';
import '../profile/profile_screen.dart';
import '../reasons/reasons_screen.dart';
import '../stats/stats_screen.dart';

class HomeShell extends StatefulWidget {
  final int currentStreakDays;
  final int bestStreakDays;
  final int urgesDefeated;
  final int frequencyPerWeek;
  final double averageSpend;
  final double estimatedCashKept;
  final double totalSpent;
  final double monthlySpendEstimate;
  final String goal;
  final List<PurchaseLog> logs;
  final ReminderSettings reminderSettings;
  final WeeklySummary weeklySummary;
  final PremiumState premiumState;
  final List<WeeklyReflectionArchiveItem> weeklyReflectionArchive;
  final AccountabilityPartner accountabilityPartner;
  final List<StopReason> stopReasons;
  final void Function(double amount, String? note, List<String> tags)
      onLogPurchase;
  final void Function(String id, double amount, String? note, List<String> tags)
      onEditPurchase;
  final void Function(String id) onDeletePurchase;
  final VoidCallback onCompleteUrgeSession;
  final ValueChanged<ReminderSettings> onUpdateReminderSettings;
  final VoidCallback onStartPremiumTrial;
  final VoidCallback onSaveWeeklyReflectionToHistory;
  final ValueChanged<AccountabilityPartner> onUpdateAccountabilityPartner;
  final ValueChanged<StopReason> onAddStopReason;
  final ValueChanged<StopReason> onEditStopReason;
  final void Function(String id) onDeleteStopReason;

  const HomeShell({
    super.key,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.urgesDefeated,
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.estimatedCashKept,
    required this.totalSpent,
    required this.monthlySpendEstimate,
    required this.goal,
    required this.logs,
    required this.reminderSettings,
    required this.weeklySummary,
    required this.premiumState,
    required this.weeklyReflectionArchive,
    required this.accountabilityPartner,
    required this.stopReasons,
    required this.onLogPurchase,
    required this.onEditPurchase,
    required this.onDeletePurchase,
    required this.onCompleteUrgeSession,
    required this.onUpdateReminderSettings,
    required this.onStartPremiumTrial,
    required this.onSaveWeeklyReflectionToHistory,
    required this.onUpdateAccountabilityPartner,
    required this.onAddStopReason,
    required this.onEditStopReason,
    required this.onDeleteStopReason,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  void _openHelp() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const HelpScreen(),
      ),
    );
  }

  void _openAccountability() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AccountabilityScreen(
          partner: widget.accountabilityPartner,
          onSavePartner: widget.onUpdateAccountabilityPartner,
          weeklySummary: widget.weeklySummary,
          logs: widget.logs,
          currentStreakDays: widget.currentStreakDays,
          bestStreakDays: widget.bestStreakDays,
        ),
      ),
    );
  }

  void _openReasons() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReasonsScreen(
          reasons: widget.stopReasons,
          onAddReason: widget.onAddStopReason,
          onEditReason: widget.onEditStopReason,
          onDeleteReason: widget.onDeleteStopReason,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DashboardScreen(
        currentStreakDays: widget.currentStreakDays,
        bestStreakDays: widget.bestStreakDays,
        urgesDefeated: widget.urgesDefeated,
        averageSpend: widget.averageSpend,
        estimatedCashKept: widget.estimatedCashKept,
        totalSpent: widget.totalSpent,
        monthlySpendEstimate: widget.monthlySpendEstimate,
        logs: widget.logs,
        reasons: widget.stopReasons,
        weeklySummary: widget.weeklySummary,
        onLogPurchase: widget.onLogPurchase,
        onEditPurchase: widget.onEditPurchase,
        onDeletePurchase: widget.onDeletePurchase,
        onCompleteUrgeSession: widget.onCompleteUrgeSession,
        onOpenHelp: _openHelp,
      ),
      StatsScreen(
        logs: widget.logs,
        currentStreakDays: widget.currentStreakDays,
        bestStreakDays: widget.bestStreakDays,
        monthlySpendEstimate: widget.monthlySpendEstimate,
        estimatedCashKept: widget.estimatedCashKept,
        weeklySummary: widget.weeklySummary,
        premiumState: widget.premiumState,
        weeklyReflectionArchive: widget.weeklyReflectionArchive,
        onStartPremiumTrial: widget.onStartPremiumTrial,
        onSaveWeeklyReflectionToHistory: widget.onSaveWeeklyReflectionToHistory,
        onEditPurchase: widget.onEditPurchase,
        onDeletePurchase: widget.onDeletePurchase,
      ),
      ProfileScreen(
        goal: widget.goal,
        frequencyPerWeek: widget.frequencyPerWeek,
        averageSpend: widget.averageSpend,
        monthlySpendEstimate: widget.monthlySpendEstimate,
        currentStreakDays: widget.currentStreakDays,
        bestStreakDays: widget.bestStreakDays,
        reminderSettings: widget.reminderSettings,
        premiumState: widget.premiumState,
        accountabilityPartner: widget.accountabilityPartner,
        onUpdateReminderSettings: widget.onUpdateReminderSettings,
        onStartPremiumTrial: widget.onStartPremiumTrial,
        onOpenHelp: _openHelp,
        onOpenAccountability: _openAccountability,
        onOpenReasons: _openReasons,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.card,
        indicatorColor: Colors.white.withOpacity(0.08),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
