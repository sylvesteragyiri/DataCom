import 'package:flutter/material.dart';

/// Smoothed line + gradient-fill chart, translated from the SVG cubic-bezier
/// path logic in design-reference/DataCom Calm.dc.html (`chartLine`/`chartArea`).
class LatencyChart extends StatelessWidget {
  const LatencyChart({super.key, required this.values, required this.maxValue});

  final List<double> values;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 96),
      painter: _LatencyChartPainter(
        values: values,
        maxValue: maxValue,
        lineColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _LatencyChartPainter extends CustomPainter {
  _LatencyChartPainter({
    required this.values,
    required this.maxValue,
    required this.lineColor,
  });

  final List<double> values;
  final double maxValue;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final points = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(
          i * (size.width / (values.length - 1)),
          size.height - 8 - (values[i] / maxValue) * (size.height - 20),
        ),
    ];

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlX = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(controlX, prev.dy, controlX, curr.dy, curr.dx, curr.dy);
    }

    final areaPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lineColor.withValues(alpha: 0.22), lineColor.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(areaPath, areaPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    canvas.drawCircle(points.last, 4, Paint()..color = Colors.white);
    canvas.drawCircle(
      points.last,
      4,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  @override
  bool shouldRepaint(covariant _LatencyChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.lineColor != lineColor;
  }
}
