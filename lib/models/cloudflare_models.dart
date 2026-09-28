import 'status_level.dart';
import 'vercel_models.dart' show LogLine;

class CfMetric {
  const CfMetric(this.label, this.value, this.sub, [this.level]);

  final String label;
  final String value;
  final String sub;
  final StatusLevel? level;
}

class CfZone {
  const CfZone({
    required this.name,
    required this.plan,
    required this.records,
    required this.ssl,
    required this.requests,
    required this.level,
  });

  final String name;
  final String plan;
  final String records;
  final String ssl;
  final String requests;
  final StatusLevel level;
}

class DnsRecord {
  const DnsRecord({
    required this.type,
    required this.name,
    required this.value,
    required this.proxy,
    required this.proxied,
  });

  final String type;
  final String name;
  final String value;
  final String proxy;
  final bool proxied;
}

class CfWorkerStat {
  const CfWorkerStat(this.label, this.value, [this.alert = false]);

  final String label;
  final String value;
  final bool alert;
}

class CfWorker {
  const CfWorker({
    required this.name,
    required this.deployed,
    required this.level,
    required this.stats,
  });

  final String name;
  final String deployed;
  final StatusLevel level;
  final List<CfWorkerStat> stats;
}

class SecurityEvent {
  const SecurityEvent({
    required this.action,
    required this.level,
    required this.rule,
    required this.count,
    required this.ago,
    required this.detail,
  });

  final String action;
  final StatusLevel level;
  final String rule;
  final String count;
  final String ago;
  final String detail;
}

class CloudflareOverview {
  const CloudflareOverview({
    required this.metrics,
    required this.zones,
    required this.dns,
    required this.workers,
    required this.workerLog,
    required this.security,
  });

  final List<CfMetric> metrics;
  final List<CfZone> zones;
  final List<DnsRecord> dns;
  final List<CfWorker> workers;
  final List<LogLine> workerLog;
  final List<SecurityEvent> security;
}
