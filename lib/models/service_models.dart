import 'status_level.dart';

class ConnectionItem {
  const ConnectionItem({
    required this.name,
    required this.host,
    required this.abbr,
    required this.status,
    required this.latency,
  });

  final String name;
  final String host;
  final String abbr;
  final StatusLevel status;
  final String latency;
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
