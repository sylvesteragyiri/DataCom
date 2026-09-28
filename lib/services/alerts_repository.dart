import '../models/alert_models.dart';
import '../models/status_level.dart';

abstract class AlertsRepository {
  Future<List<Alert>> getAlerts();
  Future<List<Issue>> getIssues();
}

/// Local, static-data implementation — see MockDashboardRepository for the
/// rationale (docs/NAVIGATION_MAP.md swappability principle).
class MockAlertsRepository implements AlertsRepository {
  @override
  Future<List<Alert>> getAlerts() async => const [
    Alert(
      id: 0,
      level: StatusLevel.critical,
      levelLabel: 'CRITICAL',
      title: 'Connection pool at 96%',
      detail:
          '192 of 200 connections in use for 6 minutes. New checkouts are '
          'queueing behind the pool.',
      source: 'orders-primary · postgres',
      ago: '4m ago',
      ctaLabel: 'Open orders-primary',
      traceLabel: 'pg_stat_activity — longest waiters',
      metrics: [
        AlertMetric('Active', '192'),
        AlertMetric('Idle in txn', '37'),
        AlertMetric('Waiting', '14'),
        AlertMetric('Max', '200'),
      ],
      trace: [
        TraceLine('pid   state                wait_event      dur', TraceEmphasis.muted),
        TraceLine('44182 idle in transaction  ClientRead      00:06:12', TraceEmphasis.danger),
        TraceLine('44190 idle in transaction  ClientRead      00:05:48', TraceEmphasis.danger),
        TraceLine('44231 active               Lock:tuple      00:02:07', TraceEmphasis.warn),
        TraceLine('44240 active               Lock:tuple      00:01:55', TraceEmphasis.warn),
        TraceLine('44255 active               —               00:00:41'),
        TraceLine(''),
        TraceLine('hint: 37 sessions idle in transaction from', TraceEmphasis.muted),
        TraceLine('      checkout-worker (pgbouncer pool 3)', TraceEmphasis.muted),
      ],
    ),
    Alert(
      id: 1,
      level: StatusLevel.critical,
      levelLabel: 'CRITICAL',
      title: 'TypeError spike in checkout',
      detail: '248 events per minute since the 14:02 deploy. Affecting 1,140 users.',
      source: 'storefront-web · sentry',
      ago: '11m ago',
      ctaLabel: 'Open Sentry issue',
      traceLabel: 'Stack trace',
      metrics: [
        AlertMetric('Events/min', '248'),
        AlertMetric('Users', '1,140'),
        AlertMetric('First seen', '14:03'),
        AlertMetric('Release', '2026.8.2'),
      ],
      trace: [
        TraceLine('TypeError: Cannot read properties of undefined', TraceEmphasis.danger),
        TraceLine("  (reading 'total_cents')", TraceEmphasis.danger),
        TraceLine(''),
        TraceLine('at CartSummary (src/checkout/CartSummary.tsx:64)'),
        TraceLine('  62 | const lines = cart.items ?? [];', TraceEmphasis.muted),
        TraceLine('  63 | const ship  = cart.shipping;', TraceEmphasis.muted),
        TraceLine('> 64 | return fmt(ship.total_cents + tax);', TraceEmphasis.warn),
        TraceLine('  65 | }', TraceEmphasis.muted),
        TraceLine('at renderWithHooks (react-dom.js:16305)', TraceEmphasis.muted),
        TraceLine('at beginWork (react-dom.js:19073)', TraceEmphasis.muted),
      ],
    ),
    Alert(
      id: 2,
      level: StatusLevel.warn,
      levelLabel: 'WARNING',
      title: 'Redis memory at 88%',
      detail: '3.52 GB of 4.00 GB maxmemory. 1,204 keys evicted in the last hour.',
      source: 'session-cache · redis',
      ago: '22m ago',
      ctaLabel: 'Open session-cache',
      traceLabel: 'Top key prefixes by memory',
      metrics: [
        AlertMetric('Used', '3.52 GB'),
        AlertMetric('Peak', '3.71 GB'),
        AlertMetric('Evicted', '1,204'),
        AlertMetric('Hit rate', '96.2%'),
      ],
      trace: [
        TraceLine('session:*        1.84 GB   612,004 keys'),
        TraceLine('cart:*           0.91 GB   204,118 keys'),
        TraceLine('rate:*           0.42 GB   988,301 keys', TraceEmphasis.warn),
        TraceLine('search:cache:*   0.28 GB    12,440 keys'),
        TraceLine(''),
        TraceLine('hint: rate:* keys carry no TTL', TraceEmphasis.muted),
      ],
    ),
    Alert(
      id: 3,
      level: StatusLevel.warn,
      levelLabel: 'WARNING',
      title: 'Replica lag 42s',
      detail: 'orders-replica is 42 seconds behind the primary. Reads routed here may be stale.',
      source: 'orders-replica · postgres',
      ago: '31m ago',
      ctaLabel: 'Open orders-replica',
      traceLabel: 'Replication state',
      metrics: [
        AlertMetric('Lag', '42 s'),
        AlertMetric('WAL bytes', '118 MB'),
        AlertMetric('State', 'streaming'),
        AlertMetric('Slot', 'replica_1'),
      ],
      trace: [
        TraceLine('sent_lsn    0/9F3A12C8'),
        TraceLine('write_lsn   0/9F31A004'),
        TraceLine('flush_lsn   0/9F31A004'),
        TraceLine('replay_lsn  0/9E88C110   <- 42s behind', TraceEmphasis.warn),
      ],
    ),
  ];

  @override
  Future<List<Issue>> getIssues() async => const [
    Issue(
      level: StatusLevel.critical,
      levelLabel: 'ERROR',
      type: 'TypeError',
      message: "Cannot read properties of undefined (reading 'total_cents')",
      events: '2.4k',
      users: '1,140',
    ),
    Issue(
      level: StatusLevel.critical,
      levelLabel: 'ERROR',
      type: 'QueryException',
      message: 'SQLSTATE[53300] too many connections for role datacom_rw',
      events: '318',
      users: '204',
    ),
    Issue(
      level: StatusLevel.warn,
      levelLabel: 'WARNING',
      type: 'TimeoutError',
      message: 'Upstream timeout calling payments.acme.io after 5000 ms',
      events: '96',
      users: '88',
    ),
    Issue(
      level: StatusLevel.warn,
      levelLabel: 'WARNING',
      type: 'ChunkLoadError',
      message: 'Loading chunk 4182 failed after release 2026.8.2',
      events: '42',
      users: '40',
    ),
  ];
}
