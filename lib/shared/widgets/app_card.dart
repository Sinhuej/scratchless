import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: card,
    );
  }
}
