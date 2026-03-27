import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../core/models/stop_reason.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';

class ReasonsScreen extends StatefulWidget {
  final List<StopReason> reasons;
  final ValueChanged<StopReason> onAddReason;
  final ValueChanged<StopReason> onEditReason;
  final void Function(String id) onDeleteReason;

  const ReasonsScreen({
    super.key,
    required this.reasons,
    required this.onAddReason,
    required this.onEditReason,
    required this.onDeleteReason,
  });

  @override
  State<ReasonsScreen> createState() => _ReasonsScreenState();
}

class _ReasonsScreenState extends State<ReasonsScreen> {
  static const List<String> _starterReasons = <String>[
    'I want to keep more money for real life.',
    'I do not want one ticket to turn into a spiral.',
    'I want more peace than the urge gives me.',
    'I am tired of feeling regret after buying.',
    'My future matters more than this moment.',
  ];

  late final List<StopReason> _reasons;

  @override
  void initState() {
    super.initState();
    _reasons = List<StopReason>.from(widget.reasons);
  }

  Future<void> _showReasonSheet(
    BuildContext context, {
    StopReason? existing,
  }) async {
    final controller = TextEditingController(text: existing?.text ?? '');
    final isEditing = existing != null;

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              20,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEditing ? 'Edit reason' : 'Add reason',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Reason to stop',
                    hintText: 'My kids matter more than another ticket...',
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: isEditing ? 'Save changes' : 'Save reason',
                  icon: Icons.check_rounded,
                  onPressed: () {
                    Navigator.of(context).pop(controller.text.trim());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null || result.isEmpty) {
      return;
    }

    if (existing == null) {
      final newReason = StopReason(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: result,
      );

      setState(() {
        _reasons.insert(0, newReason);
      });

      widget.onAddReason(newReason);
      return;
    }

    final updatedReason = existing.copyWith(text: result);

    setState(() {
      final index = _reasons.indexWhere((item) => item.id == existing.id);
      if (index != -1) {
        _reasons[index] = updatedReason;
      }
    });

    widget.onEditReason(updatedReason);
  }

  Future<void> _confirmDelete(BuildContext context, StopReason reason) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Delete reason?'),
              content: const Text(
                'This will remove the saved reason from your list.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed || !mounted) {
      return;
    }

    setState(() {
      _reasons.removeWhere((item) => item.id == reason.id);
    });

    widget.onDeleteReason(reason.id);
  }

  @override
  Widget build(BuildContext context) {
    final usingStarters = _reasons.isEmpty;
    final displayReasons = usingStarters
        ? _starterReasons
            .map(
              (text) => StopReason(
                id: text,
                text: text,
              ),
            )
            .toList()
        : _reasons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reasons to stop'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep your reasons close',
                  style: TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'These are the words you want to hear when the urge feels louder than your future.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add your own reasons so ScratchLess can speak back to the part of you that wants something better.',
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
            label: 'Add a reason',
            icon: Icons.add_rounded,
            onPressed: () {
              _showReasonSheet(context);
            },
          ),
          const SizedBox(height: 12),
          ...displayReasons.map((reason) {
            return Padding(
              key: ValueKey(reason.id),
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reason.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (usingStarters)
                      const Text(
                        'Starter example — add your own version',
                        style: TextStyle(
                          color: AppTheme.mutedText,
                          fontSize: 12,
                        ),
                      )
                    else
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              _showReasonSheet(
                                context,
                                existing: reason,
                              );
                            },
                            icon: const Icon(Icons.edit_rounded),
                            label: const Text('Edit'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              _confirmDelete(context, reason);
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Delete'),
                          ),
                        ],
                      ),
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
