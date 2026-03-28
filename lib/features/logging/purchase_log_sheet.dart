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
  static const List<double> _presetAmounts = <double>[5, 10, 20, 30, 50];

  double? _selectedPresetAmount = 10;
  bool _useCustomAmount = false;

  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final Set<String> _selectedTags = <String>{};

  bool get _isEditing => widget.initialLog != null;

  @override
  void initState() {
    super.initState();

    final log = widget.initialLog;
    if (log != null) {
      final matchesPreset = _presetAmounts.contains(log.amount);

      if (matchesPreset) {
        _selectedPresetAmount = log.amount;
        _useCustomAmount = false;
      } else {
        _selectedPresetAmount = null;
        _useCustomAmount = true;
        _customAmountController.text = _formatCustomAmount(log.amount);
      }

      _noteController.text = log.note ?? '';
      _selectedTags.addAll(log.tags);
    }
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatCustomAmount(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  double? _resolveAmount() {
    if (!_useCustomAmount) {
      return _selectedPresetAmount;
    }

    final raw = _customAmountController.text.trim();
    if (raw.isEmpty) {
      return null;
    }

    final normalized = raw.replaceAll(',', '');
    final parsed = double.tryParse(normalized);

    if (parsed == null || parsed <= 0) {
      return null;
    }

    return parsed;
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

  Widget _buildChipSection({
    required String title,
    required List<String> tags,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tags.map((tag) {
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
      ],
    );
  }

  void _save() {
    final amount = _resolveAmount();

    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid amount before saving.'),
        ),
      );
      return;
    }

    final note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    widget.onSave(
      amount,
      note,
      _selectedTags.toList(),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const emotionalTags = <String>[
      'Stress',
      'Boredom',
      'Lonely',
      'Money pressure',
      'After work',
      'Nighttime',
    ];

    const scratchOffTags = <String>[
      'After paycheck',
      'Saw a display',
      'Won recently',
      'Passing a store',
      'Routine stop',
      'Store stop',
    ];

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
              const SizedBox(height: 8),
              const Text(
                'Tap what matches this moment. It does not have to be perfect to be useful.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._presetAmounts.map((amount) {
                    final isSelected =
                        !_useCustomAmount && _selectedPresetAmount == amount;

                    return ChoiceChip(
                      label: Text('\$${amount.toStringAsFixed(0)}'),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _useCustomAmount = false;
                          _selectedPresetAmount = amount;
                        });
                      },
                    );
                  }),
                  ChoiceChip(
                    label: const Text('Other'),
                    selected: _useCustomAmount,
                    onSelected: (_) {
                      setState(() {
                        _useCustomAmount = true;
                        _selectedPresetAmount = null;
                      });
                    },
                  ),
                ],
              ),
              if (_useCustomAmount) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _customAmountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Custom amount',
                    hintText: 'Enter amount spent',
                    prefixText: '\$',
                  ),
                ),
              ],
              const SizedBox(height: 18),
              _buildChipSection(
                title: 'Emotional / pressure triggers',
                tags: emotionalTags,
              ),
              const SizedBox(height: 16),
              _buildChipSection(
                title: 'Scratch-off situation triggers',
                tags: scratchOffTags,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Optional note',
                  hintText: 'After seeing tickets at checkout, felt stressed...',
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: _isEditing ? 'Save changes' : 'Save entry',
                icon: Icons.check_rounded,
                onPressed: _save,
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
