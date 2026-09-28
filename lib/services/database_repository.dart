import '../models/console_emphasis.dart';
import '../models/database_models.dart';
import '../models/status_level.dart';

abstract class DatabaseRepository {
  Future<DatabaseOverview> getOverview(String connectionId);
  Future<TableOverview> getTable(String connectionId, String tableName);
}

class MockDatabaseRepository implements DatabaseRepository {
  static const _resultRowFields = [
    FieldKV('application', 'checkout-worker'),
    FieldKV('oldest', '00:06:12'),
    FieldKV('avg', '00:02:41'),
  ];

  @override
  Future<DatabaseOverview> getOverview(String connectionId) async => const DatabaseOverview(
    poolUsed: 192,
    poolMax: 200,
    poolPercent: 96,
    metrics: [
      DbMetric('Latency', '8 ms', 'p95 24 ms', StatusLevel.ok),
      DbMetric('Transactions', '412/s', 'commit 99.8%'),
      DbMetric('Cache hit', '99.1%', 'shared buffers', StatusLevel.ok),
      DbMetric('Locks waiting', '14', 'tuple locks', StatusLevel.critical),
      DbMetric('Database size', '3.4 GB', '+120 MB / 24h'),
      DbMetric('Replication', '42 s', 'orders-replica', StatusLevel.warn),
    ],
    running: [
      RunningQuery(
        '2m 07s',
        'UPDATE inventory SET reserved = reserved + 1 WHERE sku = \$1',
        StatusLevel.critical,
      ),
      RunningQuery(
        '41 s',
        'SELECT o.*, c.email FROM orders o JOIN customers c …',
        StatusLevel.warn,
      ),
      RunningQuery('2 s', 'COPY events (id, type, payload) TO STDOUT', StatusLevel.info),
    ],
    slowQueries: [
      SlowQuery(
        sql:
            'SELECT o.*, c.email FROM orders o JOIN customers c ON c.id = o.customer_id '
            'WHERE o.status = \$1 ORDER BY o.created_at DESC LIMIT 50',
        mean: '4.21 s',
        calls: '142',
        share: '38% of time',
        level: StatusLevel.critical,
        plan: [
          PlanLine('Limit  (cost=98421..98421 rows=50)'),
          PlanLine(' Sort  (actual time=4180..4181 rows=50)'),
          PlanLine('  Sort Key: o.created_at DESC', ConsoleEmphasis.muted),
          PlanLine('  Hash Join  (actual time=812..3990)'),
          PlanLine('   Seq Scan on orders o  rows=1248913', ConsoleEmphasis.danger),
          PlanLine('    Filter: (status = \$1)  removed 1.19M', ConsoleEmphasis.warn),
        ],
        hint:
            'orders_created_at_idx is not selected because status has no supporting index. '
            'A composite index on (status, created_at desc) removes the sequential scan.',
      ),
      SlowQuery(
        sql: 'UPDATE inventory SET reserved = reserved + \$1 WHERE sku = \$2',
        mean: '2.91 s',
        calls: '1,024',
        share: '24% of time',
        level: StatusLevel.critical,
        plan: [
          PlanLine('Update on inventory  (actual time=2905..2905)'),
          PlanLine(' Index Scan using inventory_sku_key'),
          PlanLine('  Rows Removed by Lock Wait: 0', ConsoleEmphasis.muted),
          PlanLine('  Lock wait: 2.84 s on tuple lock', ConsoleEmphasis.danger),
        ],
        hint:
            'Time is spent waiting on a row lock, not on the scan. Contending sessions come '
            'from checkout-worker holding open transactions.',
      ),
      SlowQuery(
        sql: "SELECT count(*) FROM events WHERE created_at > now() - interval '24 hours'",
        mean: '1.84 s',
        calls: '96',
        share: '11% of time',
        level: StatusLevel.warn,
        plan: [
          PlanLine('Aggregate  (actual time=1836..1836 rows=1)'),
          PlanLine(' Index Only Scan using events_created_at_idx'),
          PlanLine('  Heap Fetches: 812004', ConsoleEmphasis.warn),
        ],
        hint:
            'High heap fetches indicate the visibility map is stale. A manual VACUUM on '
            'events restores the index-only path.',
      ),
      SlowQuery(
        sql: 'SELECT * FROM order_items WHERE order_id = ANY(\$1)',
        mean: '0.74 s',
        calls: '8,412',
        share: '9% of time',
        level: StatusLevel.warn,
        plan: [
          PlanLine('Index Scan using order_items_order_id_idx'),
          PlanLine(' Rows: 4.8M  loops=214', ConsoleEmphasis.muted),
        ],
        hint: 'Called 214 times per request. Batching the ids into a single call removes most of the round trips.',
      ),
    ],
    tables: [
      DbTable('orders', '1,248,913', '14', '4', '842 MB'),
      DbTable('order_items', '4,812,660', '9', '3', '2.1 GB'),
      DbTable('customers', '312,004', '18', '5', '96 MB'),
      DbTable('inventory', '88,412', '11', '3', '34 MB'),
      DbTable('events', '22,410,882', '7', '2', '412 MB'),
      DbTable('schema_migrations', '182', '2', '1', '48 kB'),
    ],
    snippets: [
      SqlSnippet('pool usage', 'SELECT state, count(*)\n  FROM pg_stat_activity\n GROUP BY state\n ORDER BY 2 DESC;'),
      SqlSnippet(
        'idle in txn',
        "SELECT pid, application_name, now() - xact_start AS dur\n  FROM pg_stat_activity\n"
            " WHERE state = 'idle in transaction'\n ORDER BY dur DESC;",
      ),
      SqlSnippet(
        'table sizes',
        'SELECT relname, pg_size_pretty(pg_total_relation_size(oid))\n  FROM pg_class ORDER BY pg_total_relation_size(oid) DESC;',
      ),
      SqlSnippet('blocking', 'SELECT * FROM pg_locks WHERE NOT granted;'),
    ],
    resultRows: [
      DbRow('idle in transaction', '37 sessions', StatusLevel.critical, _resultRowFields),
      DbRow('active', '54 sessions', StatusLevel.warn, [
        FieldKV('application', 'api-server'),
        FieldKV('oldest', '00:02:07'),
        FieldKV('avg', '00:00:18'),
      ]),
      DbRow('idle', '101 sessions', StatusLevel.ok, [
        FieldKV('application', 'api-server'),
        FieldKV('oldest', '00:14:02'),
        FieldKV('avg', '00:03:20'),
      ]),
    ],
  );

