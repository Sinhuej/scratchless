import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/purchase_log.dart';

class StoredAppState {
  final bool isOnboarded;
  final DateTime? startedAt;
  final int frequencyPerWeek;
  final double averageSpend;
  final String goal;
  final int urgesDefeated;
  final List<PurchaseLog> logs;

  const StoredAppState({
    required this.isOnboarded,
    required this.startedAt,
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.goal,
    required this.urgesDefeated,
    required this.logs,
  });

  factory StoredAppState.empty() {
    return const StoredAppState(
      isOnboarded: false,
      startedAt: null,
      frequencyPerWeek: 3,
      averageSpend: 10,
      goal: 'Spend less',
      urgesDefeated: 0,
      logs: <PurchaseLog>[],
    );
  }
}

class AppStorage {
  static const String _isOnboardedKey = 'is_onboarded';
  static const String _startedAtKey = 'started_at';
  static const String _frequencyPerWeekKey = 'frequency_per_week';
  static const String _averageSpendKey = 'average_spend';
  static const String _goalKey = 'goal';
  static const String _urgesDefeatedKey = 'urges_defeated';
  static const String _logsKey = 'purchase_logs';

  static Future<StoredAppState> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final startedAtRaw = prefs.getString(_startedAtKey);
      final startedAt =
          startedAtRaw == null ? null : DateTime.tryParse(startedAtRaw);

      final rawLogs = prefs.getStringList(_logsKey) ?? <String>[];
      final logs = rawLogs.map((raw) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return PurchaseLog.fromJson(decoded);
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return StoredAppState(
        isOnboarded: prefs.getBool(_isOnboardedKey) ?? false,
        startedAt: startedAt,
        frequencyPerWeek: prefs.getInt(_frequencyPerWeekKey) ?? 3,
        averageSpend: prefs.getDouble(_averageSpendKey) ?? 10,
        goal: prefs.getString(_goalKey) ?? 'Spend less',
        urgesDefeated: prefs.getInt(_urgesDefeatedKey) ?? 0,
        logs: logs,
      );
    } catch (_) {
      return StoredAppState.empty();
    }
  }

  static Future<void> save(StoredAppState state) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isOnboardedKey, state.isOnboarded);

    if (state.startedAt != null) {
      await prefs.setString(_startedAtKey, state.startedAt!.toIso8601String());
    } else {
      await prefs.remove(_startedAtKey);
    }

    await prefs.setInt(_frequencyPerWeekKey, state.frequencyPerWeek);
    await prefs.setDouble(_averageSpendKey, state.averageSpend);
    await prefs.setString(_goalKey, state.goal);
    await prefs.setInt(_urgesDefeatedKey, state.urgesDefeated);

    final encodedLogs =
        state.logs.map((log) => jsonEncode(log.toJson())).toList();

    await prefs.setStringList(_logsKey, encodedLogs);
  }
}
