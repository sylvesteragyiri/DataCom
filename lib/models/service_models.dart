import 'status_level.dart';

enum ConnectionKind { database, redis, storage }

class ConnectionItem {
  const ConnectionItem({
    required this.name,
    required this.host,
    required this.abbr,
    required this.status,
    required this.latency,
    required this.kind,
  });

  final String name;
  final String host;
  final String abbr;
  final StatusLevel status;
  final String latency;
  final ConnectionKind kind;
}

class ConnectionGroup {
  const ConnectionGroup({required this.name, required this.meta, required this.items});

  final String name;
  final String meta;
  final List<ConnectionItem> items;
}

class CloudStat {
  const CloudStat(this.label, this.value);

  final String label;
  final String value;
}

class CloudCard {
  const CloudCard({
    required this.name,
    required this.sub,
    required this.abbr,
    required this.status,
    required this.stats,
  });

  final String name;
  final String sub;
  final String abbr;
  final StatusLevel status;
  final List<CloudStat> stats;
}

class ServicesOverview {
  const ServicesOverview({required this.groups, required this.cloudCards});

  final List<ConnectionGroup> groups;
  final List<CloudCard> cloudCards;
}

class ConnectorType {
  const ConnectorType(this.name, this.abbr);

  final String name;
  final String abbr;
}

class ConnectorTypeGroup {
  const ConnectorTypeGroup(this.name, this.items);

  final String name;
  final List<ConnectorType> items;
}

/// Connector catalog the app itself defines — fixed, not sourced from a
/// repository (unlike ServicesOverview, this isn't "data" that could vary
/// per user/backend).
const connectorTypeGroups = [
  ConnectorTypeGroup('Databases', [
    ConnectorType('PostgreSQL', 'PG'),
    ConnectorType('MySQL', 'MY'),
    ConnectorType('MariaDB', 'MA'),
    ConnectorType('SQLite', 'SQ'),
    ConnectorType('SQL Server', 'MS'),
  ]),
  ConnectorTypeGroup('Cache & storage', [
    ConnectorType('Redis', 'RD'),
    ConnectorType('AWS S3', 'S3'),
    ConnectorType('Cloudflare R2', 'R2'),
    ConnectorType('MinIO', 'MI'),
    ConnectorType('DO Spaces', 'DO'),
  ]),
  ConnectorTypeGroup('Cloud & observability', [
    ConnectorType('Cloudflare', 'CF'),
    ConnectorType('Vercel', 'VC'),
    ConnectorType('Laravel Cloud', 'LC'),
    ConnectorType('Nightwatch', 'NW'),
    ConnectorType('Sentry', 'SY'),
  ]),
];
