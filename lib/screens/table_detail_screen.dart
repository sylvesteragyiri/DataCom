import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/database_models.dart';
import '../providers/database_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_segmented_tabs.dart';

class TableDetailScreen extends ConsumerStatefulWidget {
  const TableDetailScreen({
    super.key,
    required this.connectionId,
    required this.tableName,
    required this.connectionTitle,
  });

  final String connectionId;
  final String tableName;
  final String connectionTitle;

  @override
  ConsumerState<TableDetailScreen> createState() => _TableDetailScreenState();
}

class _TableDetailScreenState extends ConsumerState<TableDetailScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(
      tableOverviewProvider((connectionId: widget.connectionId, tableName: widget.tableName)),
    );

    return Scaffold(
      appBar: DataComAppBar(
        title: 'public.${widget.tableName}',
        subtitle: widget.connectionTitle,
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
                  'table_tab_columns'.tr(),
                  'table_tab_indexes'.tr(),
                  'table_tab_rows'.tr(),
                ],
                selectedIndex: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: switch (_tab) {
                  0 => _ColumnsTab(columns: data.columns),
                  1 => _IndexesTab(indexes: data.indexes),
                  _ => _RowsTab(rows: data.rows),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColumnsTab extends StatelessWidget {
  const _ColumnsTab({required this.columns});

  final List<DbColumn> columns;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        DataComCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final column in columns)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(column.name, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                            Text(column.type, style: textTheme.bodySmall),
                          ],
                        ),
                      ),
                      if (column.badge.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            column.badge,
                            style: textTheme.labelSmall?.copyWith(color: colors.onPrimaryContainer),
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

class _IndexesTab extends StatelessWidget {
  const _IndexesTab({required this.indexes});

  final List<DbIndex> indexes;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        for (final index in indexes) ...[
          DataComCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(index.name, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                Text(index.def, style: textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  index.stat,
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: statusColor(context, index.level)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _RowsTab extends StatelessWidget {
  const _RowsTab({required this.rows});

  final List<DbRow> rows;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Text('table_rows_hint'.tr(), style: textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final row in rows) ...[
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
                        SizedBox(width: 96, child: Text(field.key, style: textTheme.bodySmall)),
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
    );
  }
}
