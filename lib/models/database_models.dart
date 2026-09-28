import 'console_emphasis.dart';
import 'status_level.dart';

class DbMetric {
  const DbMetric(this.label, this.value, this.sub, [this.level]);

  final String label;
  final String value;
  final String sub;
  final StatusLevel? level;
}

class RunningQuery {
  const RunningQuery(this.duration, this.sql, this.level);

  final String duration;
  final String sql;
  final StatusLevel level;
}

class PlanLine {
  const PlanLine(this.text, [this.emphasis = ConsoleEmphasis.normal]);

  final String text;
  final ConsoleEmphasis emphasis;
}

class SlowQuery {
  const SlowQuery({
    required this.sql,
    required this.mean,
    required this.calls,
    required this.share,
    required this.level,
    required this.plan,
    required this.hint,
  });

  final String sql;
  final String mean;
  final String calls;
  final String share;
  final StatusLevel level;
  final List<PlanLine> plan;
  final String hint;
}

class DbTable {
  const DbTable(this.name, this.rows, this.cols, this.idx, this.size);

  final String name;
  final String rows;
  final String cols;
  final String idx;
  final String size;
}

class DbColumn {
  const DbColumn(this.name, this.type, this.badge);

  final String name;
  final String type;
  final String badge;
}

class DbIndex {
  const DbIndex(this.name, this.def, this.stat, this.level);

  final String name;
  final String def;
  final String stat;
  final StatusLevel level;
}

class FieldKV {
  const FieldKV(this.key, this.value);

  final String key;
  final String value;
}

class DbRow {
  const DbRow(this.head, this.status, this.level, this.fields);

  final String head;
  final String status;
  final StatusLevel level;
  final List<FieldKV> fields;
}

class SqlSnippet {
  const SqlSnippet(this.label, this.sql);

  final String label;
  final String sql;
}

class DatabaseOverview {
  const DatabaseOverview({
    required this.poolUsed,
    required this.poolMax,
    required this.poolPercent,
    required this.metrics,
    required this.running,
    required this.slowQueries,
    required this.tables,
    required this.snippets,
    required this.resultRows,
  });

  final int poolUsed;
  final int poolMax;
  final int poolPercent;
  final List<DbMetric> metrics;
  final List<RunningQuery> running;
  final List<SlowQuery> slowQueries;
  final List<DbTable> tables;
  final List<SqlSnippet> snippets;
  final List<DbRow> resultRows;
}

class TableOverview {
  const TableOverview({required this.columns, required this.indexes, required this.rows});

  final List<DbColumn> columns;
  final List<DbIndex> indexes;
  final List<DbRow> rows;
}
