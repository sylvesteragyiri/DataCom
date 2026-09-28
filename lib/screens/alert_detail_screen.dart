import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/alert_models.dart';
import '../providers/alerts_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_console.dart';
import '../widgets/datacom_toast.dart';

class AlertDetailScreen extends ConsumerStatefulWidget {
  const AlertDetailScreen({super.key, required this.alertId});

  final int alertId;

  @override
  ConsumerState<AlertDetailScreen> createState() => _AlertDetailScreenState();
}

class _AlertDetailScreenState extends ConsumerState<AlertDetailScreen> {
  bool _acked = false;

  @override
  Widget build(BuildContext context) {
    final alert = ref.watch(alertByIdProvider(widget.alertId));

    return Scaffold(
      appBar: DataComAppBar(
        title: 'alert_detail_title'.tr(),
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: alert.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) {
          if (data == null) return Center(child: Text('alert_not_found'.tr()));
          return _AlertDetailBody(
            alert: data,
            acked: _acked,
            onAck: () {
              setState(() => _acked = !_acked);
              showDataComToast(
                context,
                _acked ? 'toast_snoozed'.tr() : 'toast_unsnoozed'.tr(),
              );
            },
          );
        },
      ),
    );
  }
}

class _AlertDetailBody extends StatelessWidget {
  const _AlertDetailBody({
    required this.alert,
    required this.acked,
    required this.onAck,
  });

  final Alert alert;
  final bool acked;
  final VoidCallback onAck;

  void _openTarget(BuildContext context) {
    final id = alert.targetConnectionId;
    switch (alert.target) {
      case AlertTarget.database:
        context.push('/services/db/${Uri.encodeComponent(id!)}', extra: id);
      case AlertTarget.redis:
        context.push('/services/redis/${Uri.encodeComponent(id!)}', extra: id);
      case AlertTarget.monitor:
        context.push('/services/monitor');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = statusColor(context, alert.level);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 96),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${alert.levelLabel} · ${alert.ago}',
                style: textTheme.labelMedium?.copyWith(color: color),
              ),
              const SizedBox(height: 6),
              Text(alert.title, style: textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(alert.detail, style: textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.6,
          children: [
            for (final metric in alert.metrics)
              DataComCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(metric.label, style: textTheme.bodySmall),
                    Text(metric.value, style: textTheme.titleMedium),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(alert.traceLabel, style: textTheme.titleSmall),
        const SizedBox(height: 6),
        DataComConsole(
          lines: [for (final line in alert.trace) ConsoleLine(line.text, line.emphasis)],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => _openTarget(context),
                child: Text(alert.ctaLabel),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: onAck,
              child: Text(acked ? 'alert_unsnooze'.tr() : 'alert_snooze'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}
