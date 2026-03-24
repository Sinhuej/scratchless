import 'package:flutter/material.dart';

import '../../shared/widgets/app_button.dart';

class PurchaseLogSheet extends StatefulWidget {
  final void Function(double amount, String? note) onSave;

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

  static const List<double> _amounts = <double>[5, 10, 20, 30, 50];

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

                widget.onSave(_selectedAmount, note);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
