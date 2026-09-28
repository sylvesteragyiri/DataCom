import 'status_level.dart';

class RedisMetric {
  const RedisMetric(this.label, this.value, this.sub, [this.level]);

  final String label;
  final String value;
  final String sub;
  final StatusLevel? level;
}

class RedisReplica {
  const RedisReplica(this.name, this.lag, this.level);

  final String name;
  final String lag;
  final StatusLevel level;
}

class RedisKeyEntry {
  const RedisKeyEntry(this.key, this.type, this.size, this.ttl, this.level);

  final String key;
  final String type;
  final String size;
  final String ttl;
  final StatusLevel level;
}

class RedisSlowlogEntry {
  const RedisSlowlogEntry(this.duration, this.ago, this.command, this.level);

  final String duration;
  final String ago;
  final String command;
  final StatusLevel level;
}

class RedisOverview {
  const RedisOverview({
    required this.memoryUsedGb,
    required this.memoryMaxGb,
    required this.memoryPercent,
    required this.evictionPolicy,
    required this.evictedLastHour,
    required this.metrics,
    required this.replicas,
    required this.keys,
    required this.slowlog,
  });

  final double memoryUsedGb;
  final double memoryMaxGb;
  final int memoryPercent;
  final String evictionPolicy;
  final int evictedLastHour;
  final List<RedisMetric> metrics;
  final List<RedisReplica> replicas;
  final List<RedisKeyEntry> keys;
  final List<RedisSlowlogEntry> slowlog;
}
