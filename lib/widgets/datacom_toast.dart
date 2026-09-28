import 'package:flutter/material.dart';

/// Matches the design's transient "toast" pattern (`this.flash(msg)` in
/// design-reference), reused across screens rather than each screen
/// building its own confirmation UI.
void showDataComToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2200),
      ),
    );
}
