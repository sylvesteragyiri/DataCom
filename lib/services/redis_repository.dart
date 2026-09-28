import '../models/redis_models.dart';
import '../models/status_level.dart';

abstract class RedisRepository {
  Future<RedisOverview> getOverview(String connectionId);
}

class MockRedisRepository implements RedisRepository {
  @override
  Future<RedisOverview> getOverview(String connectionId) async => const RedisOverview(
    memoryUsedGb: 3.52,
    memoryMaxGb: 4.00,
    memoryPercent: 88,
    evictionPolicy: 'allkeys-lru',
    evictedLastHour: 1204,
    metrics: [
      RedisMetric('Keys', '1.24 M', '+42 k / hour'),
      RedisMetric('Ops/sec', '12.4 k', 'peak 18.9 k'),
      RedisMetric('Hit rate', '96.2%', 'miss 3.8%', StatusLevel.ok),
      RedisMetric('Clients', '84', 'blocked 2'),
      RedisMetric('Evicted', '1,204', 'last hour', StatusLevel.warn),
      RedisMetric('Persistence', 'AOF', 'last save 2m ago', StatusLevel.ok),
    ],
    replicas: [
      RedisReplica('session-cache-replica-1', '0.1 s', StatusLevel.ok),
      RedisReplica('session-cache-replica-2', '0.4 s', StatusLevel.ok),
    ],
    keys: [
      RedisKeyEntry('session:u:204118:web', 'hash', '2.4 kB', '23m', StatusLevel.ok),
      RedisKeyEntry('session:u:88402:ios', 'hash', '1.9 kB', '4m', StatusLevel.warn),
      RedisKeyEntry('session:u:311006:web', 'hash', '2.1 kB', '—', StatusLevel.critical),
      RedisKeyEntry('session:idx:active', 'zset', '812 kB', '1h 12m', StatusLevel.ok),
      RedisKeyEntry('session:lock:checkout', 'string', '64 B', '8s', StatusLevel.warn),
    ],
    slowlog: [
      RedisSlowlogEntry('184 ms', '2m ago', 'KEYS session:*', StatusLevel.critical),
      RedisSlowlogEntry('96 ms', '9m ago', 'ZRANGEBYSCORE session:idx:active 0 +inf', StatusLevel.warn),
      RedisSlowlogEntry('62 ms', '14m ago', 'HGETALL cart:u:204118', StatusLevel.warn),
      RedisSlowlogEntry('41 ms', '26m ago', 'SMEMBERS rate:ip:81.2.44.9', StatusLevel.info),
    ],
  );
}
