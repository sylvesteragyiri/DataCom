import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/database_models.dart';
import '../models/status_level.dart';
import '../providers/database_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_console.dart';
import '../widgets/datacom_segmented_tabs.dart';

class DatabaseDetailScreen extends ConsumerStatefulWidget {
  const DatabaseDetailScreen({super.key, required this.connectionId, required this.title});

  final String connectionId;
  final String title;

  @override
  ConsumerState<DatabaseDetailScreen> createState() => _DatabaseDetailScreenState();
}

class _DatabaseDetailScreenState extends ConsumerState<DatabaseDetailScreen> {
  int _tab = 0;
  int _openQueryIndex = -1;
  int _snippetIndex = 0;
  bool _sqlRan = false;

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(databaseOverviewProvider(widget.connectionId));

    return Scaffold(
      appBar: DataComAppBar(
        title: widget.title,
        subtitle: 'database_subtitle'.tr(),
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) => Padding(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DataComSegmentedTabs(
                labels: [
                  'database_tab_health'.tr(),
                  'database_tab_queries'.tr(),
                  'database_tab_schema'.tr(),
                  'database_tab_sql'.tr(),
                ],
                selectedIndex: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: switch (_tab) {
                  0 => _HealthTab(data: data),
                  1 => _QueriesTab(
                    queries: data.slowQueries,
                    openIndex: _openQueryIndex,
                    onToggle: (i) => setState(() => _openQueryIndex = _openQueryIndex == i ? -1 : i),
                  ),
                  2 => _SchemaTab(
                    tables: data.tables,
                    onOpenTable: (name) =>
                        context.push('/services/db/${widget.connectionId}/table/$name', extra: widget.title),
                  ),
                  _ => _SqlTab(
                    snippets: data.snippets,
                    snippetIndex: _snippetIndex,
                    onPickSnippet: (i) => setState(() {
                      _snippetIndex = i;
                      _sqlRan = false;
                    }),
                    ran: _sqlRan,
                    onRun: () => setState(() => _sqlRan = true),
                    resultRows: data.resultRows,
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HealthTab extends StatelessWidget {
  const _HealthTab({required this.data});

  final DatabaseOverview data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final critColor = statusColor(context, StatusLevel.critical);
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: critColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('database_pool_title'.tr(), style: textTheme.bodyLarge),
              const SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: data.poolPercent / 100,
                        minHeight: 8,
                        backgroundColor: Colors.black.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation(critColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${data.poolUsed}/${data.poolMax}', style: textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.4,
          children: [
            for (final metric in data.metrics)
              DataComCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(metric.label, style: textTheme.bodySmall),
                    Text(
                      metric.value,
                      style: textTheme.titleMedium?.copyWith(color: statusColor(context, metric.level)),
                    ),
                    Text(metric.sub, style: textTheme.bodySmall),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text('database_running_queries_title'.tr(), style: textTheme.titleSmall),
        const SizedBox(height: 6),
        DataComCard(
          child: Column(
            children: [
              for (final query in data.running)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 52,
                        child: Text(
                          query.duration,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: statusColor(context, query.level),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          query.sql,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QueriesTab extends StatelessWidget {
  const _QueriesTab({required this.queries, required this.openIndex, required this.onToggle});

  final List<SlowQuery> queries;
  final int openIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Text('database_slow_query_hint'.tr(), style: textTheme.bodySmall),
        const SizedBox(height: 8),
        for (var i = 0; i < queries.length; i++) ...[
          _SlowQueryCard(query: queries[i], open: i == openIndex, onToggle: () => onToggle(i)),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SlowQueryCard extends StatelessWidget {
  const _SlowQueryCard({required this.query, required this.open, required this.onToggle});

  final SlowQuery query;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return DataComCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(query.sql, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              query.mean,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: statusColor(context, query.level),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('${query.calls} calls', style: textTheme.bodySmall),
                            const SizedBox(width: 10),
                            Text(query.share, style: textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(open ? Icons.expand_less : Icons.expand_more, color: colors.onSurfaceVariant),
                ],
              ),
            ),
          ),
          if (open)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EXPLAIN ANALYZE', style: textTheme.labelMedium),
                  const SizedBox(height: 6),
                  DataComConsole(
                    lines: [for (final line in query.plan) ConsoleLine(line.text, line.emphasis)],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(query.hint, style: textTheme.bodySmall),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SchemaTab extends StatelessWidget {
  const _SchemaTab({required this.tables, required this.onOpenTable});

  final List<DbTable> tables;
  final ValueChanged<String> onOpenTable;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        for (final table in tables) ...[
          DataComCard(
            onTap: () => onOpenTable(table.name),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(table.name, style: const TextStyle(fontFamily: 'monospace', fontSize: 14)),
                      Text(
                        'database_table_meta'.tr(
                          namedArgs: {'rows': table.rows, 'cols': table.cols, 'idx': table.idx},
                        ),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(table.size, style: textTheme.bodySmall),
                Icon(Icons.chevron_right, size: 18, color: colors.onSurfaceVariant),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SqlTab extends StatelessWidget {
  const _SqlTab({
    required this.snippets,
    required this.snippetIndex,
    required this.onPickSnippet,
    required this.ran,
    required this.onRun,
    required this.resultRows,
  });

  final List<SqlSnippet> snippets;
  final int snippetIndex;
  final ValueChanged<int> onPickSnippet;
  final bool ran;
  final VoidCallback onRun;
  final List<DbRow> resultRows;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currentSql = snippets[snippetIndex].sql;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        DataComConsole(lines: [for (final line in currentSql.split('\n')) ConsoleLine(line)]),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < snippets.length; i++) ...[
                _SnippetChip(
                  label: snippets[i].label,
                  selected: i == snippetIndex,
                  onTap: () => onPickSnippet(i),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: onRun,
          child: Text('database_run_query'.tr()),
        ),
        if (ran) ...[
          const SizedBox(height: 12),
          Text('database_sql_result_meta'.tr(), style: textTheme.bodySmall),
          const SizedBox(height: 6),
          for (final row in resultRows) ...[
            DataComCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(row.head, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor(context, row.level).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          row.status,
                          style: textTheme.labelSmall?.copyWith(color: statusColor(context, row.level)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  for (final field in row.fields)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 96,
                            child: Text(
                              field.key,
                              style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: textTheme.bodySmall?.color),
                            ),
                          ),
                          Expanded(
                            child: Text(field.value, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ],
    );
  }
}

class _SnippetChip extends StatelessWidget {
  const _SnippetChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected ? colors.primaryContainer : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: selected ? colors.primaryContainer : colors.outline),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: selected ? colors.onPrimaryContainer : colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