  @override
  Future<TableOverview> getTable(String connectionId, String tableName) async => const TableOverview(
    columns: [
      DbColumn('id', 'bigint · not null', 'PK'),
      DbColumn('customer_id', 'bigint · not null', 'FK'),
      DbColumn('status', "text · not null · default 'pending'", ''),
      DbColumn('total_cents', 'integer · not null', ''),
      DbColumn('currency', 'char(3) · not null', ''),
      DbColumn('shipped_at', 'timestamptz · null', ''),
      DbColumn('created_at', 'timestamptz · not null', 'IDX'),
    ],
    indexes: [
      DbIndex('orders_pkey', 'UNIQUE btree (id)', '412 M scans · 26 MB', StatusLevel.ok),
      DbIndex('orders_customer_id_idx', 'btree (customer_id)', '88 M scans · 18 MB', StatusLevel.ok),
      DbIndex(
        'orders_created_at_idx',
        'btree (created_at DESC)',
        '0 scans · 21 MB · unused',
        StatusLevel.warn,
      ),
      DbIndex(
        'orders_status_idx',
        "btree (status) WHERE status <> 'done'",
        '2.1 M scans · 4 MB',
        StatusLevel.ok,
      ),
    ],
    rows: [
      DbRow('#84 220 913', 'paid', StatusLevel.ok, [
        FieldKV('customer_id', '204 118'),
        FieldKV('total_cents', '12 480'),
        FieldKV('currency', 'EUR'),
        FieldKV('created_at', '2026-08-05 14:12:08'),
      ]),
      DbRow('#84 220 912', 'pending', StatusLevel.warn, [
        FieldKV('customer_id', '88 402'),
        FieldKV('total_cents', '3 900'),
        FieldKV('currency', 'GBP'),
        FieldKV('created_at', '2026-08-05 14:11:52'),
      ]),
      DbRow('#84 220 911', 'failed', StatusLevel.critical, [
        FieldKV('customer_id', '311 006'),
        FieldKV('total_cents', '24 000'),
        FieldKV('currency', 'EUR'),
        FieldKV('created_at', '2026-08-05 14:11:40'),
      ]),
    ],
  );
}
