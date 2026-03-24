import 'package:flutter/material.dart';

import '../../../app/app_theme.dart';

class PrimaryUrgeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PrimaryUrgeButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 104,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.warning,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flash_on_rounded, size: 30),
            SizedBox(height: 6),
            Text(
              'I feel the urge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Tap here before buying a ticket',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
