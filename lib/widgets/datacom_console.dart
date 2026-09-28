import 'package:flutter/material.dart';

import '../models/console_emphasis.dart';

class ConsoleLine {
  const ConsoleLine(this.text, [this.emphasis = ConsoleEmphasis.normal]);

  final String text;
  final ConsoleEmphasis emphasis;
}

/// Dark, monospace log/trace viewer — always dark regardless of app theme,
/// matching the design's `--code` background (used for alert traces, slow
/// query EXPLAIN plans, and build/worker logs).
class DataComConsole extends StatelessWidget {
  const DataComConsole({super.key, required this.lines});

  final List<ConsoleLine> lines;

  static const _normal = Color(0xFFE4E4E7);
  static const _muted = Color(0xFFA1A1AA);
  static const _danger = Color(0xFFF87171);
  static const _warn = Color(0xFFFBBF24);
  static const _success = Color(0xFF4ADE80);

  Color _colorFor(ConsoleEmphasis emphasis) {
    switch (emphasis) {
      case ConsoleEmphasis.normal:
        return _normal;
      case ConsoleEmphasis.muted:
        return _muted;
      case ConsoleEmphasis.danger:
        return _danger;
      case ConsoleEmphasis.warn:
        return _warn;
      case ConsoleEmphasis.success:
        return _success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111528),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Text(
                line.text.isEmpty ? ' ' : line.text,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5,
                  color: _colorFor(line.emphasis),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
