import 'package:flutter/material.dart';

/// Shared top header used across every screen in the design: optional back
/// button, title/subtitle, refresh action, and a notifications action with
/// an unread-count badge.
class DataComAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DataComAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.onRefresh,
    this.onOpenInbox,
    this.inboxCount,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onRefresh;
  final VoidCallback? onOpenInbox;
  final int? inboxCount;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 8, 4, 4),
        child: Row(
          children: [
            if (showBack)
              IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back))
            else
              const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                    ),
                ],
              ),
            ),
            if (onRefresh != null)
              IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
            if (onOpenInbox != null)
              IconButton(
                onPressed: onOpenInbox,
                icon: Badge(
                  isLabelVisible: (inboxCount ?? 0) > 0,
                  label: Text('$inboxCount'),
                  child: const Icon(Icons.notifications_outlined),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
