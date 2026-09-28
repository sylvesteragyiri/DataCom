import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/services_providers.dart';
import '../providers/theme_providers.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_sheet.dart';
import '../widgets/datacom_toast.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final servicesOverview = ref.watch(servicesOverviewProvider);
    final connectionCount = servicesOverview.valueOrNull?.groups.fold<int>(
      0,
      (sum, group) => sum + group.items.length,
    );

    return Scaffold(
      appBar: DataComAppBar(title: 'settings_title'.tr()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 96),
        children: [
          DataComCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('settings_dark_theme'.tr(), style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        'settings_dark_theme_sub'.tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isDark,
                  onChanged: (value) => ref.read(isDarkModeProvider.notifier).state = value,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SettingsSection(
            title: 'settings_section_connections'.tr(),
            rows: [
              _SettingsRow(
                label: 'settings_manage_connections'.tr(),
                sub: 'settings_manage_connections_sub'.tr(),
                value: connectionCount != null ? '$connectionCount' : '',
                onTap: () => context.go('/services'),
              ),
              _SettingsRow(
                label: 'settings_add_connection'.tr(),
                sub: 'settings_add_connection_sub'.tr(),
                onTap: () => showDataComToast(context, 'toast_coming_soon'.tr()),
              ),
              _SettingsRow(
                label: 'settings_import_export'.tr(),
                sub: 'settings_import_export_sub'.tr(),
                onTap: () => showDataComToast(context, 'toast_exported'.tr()),
              ),
            ],
          ),
          _SettingsSection(
            title: 'settings_section_credentials'.tr(),
            rows: [
              _SettingsRow(
                label: 'settings_keys'.tr(),
                sub: 'settings_keys_sub'.tr(),
                value: '6',
                onTap: () => showDataComToast(context, 'toast_coming_soon'.tr()),
              ),
              _SettingsRow(
                label: 'settings_app_lock'.tr(),
                sub: 'settings_app_lock_sub'.tr(),
                value: 'settings_on'.tr(),
                onTap: () => showDataComToast(context, 'toast_app_lock'.tr()),
              ),
            ],
          ),
          _SettingsSection(
            title: 'settings_section_monitoring'.tr(),
            rows: [
              _SettingsRow(
                label: 'settings_refresh_interval'.tr(),
                sub: 'settings_refresh_interval_sub'.tr(),
                value: '30 s',
                onTap: () => showDataComToast(context, 'toast_refresh_interval'.tr()),
              ),
              _SettingsRow(
                label: 'settings_alert_thresholds'.tr(),
                sub: 'settings_alert_thresholds_sub'.tr(),
                value: 'settings_rules_count'.tr(namedArgs: {'n': '12'}),
                onTap: () => showDataComToast(
                  context,
                  'toast_alert_thresholds'.tr(namedArgs: {'n': '12', 'total': '13'}),
                ),
              ),
              _SettingsRow(
                label: 'settings_slow_query_threshold'.tr(),
                sub: 'settings_slow_query_threshold_sub'.tr(),
                value: '500 ms',
                onTap: () => showDataComToast(context, 'toast_slow_query_threshold'.tr()),
              ),
            ],
          ),
          _SettingsSection(
            title: 'settings_section_data'.tr(),
            rows: [
              _SettingsRow(
                label: 'settings_cached_responses'.tr(),
                sub: 'settings_cached_responses_sub'.tr(),
                value: '48 MB',
                onTap: () => showDataComToast(context, 'toast_cache_cleared'.tr()),
              ),
              _SettingsRow(
                label: 'settings_wipe_data'.tr(),
                sub: 'settings_wipe_data_sub'.tr(),
                danger: true,
                onTap: () => showDataComSheet(
                  context,
                  title: 'settings_wipe_confirm_title'.tr(),
                  actions: [
                    DataComSheetAction(
                      icon: Icons.delete_forever_outlined,
                      label: 'settings_wipe_confirm_action'.tr(namedArgs: {'connections': '13', 'keys': '6'}),
                      destructive: true,
                      onTap: () => showDataComToast(context, 'toast_data_wiped'.tr()),
                    ),
                    DataComSheetAction(
                      icon: Icons.close,
                      label: 'settings_wipe_cancel'.tr(),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'settings_footer'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow {
  const _SettingsRow({
    required this.label,
    required this.sub,
    this.value = '',
    this.danger = false,
    required this.onTap,
  });

  final String label;
  final String sub;
  final String value;
  final bool danger;
  final VoidCallback onTap;
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.rows});

  final String title;
  final List<_SettingsRow> rows;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
            child: Text(
              title.toUpperCase(),
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
            ),
          ),
          DataComCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final row in rows)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: row.onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    row.label,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: row.danger ? colors.error : colors.onSurface,
                                    ),
                                  ),
                                  Text(row.sub, style: textTheme.bodySmall),
                                ],
                              ),
                            ),
                            if (row.value.isNotEmpty) ...[
                              Text(row.value, style: textTheme.bodySmall),
                              const SizedBox(width: 6),
                            ],
                            Icon(Icons.chevron_right, size: 18, color: colors.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
