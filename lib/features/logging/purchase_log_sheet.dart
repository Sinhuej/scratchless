import 'package:flutter/material.dart';

import '../../shared/widgets/app_button.dart';

class PurchaseLogSheet extends StatefulWidget {
  final void Function(double amount, String? note, List<String> tags) onSave;

  const PurchaseLogSheet({
    super.key,
    required this.onSave,
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

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Log a scratch-off purchase',
              style: TextStyle(
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
              label: 'Save entry',
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
          ],
        ),
      ),
    );
  }
}
