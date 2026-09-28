import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/cloudflare_models.dart';
import '../models/status_level.dart';
import '../models/vercel_models.dart';
import '../providers/cloudflare_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_console.dart';
import '../widgets/datacom_segmented_tabs.dart';

class CloudflareDetailScreen extends ConsumerStatefulWidget {
  const CloudflareDetailScreen({super.key, required this.connectionId, required this.title});

  final String connectionId;
  final String title;

  @override
  ConsumerState<CloudflareDetailScreen> createState() => _CloudflareDetailScreenState();
}

class _CloudflareDetailScreenState extends ConsumerState<CloudflareDetailScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(cloudflareOverviewProvider(widget.connectionId));

    return Scaffold(
      appBar: DataComAppBar(
        title: widget.title,
        subtitle: 'cloudflare_subtitle'.tr(),
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
                  'cloudflare_tab_zones'.tr(),
                  'cloudflare_tab_workers'.tr(),
                  'cloudflare_tab_security'.tr(),
                ],
                selectedIndex: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: switch (_tab) {
                  0 => _ZonesTab(data: data),
                  1 => _WorkersTab(workers: data.workers, workerLog: data.workerLog),
                  _ => _SecurityTab(events: data.security),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ZonesTab extends StatelessWidget {
  const _ZonesTab({required this.data});

  final CloudflareOverview data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
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
        Text('cloudflare_zones_title'.tr(), style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        for (final zone in data.zones) ...[
          DataComCard(
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: statusColor(context, zone.level), shape: BoxShape.circle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(zone.name, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                      Text(
                        'cloudflare_zone_meta'.tr(
                          namedArgs: {'plan': zone.plan, 'records': zone.records, 'ssl': zone.ssl},
                        ),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(zone.requests, style: textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 6),
        Text(
          'cloudflare_dns_title'.tr(namedArgs: {'zone': data.zones.first.name}),
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DataComCard(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (final record in data.dns)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(record.type, style: const TextStyle(fontFamily: 'monospace', fontSize: 10.5)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(record.name, style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5)),
                            Text(
                              record.value,
                              style: textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        record.proxy,
                        style: textTheme.bodySmall?.copyWith(
                          color: record.proxied
                              ? statusColor(context, StatusLevel.ok)
                              : textTheme.bodySmall?.color,
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

class _WorkersTab extends StatelessWidget {
  const _WorkersTab({required this.workers, required this.workerLog});

  final List<CfWorker> workers;
  final List<LogLine> workerLog;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Text('cloudflare_workers_hint'.tr(), style: textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final worker in workers) ...[
          DataComCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: statusColor(context, worker.level), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(worker.name, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                    ),
                    Text(worker.deployed, style: textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final stat in worker.stats) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat.value,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                              color: stat.alert ? statusColor(context, StatusLevel.critical) : null,
                            ),
                          ),
                          Text(stat.label, style: textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(width: 16),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 6),
        Text(
          'cloudflare_worker_log_title'.tr(),
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DataComConsole(
          lines: [for (final line in workerLog) ConsoleLine('${line.time}  ${line.text}', line.emphasis)],
        ),
      ],
    );
  }
}

class _SecurityTab extends StatelessWidget {
  const _SecurityTab({required this.events});

  final List<SecurityEvent> events;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        for (final event in events) ...[
          DataComCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: statusColor(context, event.level)),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        event.action,
                        style: textTheme.labelSmall?.copyWith(color: statusColor(context, event.level)),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${event.count} · ${event.ago}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(event.rule, style: textTheme.bodyMedium),
                Text(
                  event.detail,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5),
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
