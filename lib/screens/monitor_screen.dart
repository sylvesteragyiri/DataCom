import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/alerts_providers.dart';
import '../providers/dashboard_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';

/// Sentry-style monitoring screen. Reuses the same live metrics shown on
/// Dashboard and the same issues shown on Inbox's "Unresolved issues" tab —
/// this is deliberately not a separate repository, since it's the same
/// underlying data presented as its own screen (matches the design, which
/// reuses `monitorMetrics`/`issues` for both places too).
class MonitorScreen extends ConsumerWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(dashboardOverviewProvider);
    final issues = ref.watch(issuesProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: DataComAppBar(
        title: 'monitor_title'.tr(),
        subtitle: 'monitor_subtitle'.tr(),
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 96),
        children: [
          overview.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('$error'),
            data: (data) => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.4,
              children: [
                for (final metric in data.liveMetrics)
                  DataComCard(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(metric.labelKey.tr(), style: textTheme.bodySmall),
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
          ),
          const SizedBox(height: 14),
          Text(
            'monitor_issues_title'.tr(),
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          issues.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('$error'),
            data: (data) => Column(
              children: [
                for (final issue in data) ...[
                  DataComCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor(context, issue.level).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                issue.levelLabel,
                                style: textTheme.labelSmall?.copyWith(color: statusColor(context, issue.level)),
                              ),
                            ),
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
                        Text(issue.type, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                        Text(issue.message, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
