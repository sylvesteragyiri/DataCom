import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/alert_models.dart';
import '../providers/alerts_providers.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/status_badge.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);

    return Scaffold(
      appBar: DataComAppBar(
        title: 'alerts_title'.tr(),
        subtitle: alerts.valueOrNull != null
            ? 'alerts_subtitle'.tr(namedArgs: {'n': '${alerts.valueOrNull!.length}'})
            : null,
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: alerts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) => _AlertsList(alerts: data),
      ),
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.alerts});

  final List<Alert> alerts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
      children: [
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _FilterChip(label: 'alerts_filter_all'.tr(namedArgs: {'n': '${alerts.length}'}), selected: true),
              const SizedBox(width: 8),
              _FilterChip(label: 'alerts_filter_critical'.tr(), selected: false),
              const SizedBox(width: 8),
              _FilterChip(label: 'alerts_filter_warning'.tr(), selected: false),
              const SizedBox(width: 8),
              _FilterChip(label: 'alerts_filter_muted'.tr(), selected: false),
            ],
          ),
        ),
        const SizedBox(height: 10),
        for (final alert in alerts) ...[
          _AlertCard(alert: alert),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? colors.primaryContainer : Colors.transparent,
        border: Border.all(color: selected ? colors.primaryContainer : colors.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: selected ? colors.onPrimaryContainer : colors.onSurface,
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DataComCard(
      onTap: () => context.push('/dashboard/alerts/${alert.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(label: alert.levelLabel, level: alert.level),
              const SizedBox(width: 8),
              Text(alert.ago, style: textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 6),
          Text(alert.title, style: textTheme.titleMedium),
          Text(alert.detail, style: textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(alert.source, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
