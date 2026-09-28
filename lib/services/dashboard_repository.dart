import '../models/dashboard_models.dart';
import '../models/status_level.dart';

abstract class DashboardRepository {
  Future<DashboardOverview> getOverview();
}

/// Local, static-data implementation. Stands in for real connector polling
/// until Phase 3 wires up actual data sources — see the swappability
/// principle in docs/NAVIGATION_MAP.md. Screens depend on
/// [DashboardRepository], never on this class directly.
class MockDashboardRepository implements DashboardRepository {
  @override
  Future<DashboardOverview> getOverview() async {
    return const DashboardOverview(
      criticalBanner: CriticalBanner(
        criticalCount: 2,
        detail:
            'orders-primary is at 96% of its connection pool. '
            'storefront-web is throwing a TypeError at 248×/min.',
      ),
      healthCounts: [
        HealthCount(count: 13, labelKey: 'health_connected'),
        HealthCount(count: 9, labelKey: 'health_healthy', level: StatusLevel.ok),
        HealthCount(count: 2, labelKey: 'health_warning', level: StatusLevel.warn),
        HealthCount(count: 2, labelKey: 'health_critical', level: StatusLevel.critical),
      ],
      latency: LatencySample(
        values: [
          38, 42, 40, 55, 48, 44, 61, 52, 49, 58, 72, 66,
          61, 88, 74, 69, 92, 110, 96, 84, 120, 142, 118, 96,
        ],
        p50: '184 ms',
        p95: '912 ms',
        throughput: '1.2k rps',
        peak: '1.42 s',
      ),
      liveMetrics: [
        LiveMetric(
          labelKey: 'metric_requests',
          value: '1.24 k/s',
          sub: 'nightwatch',
        ),
        LiveMetric(
          labelKey: 'metric_exceptions',
          value: '248/min',
          sub: 'up 40× since 14:02',
          level: StatusLevel.critical,
        ),
        LiveMetric(
          labelKey: 'metric_queue_jobs',
          value: '8.2k',
          sub: '0 failed',
          level: StatusLevel.ok,
        ),
        LiveMetric(
          labelKey: 'metric_p95_response',
          value: '912 ms',
          sub: 'budget 500 ms',
          level: StatusLevel.warn,
        ),
      ],
      activity: [
        ActivityEntry(
          time: '14:43',
          text: 'Deployment dpl_9fK2 started',
          source: 'vercel · storefront',
          level: StatusLevel.warn,
        ),
        ActivityEntry(
          time: '14:38',
          text: 'orders-primary crossed 90% pool usage',
          source: 'postgres',
          level: StatusLevel.critical,
        ),
        ActivityEntry(
          time: '14:31',
          text: '1,204 keys evicted (allkeys-lru)',
          source: 'session-cache',
          level: StatusLevel.warn,
        ),
        ActivityEntry(
          time: '14:12',
          text: 'Nightly backup uploaded, 2.8 GB',
          source: 'backups-minio',
          level: StatusLevel.ok,
        ),
        ActivityEntry(
          time: '13:58',
          text: 'Horizon workers scaled 4 → 8',
          source: 'laravel cloud',
          level: StatusLevel.info,
        ),
      ],
    );
  }
}
