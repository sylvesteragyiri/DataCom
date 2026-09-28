import 'console_emphasis.dart';
import 'status_level.dart';

class TraceLine {
  const TraceLine(this.text, [this.emphasis = ConsoleEmphasis.normal]);

  final String text;
  final ConsoleEmphasis emphasis;
}

class AlertMetric {
  const AlertMetric(this.label, this.value);

  final String label;
  final String value;
}

enum AlertTarget { database, redis, monitor }

class Alert {
  const Alert({
    required this.id,
    required this.level,
    required this.levelLabel,
    required this.title,
    required this.detail,
    required this.source,
    required this.ago,
    required this.ctaLabel,
    required this.traceLabel,
    required this.metrics,
    required this.trace,
    required this.target,
    this.targetConnectionId,
  });

  final int id;
  final StatusLevel level;
  final String levelLabel;
  final String title;
  final String detail;
  final String source;
  final String ago;
  final String ctaLabel;
  final String traceLabel;
  final List<AlertMetric> metrics;
  final List<TraceLine> trace;
  final AlertTarget target;
  final String? targetConnectionId;
}

class Issue {
  const Issue({
    required this.level,
    required this.levelLabel,
    required this.type,
    required this.message,
    required this.events,
    required this.users,
  });

  final StatusLevel level;
  final String levelLabel;
  final String type;
  final String message;
  final String events;
  final String users;
}
