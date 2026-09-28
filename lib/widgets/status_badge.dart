import 'package:flutter/material.dart';

import '../models/status_level.dart';
import '../theme/app_theme.dart';

/// Small pill label used for alert/issue severity (e.g. "CRITICAL", "WARNING").
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.level});

  final String label;
  final StatusLevel level;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(context, level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
