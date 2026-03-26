import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_theme.dart';
import '../../core/services/support_link_service.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static Future<void> _launchOrFallback({
    required BuildContext context,
    required Future<bool> Function() action,
    required String fallbackText,
    required String failureMessage,
  }) async {
    final ok = await action();

    if (!context.mounted) {
      return;
    }

    if (ok) {
      return;
    }

    await Clipboard.setData(
      ClipboardData(text: fallbackText),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failureMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get help now'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Support without shame',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Use this screen when the urge feels bigger than your usual tools.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Help is available for scratch-off and lottery-related gambling problems too. Start with whichever option feels easiest right now.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Call 1-800-MY-RESET',
            icon: Icons.call_rounded,
            onPressed: () {
              _launchOrFallback(
                context: context,
                action: SupportLinkService.launchCall,
                fallbackText: '1-800-MY-RESET',
                failureMessage: 'Could not open the dialer. Copied 1-800-MY-RESET.',
              );
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Text 800GAM',
            icon: Icons.sms_rounded,
            isPrimary: false,
            onPressed: () {
              _launchOrFallback(
                context: context,
                action: SupportLinkService.launchText,
                fallbackText: '800GAM',
                failureMessage: 'Could not open messaging. Copied 800GAM.',
              );
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Open live chat',
            icon: Icons.chat_bubble_rounded,
            isPrimary: false,
            onPressed: () {
              _launchOrFallback(
                context: context,
                action: SupportLinkService.launchChat,
                fallbackText: 'https://www.ncpgambling.org/chat/',
                failureMessage: 'Could not open chat. Copied the chat link.',
              );
            },
          ),
          const SizedBox(height: 12),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick options',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                _BulletLine('Call if you want a human voice right now'),
                _BulletLine('Text if speaking feels like too much'),
                _BulletLine('Chat if you want a private typed conversation'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'More support',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Find help by state',
                  icon: Icons.map_rounded,
                  isPrimary: false,
                  onPressed: () {
                    _launchOrFallback(
                      context: context,
                      action: SupportLinkService.launchHelpByState,
                      fallbackText:
                          'https://www.ncpgambling.org/help-treatment/help-by-state/',
                      failureMessage:
                          'Could not open state help. Copied the state help link.',
                    );
                  },
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Open help resources',
                  icon: Icons.open_in_browser_rounded,
                  isPrimary: false,
                  onPressed: () {
                    _launchOrFallback(
                      context: context,
                      action: SupportLinkService.launchHelpHome,
                      fallbackText:
                          'https://www.ncpgambling.org/help-treatment/',
                      failureMessage:
                          'Could not open help resources. Copied the help link.',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;

  const _BulletLine(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
