import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/services/coping_strategy_service.dart';
import '../../shared/widgets/app_card.dart';

class CopingStrategiesScreen extends StatelessWidget {
  const CopingStrategiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strategies = CopingStrategyService.strategies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coping strategies'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What to do during the urge',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'These are short tools to help you slow the urge down and choose something else.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You do not need to do every step. One useful move is often enough to interrupt the spiral.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...strategies.map((strategy) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strategy.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strategy.whyItHelps,
                      style: const TextStyle(
                        color: AppTheme.mutedText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...strategy.steps.map((step) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Icon(
                                Icons.circle,
                                size: 8,
                                color: AppTheme.accent,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                step,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
