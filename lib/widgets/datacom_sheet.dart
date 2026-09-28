import 'package:flutter/material.dart';

class DataComSheetAction {
  const DataComSheetAction({
    required this.icon,
    required this.label,
    this.destructive = false,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool destructive;
  final VoidCallback onTap;
}

/// Matches the design's bottom-sheet action-menu pattern (`this.setState({sheet: ...})`),
/// reused for every screen's overflow/context menus.
Future<void> showDataComSheet(
  BuildContext context, {
  required String title,
  required List<DataComSheetAction> actions,
}) {
  return showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            for (final action in actions)
              ListTile(
                leading: Icon(
                  action.icon,
                  color: action.destructive ? colors.error : colors.onSurfaceVariant,
                ),
                title: Text(
                  action.label,
                  style: TextStyle(color: action.destructive ? colors.error : colors.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  action.onTap();
                },
              ),
          ],
        ),
      );
    },
  );
}
