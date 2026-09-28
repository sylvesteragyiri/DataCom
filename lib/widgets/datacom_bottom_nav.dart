import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum DataComNavIcon { home, services, settings }

/// Floating, pill-shaped, icon-only bottom nav — translated directly from
/// the nav markup in design-reference/DataCom Calm.dc.html (a centered
/// `width:max-content` pill, `border-radius:100px`, 16px floating margin,
/// 38px circular icon buttons, no visible labels — `aria-label`/`title`
/// only). Do not replace this with Flutter's standard `NavigationBar`
/// (docked, full-width, text labels) — that was tried once and didn't match.
class DataComBottomNav extends StatelessWidget {
  const DataComBottomNav({super.key, required this.currentIndex, required this.onSelect});

  final int currentIndex;
  final ValueChanged<int> onSelect;

  static const _items = [
    (icon: DataComNavIcon.home, labelKey: 'nav_home', badge: true),
    (icon: DataComNavIcon.services, labelKey: 'nav_services', badge: true),
    (icon: DataComNavIcon.settings, labelKey: 'nav_settings', badge: false),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _items.length; i++)
            _NavButton(
              icon: _items[i].icon,
              label: _items[i].labelKey.tr(),
              showBadge: _items[i].badge,
              selected: i == currentIndex,
              onTap: () => onSelect(i),
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.showBadge,
    required this.selected,
    required this.onTap,
  });

  final DataComNavIcon icon;
  final String label;
  final bool showBadge;
  final bool selected;
  final VoidCallback onTap;

  static const _size = 38.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fg = selected ? colors.onPrimary : colors.onSurfaceVariant;

    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        button: true,
        selected: selected,
        child: Material(
          color: selected ? colors.primary : Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: _size,
              height: _size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _NavIconGlyph(icon: icon, color: fg, size: 19),
                  if (showBadge)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: colors.error,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.surface, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIconGlyph extends StatelessWidget {
  const _NavIconGlyph({required this.icon, required this.color, required this.size});

  final DataComNavIcon icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _NavIconPainter(icon: icon, color: color),
    );
  }
}

/// Redraws the design's exact SVG path data (viewBox 0 0 24 24, stroke-width
/// 1.8, round caps/joins) rather than substituting a Material icon.
class _NavIconPainter extends CustomPainter {
  _NavIconPainter({required this.icon, required this.color});

  final DataComNavIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.save();
    canvas.scale(scale);

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (icon) {
      case DataComNavIcon.home:
        final path = Path()
          ..moveTo(3, 9.5)
          ..lineTo(12, 2.5)
          ..lineTo(21, 9.5)
          ..lineTo(21, 20)
          ..arcToPoint(const Offset(19.5, 21.5), radius: const Radius.circular(1.5))
          ..lineTo(4.5, 21.5)
          ..arcToPoint(const Offset(3, 20), radius: const Radius.circular(1.5))
          ..close();
        canvas.drawPath(path, strokePaint);
      case DataComNavIcon.services:
        canvas.drawRect(const Rect.fromLTRB(4, 4.5, 20, 9.5), strokePaint);
        canvas.drawRect(const Rect.fromLTRB(4, 14.5, 20, 19.5), strokePaint);
        final dotPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(const Offset(7.5, 7), 0.9, dotPaint);
        canvas.drawCircle(const Offset(7.5, 17), 0.9, dotPaint);
      case DataComNavIcon.settings:
        canvas.drawLine(const Offset(4, 7), const Offset(13, 7), strokePaint);
        canvas.drawLine(const Offset(16, 7), const Offset(20, 7), strokePaint);
        canvas.drawLine(const Offset(4, 17), const Offset(8, 17), strokePaint);
        canvas.drawLine(const Offset(11, 17), const Offset(20, 17), strokePaint);
        canvas.drawLine(const Offset(13, 4.5), const Offset(13, 9.5), strokePaint);
        canvas.drawLine(const Offset(8, 14.5), const Offset(8, 19.5), strokePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NavIconPainter oldDelegate) {
    return oldDelegate.icon != icon || oldDelegate.color != color;
  }
}
