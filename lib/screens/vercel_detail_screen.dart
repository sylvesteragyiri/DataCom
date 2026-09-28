import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/vercel_models.dart';
import '../providers/vercel_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_console.dart';

class VercelDetailScreen extends ConsumerWidget {
  const VercelDetailScreen({super.key, required this.connectionId, required this.title});

  final String connectionId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(vercelOverviewProvider(connectionId));
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: DataComAppBar(
        title: title,
        subtitle: 'vercel_subtitle'.tr(),
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
          children: [
            for (final deployment in data.deployments) ...[
              _DeploymentCard(deployment: deployment),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 6),
            Text('vercel_build_log_title'.tr(), style: textTheme.titleSmall),
            const SizedBox(height: 6),
            DataComConsole(
              lines: [for (final line in data.buildLog) ConsoleLine('${line.time}  ${line.text}', line.emphasis)],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeploymentCard extends StatelessWidget {
  const _DeploymentCard({required this.deployment});

  final Deployment deployment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = statusColor(context, deployment.level);
    return DataComCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(deployment.sha, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  deployment.state,
                  style: textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(deployment.message, style: textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            '${deployment.branch} · ${deployment.duration} · ${deployment.ago}',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
