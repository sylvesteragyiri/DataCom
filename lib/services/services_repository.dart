import '../models/service_models.dart';
import '../models/status_level.dart';

abstract class ServicesRepository {
  Future<ServicesOverview> getOverview();
}

/// Local, static-data implementation — see MockDashboardRepository for the
/// rationale (docs/NAVIGATION_MAP.md swappability principle).
class MockServicesRepository implements ServicesRepository {
  @override
  Future<ServicesOverview> getOverview() async => const ServicesOverview(
    groups: [
      ConnectionGroup(
        name: 'Databases',
        meta: '5 · 1 critical',
        items: [
          ConnectionItem(
            name: 'orders-primary',
            host: 'pg://10.0.4.11:5432/orders',
            abbr: 'PG',
            status: StatusLevel.critical,
            latency: '8 ms',
          ),
          ConnectionItem(
            name: 'orders-replica',
            host: 'pg://10.0.4.12:5432/orders',
            abbr: 'PG',
            status: StatusLevel.warn,
            latency: '11 ms',
          ),
          ConnectionItem(
            name: 'billing-mysql',
            host: 'mysql://10.0.6.3:3306/billing',
            abbr: 'MY',
            status: StatusLevel.ok,
            latency: '6 ms',
          ),
          ConnectionItem(
            name: 'analytics-mariadb',
            host: 'mysql://10.0.6.9:3306/analytics',
            abbr: 'MA',
            status: StatusLevel.ok,
            latency: '9 ms',
          ),
          ConnectionItem(
            name: 'edge-cache.sqlite',
            host: 'file:///data/edge-cache.sqlite',
            abbr: 'SQ',
            status: StatusLevel.ok,
            latency: '1 ms',
          ),
        ],
      ),
      ConnectionGroup(
        name: 'Redis',
        meta: '2 · 1 warning',
        items: [
          ConnectionItem(
            name: 'session-cache',
            host: 'redis://10.0.8.2:6379',
            abbr: 'RD',
            status: StatusLevel.warn,
            latency: '2 ms',
          ),
          ConnectionItem(
            name: 'queue-bus',
            host: 'redis://cluster.acme.internal:6379',
            abbr: 'RC',
            status: StatusLevel.ok,
            latency: '3 ms',
          ),
        ],
      ),
      ConnectionGroup(
        name: 'Object storage',
        meta: '4 · healthy',
        items: [
          ConnectionItem(
            name: 'assets-prod',
            host: 's3.eu-west-1.amazonaws.com',
            abbr: 'S3',
            status: StatusLevel.ok,
            latency: '41 ms',
          ),
          ConnectionItem(
            name: 'media-cdn',
            host: 'media.r2.cloudflarestorage.com',
            abbr: 'R2',
            status: StatusLevel.ok,
            latency: '29 ms',
          ),
          ConnectionItem(
            name: 'backups-minio',
            host: 'minio.acme.internal:9000',
            abbr: 'MI',
            status: StatusLevel.ok,
            latency: '7 ms',
          ),
          ConnectionItem(
            name: 'uploads-spaces',
            host: 'ams3.digitaloceanspaces.com',
            abbr: 'DO',
            status: StatusLevel.warn,
            latency: '58 ms',
          ),
        ],
      ),
    ],
    cloudCards: [
      CloudCard(
        name: 'Cloudflare',
        sub: 'acme.io · 4 zones',
        abbr: 'CF',
        status: StatusLevel.ok,
        stats: [
          CloudStat('workers', '12'),
          CloudStat('5xx / min', '0'),
          CloudStat('cache hit', '98.4%'),
        ],
      ),
      CloudCard(
        name: 'Vercel',
        sub: 'storefront · production',
        abbr: 'VC',
        status: StatusLevel.warn,
        stats: [
          CloudStat('building', '1'),
          CloudStat('last build', '2m 41s'),
          CloudStat('p95 edge', '214 ms'),
        ],
      ),
      CloudCard(
        name: 'Laravel Cloud',
        sub: 'api-gateway · eu',
        abbr: 'LC',
        status: StatusLevel.ok,
        stats: [
          CloudStat('queues', '4'),
          CloudStat('failed jobs', '0'),
          CloudStat('cpu', '62%'),
        ],
      ),
    ],
  );
}
