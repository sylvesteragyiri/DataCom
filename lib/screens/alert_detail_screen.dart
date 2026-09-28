import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/alert_models.dart';
import '../providers/alerts_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
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
            onOpenTarget: () => showDataComToast(context, 'toast_coming_soon'.tr()),
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
    required this.onOpenTarget,
  });

  final Alert alert;
  final bool acked;
  final VoidCallback onAck;
  final VoidCallback onOpenTarget;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = statusColor(context, alert.level);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
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
        _TraceConsole(lines: alert.trace),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: onOpenTarget,
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

class _TraceConsole extends StatelessWidget {
  const _TraceConsole({required this.lines});

  final List<TraceLine> lines;

  static const _normal = Color(0xFFE4E4E7);
  static const _muted = Color(0xFFA1A1AA);
  static const _danger = Color(0xFFF87171);
  static const _warn = Color(0xFFFBBF24);

  Color _colorFor(TraceEmphasis emphasis) {
    switch (emphasis) {
      case TraceEmphasis.normal:
        return _normal;
      case TraceEmphasis.muted:
        return _muted;
      case TraceEmphasis.danger:
        return _danger;
      case TraceEmphasis.warn:
        return _warn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF111528),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final line in lines)
              Text(
                line.text.isEmpty ? ' ' : line.text,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5,
                  color: _colorFor(line.emphasis),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
