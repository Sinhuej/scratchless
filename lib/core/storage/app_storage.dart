import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/accountability_partner.dart';
import '../models/premium_state.dart';
import '../models/purchase_log.dart';
import '../models/reminder_settings.dart';
import '../models/urge_session_log.dart';
import '../models/weekly_reflection_archive_item.dart';

class StoredAppState {
  final bool isOnboarded;
  final DateTime? startedAt;
  final int frequencyPerWeek;
  final double averageSpend;
  final String goal;
  final int urgesDefeated;
  final List<PurchaseLog> logs;
  final ReminderSettings reminderSettings;
  final List<UrgeSessionLog> urgeSessions;
  final PremiumState premiumState;
  final List<WeeklyReflectionArchiveItem> weeklyReflectionArchive;
  final AccountabilityPartner accountabilityPartner;

  const StoredAppState({
    required this.isOnboarded,
    required this.startedAt,
    required this.frequencyPerWeek,
    required this.averageSpend,
    required this.goal,
    required this.urgesDefeated,
    required this.logs,
    required this.reminderSettings,
    required this.urgeSessions,
    required this.premiumState,
    required this.weeklyReflectionArchive,
    required this.accountabilityPartner,
  });

  factory StoredAppState.empty() {
    return StoredAppState(
      isOnboarded: false,
      startedAt: null,
      frequencyPerWeek: 3,
      averageSpend: 10,
      goal: 'Spend less',
      urgesDefeated: 0,
      logs: const <PurchaseLog>[],
      reminderSettings: ReminderSettings.defaults(),
      urgeSessions: const <UrgeSessionLog>[],
      premiumState: PremiumState.free(),
      weeklyReflectionArchive: const <WeeklyReflectionArchiveItem>[],
      accountabilityPartner: AccountabilityPartner.empty(),
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
  static const String _urgeSessionsKey = 'urge_sessions';
  static const String _weeklyReflectionArchiveKey = 'weekly_reflection_archive';

  static const String _dailyCheckInEnabledKey = 'daily_check_in_enabled';
  static const String _eveningSupportEnabledKey = 'evening_support_enabled';
  static const String _dailyCheckInHourKey = 'daily_check_in_hour';

  static const String _isPremiumKey = 'is_premium';
  static const String _trialStartedAtKey = 'trial_started_at';

  static const String _accountabilityPartnerKey = 'accountability_partner';

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

      final rawUrgeSessions =
          prefs.getStringList(_urgeSessionsKey) ?? <String>[];
      final urgeSessions = rawUrgeSessions.map((raw) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return UrgeSessionLog.fromJson(decoded);
      }).toList()
        ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

      final rawArchive =
          prefs.getStringList(_weeklyReflectionArchiveKey) ?? <String>[];
      final weeklyReflectionArchive = rawArchive.map((raw) {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        return WeeklyReflectionArchiveItem.fromJson(decoded);
      }).toList()
        ..sort((a, b) => b.weekEnding.compareTo(a.weekEnding));

      final trialStartedAtRaw = prefs.getString(_trialStartedAtKey);
      final trialStartedAt = trialStartedAtRaw == null
          ? null
          : DateTime.tryParse(trialStartedAtRaw);

      final accountabilityRaw = prefs.getString(_accountabilityPartnerKey);
      final accountabilityPartner = accountabilityRaw == null
          ? AccountabilityPartner.empty()
          : AccountabilityPartner.fromJson(
              jsonDecode(accountabilityRaw) as Map<String, dynamic>,
            );

      return StoredAppState(
        isOnboarded: prefs.getBool(_isOnboardedKey) ?? false,
        startedAt: startedAt,
        frequencyPerWeek: prefs.getInt(_frequencyPerWeekKey) ?? 3,
        averageSpend: prefs.getDouble(_averageSpendKey) ?? 10,
        goal: prefs.getString(_goalKey) ?? 'Spend less',
        urgesDefeated: prefs.getInt(_urgesDefeatedKey) ?? 0,
        logs: logs,
        reminderSettings: ReminderSettings(
          dailyCheckInEnabled:
              prefs.getBool(_dailyCheckInEnabledKey) ?? false,
          eveningSupportEnabled:
              prefs.getBool(_eveningSupportEnabledKey) ?? false,
          dailyCheckInHour:
              prefs.getInt(_dailyCheckInHourKey) ?? 20,
        ),
        urgeSessions: urgeSessions,
        premiumState: PremiumState(
          isPremium: prefs.getBool(_isPremiumKey) ?? false,
          trialStartedAt: trialStartedAt,
        ),
        weeklyReflectionArchive: weeklyReflectionArchive,
        accountabilityPartner: accountabilityPartner,
      );
    } catch (_) {
      return StoredAppState.empty();
    }
  }

  static Future<void> save(StoredAppState state) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isOnboardedKey, state.isOnboarded);

    if (state.startedAt != null) {
      await prefs.setString(
        _startedAtKey,
        state.startedAt!.toIso8601String(),
      );
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

    final encodedUrgeSessions = state.urgeSessions
        .map((session) => jsonEncode(session.toJson()))
        .toList();
    await prefs.setStringList(_urgeSessionsKey, encodedUrgeSessions);

    final encodedArchive = state.weeklyReflectionArchive
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await prefs.setStringList(_weeklyReflectionArchiveKey, encodedArchive);

    await prefs.setBool(
      _dailyCheckInEnabledKey,
      state.reminderSettings.dailyCheckInEnabled,
    );
    await prefs.setBool(
      _eveningSupportEnabledKey,
      state.reminderSettings.eveningSupportEnabled,
    );
    await prefs.setInt(
      _dailyCheckInHourKey,
      state.reminderSettings.dailyCheckInHour,
    );

    await prefs.setBool(_isPremiumKey, state.premiumState.isPremium);

    if (state.premiumState.trialStartedAt != null) {
      await prefs.setString(
        _trialStartedAtKey,
        state.premiumState.trialStartedAt!.toIso8601String(),
      );
    } else {
      await prefs.remove(_trialStartedAtKey);
    }

    await prefs.setString(
      _accountabilityPartnerKey,
      jsonEncode(state.accountabilityPartner.toJson()),
    );
  }
}
