import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/redis_models.dart';
import '../models/status_level.dart';
import '../providers/redis_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_segmented_tabs.dart';

class RedisDetailScreen extends ConsumerStatefulWidget {
  const RedisDetailScreen({super.key, required this.connectionId, required this.title});

  final String connectionId;
  final String title;

  @override
  ConsumerState<RedisDetailScreen> createState() => _RedisDetailScreenState();
}

class _RedisDetailScreenState extends ConsumerState<RedisDetailScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(redisOverviewProvider(widget.connectionId));

    return Scaffold(
      appBar: DataComAppBar(
        title: widget.title,
        subtitle: 'redis_subtitle'.tr(),
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
                  'redis_tab_health'.tr(),
                  'redis_tab_keys'.tr(),
                  'redis_tab_slowlog'.tr(),
                ],
                selectedIndex: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: switch (_tab) {
                  0 => _HealthTab(data: data),
                  1 => _KeysTab(keys: data.keys),
                  _ => _SlowlogTab(entries: data.slowlog),
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

  final RedisOverview data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final warnColor = statusColor(context, StatusLevel.warn);
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: warnColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'redis_memory_title'.tr(namedArgs: {'n': '${data.memoryPercent}'}),
                    style: textTheme.bodyLarge,
                  ),
                  Text(
                    '${data.memoryUsedGb.toStringAsFixed(2)} / ${data.memoryMaxGb.toStringAsFixed(2)} GB',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: data.memoryPercent / 100,
                  minHeight: 8,
                  backgroundColor: Colors.black.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation(warnColor),
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'redis_eviction_note'.tr(
                  namedArgs: {'policy': data.evictionPolicy, 'n': '${data.evictedLastHour}'},
                ),
                style: textTheme.bodySmall,
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
        Text('redis_replication_title'.tr(), style: textTheme.titleSmall),
        const SizedBox(height: 6),
        DataComCard(
          child: Column(
            children: [
              for (final replica in data.replicas)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor(context, replica.level),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(replica.name, style: textTheme.bodyMedium)),
                      Text(replica.lag, style: textTheme.bodySmall),
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

class _KeysTab extends StatelessWidget {
  const _KeysTab({required this.keys});

  final List<RedisKeyEntry> keys;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        for (final key in keys) ...[
          DataComCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key.key,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('${key.type} · ${key.size}', style: textTheme.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      key.ttl,
                      style: TextStyle(fontFamily: 'monospace', color: statusColor(context, key.level)),
                    ),
                    Text('TTL', style: textTheme.bodySmall),
                  ],
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

class _SlowlogTab extends StatelessWidget {
  const _SlowlogTab({required this.entries});

  final List<RedisSlowlogEntry> entries;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.only(bottom: 88),
      children: [
        Text('redis_slowlog_hint'.tr(), style: textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final entry in entries) ...[
          DataComCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.duration,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        color: statusColor(context, entry.level),
                      ),
                    ),
                    Text(entry.ago, style: textTheme.bodySmall),
                  ],
                ),
                Text(entry.command, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
