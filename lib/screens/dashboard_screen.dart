import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../providers/dashboard_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_toast.dart';
import '../widgets/latency_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(dashboardOverviewProvider);

    return Scaffold(
      appBar: DataComAppBar(
        title: 'dashboard_overview_title'.tr(),
        subtitle: 'dashboard_overview_subtitle'.tr(namedArgs: {'n': '12'}),
        onRefresh: () => showDataComToast(context, 'toast_refreshed'.tr()),
        onOpenInbox: () {},
        inboxCount: 7,
      ),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) => _DashboardBody(data: data),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.data});

  final DashboardOverview data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
      children: [
        if (data.criticalBanner != null) _CriticalBanner(banner: data.criticalBanner!),
        const SizedBox(height: 12),
        _HealthCountsRow(counts: data.healthCounts),
        const SizedBox(height: 12),
        _LatencyCard(latency: data.latency),
        const SizedBox(height: 14),
        Text(
          'dashboard_live_metrics_title'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          'dashboard_live_metrics_source'.tr(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        _LiveMetricsGrid(metrics: data.liveMetrics),
        const SizedBox(height: 14),
        Text(
          'dashboard_activity_title'.tr(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        _ActivityCard(entries: data.activity),
      ],
    );
  }
}

Color _statusColor(BuildContext context, StatusLevel? level) {
  final colors = Theme.of(context).colorScheme;
  final status = Theme.of(context).extension<DataComStatusColors>()!;
  switch (level) {
    case StatusLevel.ok:
      return status.ok;
    case StatusLevel.warn:
      return status.warn;
    case StatusLevel.critical:
      return colors.error;
    case StatusLevel.info:
      return colors.primary;
    case null:
      return colors.onSurface;
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _CriticalBanner extends StatelessWidget {
  const _CriticalBanner({required this.banner});

  final CriticalBanner banner;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        border: Border.all(color: colors.error),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: colors.error, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(
                'dashboard_critical_banner_title'.tr(namedArgs: {'n': '${banner.criticalCount}'}),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(banner.detail, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: colors.error),
            onPressed: () {},
            child: Text('dashboard_triage_alerts'.tr(namedArgs: {'n': '4'})),
          ),
        ],
      ),
    );
  }
}

class _HealthCountsRow extends StatelessWidget {
  const _HealthCountsRow({required this.counts});

  final List<HealthCount> counts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final count in counts) ...[
          Expanded(child: _HealthTile(count: count)),
          if (count != counts.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _HealthTile extends StatelessWidget {
  const _HealthTile({required this.count});

  final HealthCount count;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Text(
            '${count.count}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _statusColor(context, count.level),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            count.labelKey.tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LatencyCard extends StatelessWidget {
  const _LatencyCard({required this.latency});

  final LatencySample latency;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'dashboard_avg_latency_title'.tr(),
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              Text('dashboard_avg_latency_range'.tr(), style: textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              LatencyChart(values: latency.values, maxValue: 150),
              Positioned(
                right: 0,
                top: -4,
                child: Text(
                  'dashboard_latency_peak'.tr(namedArgs: {'v': latency.peak}),
                  style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _LatencyStat(value: latency.p50, labelKey: 'metric_p50'),
              const SizedBox(width: 18),
              _LatencyStat(value: latency.p95, labelKey: 'metric_p95'),
              const SizedBox(width: 18),
              _LatencyStat(value: latency.throughput, labelKey: 'metric_throughput'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LatencyStat extends StatelessWidget {
  const _LatencyStat({required this.value, required this.labelKey});

  final String value;
  final String labelKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(labelKey.tr(), style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _LiveMetricsGrid extends StatelessWidget {
  const _LiveMetricsGrid({required this.metrics});

  final List<LiveMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.4,
      children: [for (final metric in metrics) _LiveMetricTile(metric: metric)],
    );
  }
}

class _LiveMetricTile extends StatelessWidget {
  const _LiveMetricTile({required this.metric});

  final LiveMetric metric;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(metric.labelKey.tr(), style: textTheme.bodySmall),
          Text(
            metric.value,
            style: textTheme.titleMedium?.copyWith(color: _statusColor(context, metric.level)),
          ),
          Text(metric.sub, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.entries});

  final List<ActivityEntry> entries;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        children: [for (final entry in entries) _ActivityRow(entry: entry)],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry});

  final ActivityEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 44,
            child: Text(entry.time, style: textTheme.bodySmall),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 14),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _statusColor(context, entry.level),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.text, style: textTheme.bodyMedium),
                Text(entry.source, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
