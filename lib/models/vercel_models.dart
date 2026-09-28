import 'console_emphasis.dart';
import 'status_level.dart';

class Deployment {
  const Deployment({
    required this.sha,
    required this.state,
    required this.level,
    required this.message,
    required this.branch,
    required this.duration,
    required this.ago,
  });

  final String sha;
  final String state;
  final StatusLevel level;
  final String message;
  final String branch;
  final String duration;
  final String ago;
}

class LogLine {
  const LogLine(this.time, this.text, [this.emphasis = ConsoleEmphasis.normal]);

  final String time;
  final String text;
  final ConsoleEmphasis emphasis;
}

class VercelOverview {
  const VercelOverview({required this.deployments, required this.buildLog});

  final List<Deployment> deployments;
  final List<LogLine> buildLog;
}
