import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/services_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';

/// Unlike every other detail screen, the source design has no real template
/// for Laravel Cloud (`isCloud` is hardcoded `false` in
/// design-reference/DataCom Calm.dc.html — the prototype never finished
/// this screen). This shows only the stats that actually exist, on the
/// Services screen's Laravel Cloud card, rather than inventing content
/// (deployment history, logs, queue names) with no source to translate.
class LaravelCloudScreen extends ConsumerWidget {
  const LaravelCloudScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(servicesOverviewProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: DataComAppBar(title: 'laravel_cloud_title'.tr(), showBack: true, onBack: () => context.pop()),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) {
          final card = data.cloudCards.where((c) => c.name == 'Laravel Cloud').firstOrNull;
          if (card == null) return Center(child: Text('laravel_cloud_not_found'.tr()));
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
            children: [
              Text(card.sub, style: textTheme.bodyMedium),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.4,
                children: [
                  for (final stat in card.stats)
                    DataComCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            stat.value,
                            style: textTheme.titleLarge?.copyWith(color: statusColor(context, card.status)),
                          ),
                          Text(stat.label, style: textTheme.bodySmall),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('laravel_cloud_note'.tr(), style: textTheme.bodySmall),
              ),
            ],
          );
        },
      ),
    );
  }
}
