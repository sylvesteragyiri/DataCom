import 'package:flutter/material.dart';

/// The rounded, outlined surface used for every card throughout the design.
class DataComCard extends StatelessWidget {
  const DataComCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final content = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: content,
      ),
    );
  }
}
