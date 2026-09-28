import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_models.dart';
import '../providers/services_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_sheet.dart';
import '../widgets/datacom_toast.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(servicesOverviewProvider);

    return Scaffold(
      appBar: DataComAppBar(
        title: 'services_title'.tr(),
        subtitle: 'services_subtitle'.tr(),
        onRefresh: () => showDataComToast(context, 'toast_refreshed'.tr()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDataComToast(context, 'toast_coming_soon'.tr()),
        icon: const Icon(Icons.add),
        label: Text('services_add_connection'.tr()),
      ),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) => _ServicesBody(data: data),
      ),
    );
  }
}

class _ServicesBody extends StatelessWidget {
  const _ServicesBody({required this.data});

  final ServicesOverview data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 96),
      children: [
        for (final group in data.groups) ...[
          _GroupHeader(name: group.name, meta: group.meta),
          const SizedBox(height: 6),
          for (final item in group.items) ...[
            _ConnectionCard(item: item),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 6),
        ],
        Text(
          'services_cloud_title'.tr(),
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        for (final cloud in data.cloudCards) ...[
          _CloudCardTile(cloud: cloud),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.name, required this.meta});

  final String name;
  final String meta;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500)),
          Text(meta, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard({required this.item});

  final ConnectionItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final color = statusColor(context, item.status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: DataComCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            onTap: () => showDataComToast(context, 'toast_coming_soon'.tr()),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.abbr,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(item.host, style: textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(height: 3),
                    Text(item.latency, style: textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 2),
        SizedBox(
          width: 36,
          child: Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colors.outline),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => showDataComSheet(
                context,
                title: item.name,
                actions: [
                  DataComSheetAction(
                    icon: Icons.refresh,
                    label: 'sheet_refresh_now'.tr(),
                    onTap: () => showDataComToast(
                      context,
                      'toast_refreshed_one'.tr(namedArgs: {'name': item.name}),
                    ),
                  ),
                  DataComSheetAction(
                    icon: Icons.star_outline,
                    label: 'sheet_pin_dashboard'.tr(),
                    onTap: () => showDataComToast(
                      context,
                      'toast_pinned'.tr(namedArgs: {'name': item.name}),
                    ),
                  ),
                  DataComSheetAction(
                    icon: Icons.edit_outlined,
                    label: 'sheet_edit_connection'.tr(),
                    onTap: () => showDataComToast(context, 'toast_coming_soon'.tr()),
                  ),
                  DataComSheetAction(
                    icon: Icons.delete_outline,
                    label: 'sheet_remove_device'.tr(),
                    destructive: true,
                    onTap: () => showDataComToast(
                      context,
                      'toast_removed'.tr(namedArgs: {'name': item.name}),
                    ),
                  ),
                ],
              ),
              child: Icon(Icons.more_vert, color: colors.onSurfaceVariant, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _CloudCardTile extends StatelessWidget {
  const _CloudCardTile({required this.cloud});

  final CloudCard cloud;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = statusColor(context, cloud.status);

    return DataComCard(
      onTap: () => showDataComToast(context, 'toast_coming_soon'.tr()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  cloud.abbr,
                  style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: color),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cloud.name, style: textTheme.titleSmall),
                    Text(cloud.sub, style: textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final stat in cloud.stats) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stat.value, style: textTheme.titleSmall),
                    Text(stat.label, style: textTheme.bodySmall),
                  ],
                ),
                const SizedBox(width: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
