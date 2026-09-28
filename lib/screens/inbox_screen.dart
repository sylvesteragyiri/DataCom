import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/alert_models.dart';
import '../providers/alerts_providers.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/status_badge.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen> {
  bool _showIssues = false;

  @override
  Widget build(BuildContext context) {
    final alerts = ref.watch(alertsProvider);
    final issues = ref.watch(issuesProvider);

    return Scaffold(
      appBar: DataComAppBar(
        title: 'inbox_title'.tr(),
        subtitle: 'inbox_subtitle'.tr(
          namedArgs: {
            'alerts': '${alerts.valueOrNull?.length ?? 0}',
            'issues': '${issues.valueOrNull?.length ?? 0}',
          },
        ),
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SegmentToggle(
              showIssues: _showIssues,
              onChanged: (value) => setState(() => _showIssues = value),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _showIssues
                  ? issues.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(child: Text('$error')),
                      data: (data) => _IssuesList(issues: data),
                    )
                  : alerts.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(child: Text('$error')),
                      data: (data) => _AlertsPreview(alerts: data.take(3).toList()),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({required this.showIssues, required this.onChanged});

  final bool showIssues;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: 'inbox_tab_alerts'.tr(),
              selected: !showIssues,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: 'inbox_tab_issues'.tr(),
              selected: showIssues,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: selected ? colors.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? colors.onSurface : colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertsPreview extends StatelessWidget {
  const _AlertsPreview({required this.alerts});

  final List<Alert> alerts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('inbox_alerts_hint'.tr(), style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final alert in alerts) ...[
          _AlertPreviewCard(alert: alert),
          const SizedBox(height: 8),
        ],
        TextButton(
          onPressed: () => context.push('/dashboard/alerts'),
          child: Text('inbox_all_alerts'.tr()),
        ),
      ],
    );
  }
}

class _AlertPreviewCard extends StatelessWidget {
  const _AlertPreviewCard({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DataComCard(
      onTap: () => context.push('/dashboard/alerts/${alert.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 12),
            child: StatusBadge(label: alert.levelLabel, level: alert.level),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(alert.detail, style: textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('${alert.source} · ${alert.ago}', style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IssuesList extends StatelessWidget {
  const _IssuesList({required this.issues});

  final List<Issue> issues;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      children: [
        Text('inbox_issues_hint'.tr(), style: textTheme.bodySmall),
        const SizedBox(height: 8),
        for (final issue in issues) ...[
          DataComCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusBadge(label: issue.levelLabel, level: issue.level),
                    const Spacer(),
                    Text(
                      'inbox_issue_meta'.tr(
                        namedArgs: {'events': issue.events, 'users': issue.users},
                      ),
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(issue.type, style: textTheme.titleSmall),
                Text(issue.message, style: textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
