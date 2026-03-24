import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/purchase_log.dart';
import '../dashboard/dashboard_screen.dart';
import '../profile/profile_screen.dart';
import '../stats/stats_screen.dart';

class HomeShell extends StatefulWidget {
  final int currentStreakDays;
  final int urgesDefeated;
  final int frequencyPerWeek;
  final double averageSpend;
  final double estimatedCashKept;
  final double totalSpent;
  final double monthlySpendEstimate;
  final String goal;
  final List<PurchaseLog> logs;
  final void Function(double amount, String? note) onLogPurchase;
  final VoidCallback onCompleteUrgeSession;

  const HomeShell({
    super.key,
    required this.currentStreakDays,
    required this.urgesDefeated,
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.estimatedCashKept,
    required this.totalSpent,
    required this.monthlySpendEstimate,
    required this.goal,
    required this.logs,
    required this.onLogPurchase,
    required this.onCompleteUrgeSession,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DashboardScreen(
        currentStreakDays: widget.currentStreakDays,
        urgesDefeated: widget.urgesDefeated,
        averageSpend: widget.averageSpend,
        estimatedCashKept: widget.estimatedCashKept,
        totalSpent: widget.totalSpent,
        monthlySpendEstimate: widget.monthlySpendEstimate,
        logs: widget.logs,
        onLogPurchase: widget.onLogPurchase,
        onCompleteUrgeSession: widget.onCompleteUrgeSession,
      ),
      StatsScreen(
        logs: widget.logs,
        monthlySpendEstimate: widget.monthlySpendEstimate,
        estimatedCashKept: widget.estimatedCashKept,
      ),
      ProfileScreen(
        goal: widget.goal,
        frequencyPerWeek: widget.frequencyPerWeek,
        averageSpend: widget.averageSpend,
        monthlySpendEstimate: widget.monthlySpendEstimate,
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
