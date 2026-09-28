import 'status_level.dart';

class CriticalBanner {
  const CriticalBanner({required this.criticalCount, required this.detail});

  final int criticalCount;
  final String detail;
}

class HealthCount {
  const HealthCount({required this.count, required this.labelKey, this.level});

  final int count;
  final String labelKey;
  final StatusLevel? level;
}

class LatencySample {
  const LatencySample({
    required this.values,
    required this.p50,
    required this.p95,
    required this.throughput,
    required this.peak,
  });

  final List<double> values;
  final String p50;
  final String p95;
  final String throughput;
  final String peak;
}

class LiveMetric {
  const LiveMetric({
    required this.labelKey,
    required this.value,
    required this.sub,
    this.level,
  });

  final String labelKey;
  final String value;
  final String sub;
  final StatusLevel? level;
}

class ActivityEntry {
  const ActivityEntry({
    required this.time,
    required this.text,
    required this.source,
    required this.level,
  });

  final String time;
  final String text;
  final String source;
  final StatusLevel level;
}

class DashboardOverview {
  const DashboardOverview({
    this.criticalBanner,
    required this.healthCounts,
    required this.latency,
    required this.liveMetrics,
    required this.activity,
  });

  final CriticalBanner? criticalBanner;
  final List<HealthCount> healthCounts;
  final LatencySample latency;
  final List<LiveMetric> liveMetrics;
  final List<ActivityEntry> activity;
}
