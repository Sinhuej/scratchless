import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_theme.dart';
import '../../core/models/accountability_partner.dart';
import '../../core/models/purchase_log.dart';
import '../../core/services/accountability_message_service.dart';
import '../../core/services/progress_export_service.dart';
import '../../core/services/thirty_day_insight_service.dart';
import '../../core/services/weekly_summary_service.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class AccountabilityScreen extends StatefulWidget {
  final AccountabilityPartner partner;
  final ValueChanged<AccountabilityPartner> onSavePartner;
  final WeeklySummary weeklySummary;
  final List<PurchaseLog> logs;
  final int currentStreakDays;
  final int bestStreakDays;

  const AccountabilityScreen({
    super.key,
    required this.partner,
    required this.onSavePartner,
    required this.weeklySummary,
    required this.logs,
    required this.currentStreakDays,
    required this.bestStreakDays,
  });

  @override
  State<AccountabilityScreen> createState() => _AccountabilityScreenState();
}

class _AccountabilityScreenState extends State<AccountabilityScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.partner.name);
    _phoneController = TextEditingController(text: widget.partner.phone ?? '');
    _emailController = TextEditingController(text: widget.partner.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  AccountabilityPartner get _draftPartner {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    return AccountabilityPartner(
      name: name,
      phone: phone.isEmpty ? null : phone,
      email: email.isEmpty ? null : email,
    );
  }

  void _savePartner() {
    widget.onSavePartner(_draftPartner);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Trusted person saved'),
      ),
    );
  }

  Future<void> _copyText(String text, String confirmation) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(confirmation),
      ),
    );
  }

  Future<void> _sendSmsOrCopy({
    required String body,
    required String copiedMessage,
  }) async {
    final partner = _draftPartner;
    if (!partner.hasPhone) {
      await _copyText(body, copiedMessage);
      return;
    }

    final uri = Uri(
      scheme: 'sms',
      path: partner.phone,
      queryParameters: <String, String>{
        'body': body,
      },
    );

    final ok = await launchUrl(uri);

    if (!ok && mounted) {
      await _copyText(body, copiedMessage);
    }
  }

  Future<void> _sendEmailOrCopy({
    required String subject,
    required String body,
    required String copiedMessage,
  }) async {
    final partner = _draftPartner;
    if (!partner.hasEmail) {
      await _copyText(body, copiedMessage);
      return;
    }

    final uri = Uri(
      scheme: 'mailto',
      path: partner.email,
      queryParameters: <String, String>{
        'subject': subject,
        'body': body,
      },
    );

    final ok = await launchUrl(uri);

    if (!ok && mounted) {
      await _copyText(body, copiedMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final thirtyDayInsight = ThirtyDayInsightService.build(logs: widget.logs);
    final exportReport = ProgressExportService.build(
      weeklySummary: widget.weeklySummary,
      thirtyDayInsight: thirtyDayInsight,
      currentStreakDays: widget.currentStreakDays,
      bestStreakDays: widget.bestStreakDays,
    );

    final progressMessage = AccountabilityMessageService.buildProgressSummaryMessage(
      partnerName: _draftPartner.name,
      report: exportReport,
    );

    final checkInMessage = AccountabilityMessageService.buildCheckInMessage(
      partnerName: _draftPartner.name,
      weeklySummary: widget.weeklySummary,
      currentStreakDays: widget.currentStreakDays,
    );

    final supportNowMessage = AccountabilityMessageService.buildSupportNowMessage(
      partnerName: _draftPartner.name,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accountability'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trusted person',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Set one person you can reach when you want help staying honest and grounded.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You can save their name now and add phone or email later.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Trusted person name',
                    hintText: 'Leah, Mom, Alex...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                    hintText: '5551234567',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                    hintText: 'name@example.com',
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Save trusted person',
                  icon: Icons.person_add_alt_1_rounded,
                  onPressed: _savePartner,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share progress summary',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Use this when you want to stay accountable with a fuller snapshot.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Copy progress summary',
                  icon: Icons.copy_rounded,
                  onPressed: () {
                    _copyText(
                      progressMessage,
                      'Progress summary copied',
                    );
                  },
                ),
                if (_draftPartner.hasPhone) ...[
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'Text progress summary',
                    icon: Icons.sms_rounded,
                    isPrimary: false,
                    onPressed: () {
                      _sendSmsOrCopy(
                        body: progressMessage,
                        copiedMessage: 'Could not open texting. Progress summary copied.',
                      );
                    },
                  ),
                ],
                if (_draftPartner.hasEmail) ...[
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'Email progress summary',
                    icon: Icons.email_rounded,
                    isPrimary: false,
                    onPressed: () {
                      _sendEmailOrCopy(
                        subject: 'ScratchLess progress summary',
                        body: progressMessage,
                        copiedMessage: 'Could not open email. Progress summary copied.',
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send check-in',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Use this for a shorter, lighter accountability update.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Copy check-in',
                  icon: Icons.copy_rounded,
                  onPressed: () {
                    _copyText(
                      checkInMessage,
                      'Check-in copied',
                    );
                  },
                ),
                if (_draftPartner.hasPhone) ...[
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'Text check-in',
                    icon: Icons.sms_rounded,
                    isPrimary: false,
                    onPressed: () {
                      _sendSmsOrCopy(
                        body: checkInMessage,
                        copiedMessage: 'Could not open texting. Check-in copied.',
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'I need support right now',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Use this when the urge is active and you need a fast human check-in.',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Copy support message',
                  icon: Icons.copy_rounded,
                  onPressed: () {
                    _copyText(
                      supportNowMessage,
                      'Support message copied',
                    );
                  },
                ),
                if (_draftPartner.hasPhone) ...[
                  const SizedBox(height: 10),
                  AppButton(
                    label: 'Text support request',
                    icon: Icons.support_agent_rounded,
                    isPrimary: false,
                    onPressed: () {
                      _sendSmsOrCopy(
                        body: supportNowMessage,
                        copiedMessage: 'Could not open texting. Support message copied.',
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
