import '../models/purchase_log.dart';

class TriggerInsightService {
  static String riskWindow(List<PurchaseLog> logs) {
    if (logs.isEmpty) {
      return 'No trigger pattern yet';
    }

    final Map<String, int> buckets = {
      'Morning is your lightest risk window right now.': 0,
      'Afternoon looks like a recurring purchase window.': 0,
      'Evening looks like your strongest purchase window.': 0,
      'Late night may be a vulnerable purchase window.': 0,
    };

    for (final log in logs) {
      final hour = log.createdAt.hour;
      if (hour >= 5 && hour < 12) {
        buckets['Morning is your lightest risk window right now.'] =
            buckets['Morning is your lightest risk window right now.']! + 1;
      } else if (hour >= 12 && hour < 17) {
        buckets['Afternoon looks like a recurring purchase window.'] =
            buckets['Afternoon looks like a recurring purchase window.']! + 1;
      } else if (hour >= 17 && hour < 22) {
        buckets['Evening looks like your strongest purchase window.'] =
            buckets['Evening looks like your strongest purchase window.']! + 1;
      } else {
        buckets['Late night may be a vulnerable purchase window.'] =
            buckets['Late night may be a vulnerable purchase window.']! + 1;
      }
    }

    final sorted = buckets.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }

  static String noteInsight(List<PurchaseLog> logs) {
    final tagCounts = <String, int>{};

    for (final log in logs) {
      for (final tag in log.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    if (tagCounts.isNotEmpty) {
      final sorted = tagCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return 'Most common trigger tag so far: ${sorted.first.key}';
    }

    final notes = logs
        .map((log) => log.note?.trim().toLowerCase())
        .whereType<String>()
        .where((note) => note.isNotEmpty)
        .toList();

    if (notes.isEmpty) {
      return 'Add a quick tag or short note when you log a purchase to uncover patterns like stress, boredom, or after-work habits.';
    }

    final keywordMap = <String, List<String>>{
      'Stress': <String>[
        'stress',
        'stressed',
        'anxious',
        'anxiety',
        'overwhelmed',
      ],
      'Boredom': <String>[
        'bored',
        'boring',
        'nothing to do',
      ],
      'After work': <String>[
        'after work',
        'work',
        'off work',
        'shift',
      ],
      'Money pressure': <String>[
        'money',
        'bill',
        'bills',
        'paycheck',
        'paid',
        'broke',
      ],
      'Loneliness': <String>[
        'lonely',
        'alone',
      ],
      'Store stop habit': <String>[
        'store',
        'gas',
        'gas station',
        'checkout',
        'errand',
      ],
      'Nighttime habit': <String>[
        'night',
        'late',
        'late night',
      ],
    };

    final counts = <String, int>{};

    for (final note in notes) {
      for (final entry in keywordMap.entries) {
        for (final keyword in entry.value) {
          if (note.contains(keyword)) {
            counts[entry.key] = (counts[entry.key] ?? 0) + 1;
            break;
          }
        }
      }
    }

    if (counts.isEmpty) {
      final preview = notes.first;
      return 'Most recent note pattern: "${_titleCase(preview)}"';
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return 'Most common note pattern so far: ${sorted.first.key}';
  }

  static String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}
