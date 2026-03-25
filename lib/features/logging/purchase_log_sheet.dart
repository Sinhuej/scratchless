import 'package:flutter/material.dart';

import '../../core/models/purchase_log.dart';
import '../../shared/widgets/app_button.dart';

class PurchaseLogSheet extends StatefulWidget {
  final void Function(double amount, String? note, List<String> tags) onSave;
  final PurchaseLog? initialLog;
  final VoidCallback? onDelete;

  const PurchaseLogSheet({
    super.key,
    required this.onSave,
    this.initialLog,
    this.onDelete,
  });

  @override
  State<PurchaseLogSheet> createState() => _PurchaseLogSheetState();
}

class _PurchaseLogSheetState extends State<PurchaseLogSheet> {
  double _selectedAmount = 10;
  final TextEditingController _noteController = TextEditingController();
  final Set<String> _selectedTags = <String>{};

  static const List<double> _amounts = <double>[5, 10, 20, 30, 50];

  static const List<String> _quickTags = <String>[
    'Stress',
    'Boredom',
    'After work',
    'Money pressure',
    'Lonely',
    'Store stop',
    'Nighttime',
  ];

  bool get _isEditing => widget.initialLog != null;

  @override
  void initState() {
    super.initState();

    final log = widget.initialLog;
    if (log != null) {
      _selectedAmount = log.amount;
      _noteController.text = log.note ?? '';
      _selectedTags.addAll(log.tags);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    if (widget.onDelete == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete entry?'),
              content: const Text(
                'This will permanently remove the purchase log.',
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

    if (!confirmed) {
      return;
    }

    widget.onDelete!.call();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          20,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isEditing
                    ? 'Edit purchase entry'
                    : 'Log a scratch-off purchase',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _amounts.map((amount) {
                  final isSelected = _selectedAmount == amount;
                  return ChoiceChip(
                    label: Text('\$${amount.toStringAsFixed(0)}'),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedAmount = amount;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick trigger tags',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _quickTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Optional note',
                  hintText: 'Stress, boredom, after work...',
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: _isEditing ? 'Save changes' : 'Save entry',
                icon: Icons.check_rounded,
                onPressed: () {
                  final note = _noteController.text.trim().isEmpty
                      ? null
                      : _noteController.text.trim();

                  widget.onSave(
                    _selectedAmount,
                    note,
                    _selectedTags.toList(),
                  );

                  Navigator.of(context).pop();
                },
              ),
              if (_isEditing && widget.onDelete != null) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _confirmDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: const Text('Delete entry'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
