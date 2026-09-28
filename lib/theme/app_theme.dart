import 'package:flutter/material.dart';

import '../models/status_level.dart';

/// Maps a [StatusLevel] to the current theme's color for it. Shared across
/// every screen so status semantics (ok/warn/critical/info) stay consistent.
Color statusColor(BuildContext context, StatusLevel? level) {
  final colors = Theme.of(context).colorScheme;
  final status = Theme.of(context).extension<DataComStatusColors>()!;
  switch (level) {
    case StatusLevel.ok:
      return status.ok;
    case StatusLevel.warn:
      return status.warn;
    case StatusLevel.critical:
      return colors.error;
    case StatusLevel.info:
      return colors.primary;
    case null:
      return colors.onSurface;
  }
}

@immutable
class DataComStatusColors extends ThemeExtension<DataComStatusColors> {
  const DataComStatusColors({
    required this.ok,
    required this.okContainer,
    required this.warn,
    required this.warnContainer,
  });

  final Color ok;
  final Color okContainer;
  final Color warn;
  final Color warnContainer;

  static const light = DataComStatusColors(
    ok: Color(0xFF12805C),
    okContainer: Color(0xFFE7F6F0),
    warn: Color(0xFFA5620A),
    warnContainer: Color(0xFFFDF3E4),
  );

  static const dark = DataComStatusColors(
    ok: Color(0xFF5ECFA4),
    okContainer: Color(0xFF0F2A22),
    warn: Color(0xFFE0B063),
    warnContainer: Color(0xFF2B2008),
  );

  @override
  DataComStatusColors copyWith({
    Color? ok,
    Color? okContainer,
    Color? warn,
    Color? warnContainer,
  }) {
    return DataComStatusColors(
      ok: ok ?? this.ok,
      okContainer: okContainer ?? this.okContainer,
      warn: warn ?? this.warn,
      warnContainer: warnContainer ?? this.warnContainer,
    );
  }

  @override
  DataComStatusColors lerp(
    ThemeExtension<DataComStatusColors>? other,
    double t,
  ) {
    if (other is! DataComStatusColors) return this;
    return DataComStatusColors(
      ok: Color.lerp(ok, other.ok, t)!,
      okContainer: Color.lerp(okContainer, other.okContainer, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      warnContainer: Color.lerp(warnContainer, other.warnContainer, t)!,
    );
  }
}

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFEEF1F8),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2F5BEA),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE6ECFE),
    onPrimaryContainer: Color(0xFF1F3FAE),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111528),
    surfaceContainerHighest: Color(0xFFE7EBF5),
    outline: Color(0xFFE3E7F1),
    error: Color(0xFFD13B41),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFDEFF0),
    onErrorContainer: Color(0xFFD13B41),
  ),
  extensions: const [DataComStatusColors.light],
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0C0F1A),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF7F9DFF),
    onPrimary: Color(0xFF0C0F1A),
    primaryContainer: Color(0xFF1D2748),
    onPrimaryContainer: Color(0xFFB9C8FF),
    surface: Color(0xFF191D2C),
    onSurface: Color(0xFFF3F5FB),
    surfaceContainerHighest: Color(0xFF232838),
    outline: Color(0xFF282E40),
    error: Color(0xFFF08A90),
    onError: Color(0xFF0C0F1A),
    errorContainer: Color(0xFF2D1518),
    onErrorContainer: Color(0xFFF08A90),
  ),
  extensions: const [DataComStatusColors.dark],
);
