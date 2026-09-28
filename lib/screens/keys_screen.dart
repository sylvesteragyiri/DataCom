import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/credential_models.dart';
import '../providers/credentials_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';

class KeysScreen extends ConsumerWidget {
  const KeysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentials = ref.watch(credentialsProvider);

    return Scaffold(
      appBar: DataComAppBar(
        title: 'keys_title'.tr(),
        subtitle: credentials.valueOrNull != null
            ? 'keys_subtitle'.tr(namedArgs: {'n': '${credentials.valueOrNull!.length}'})
            : null,
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: credentials.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('keys_privacy_notice'.tr(), style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < data.length; i++) ...[
              _CredentialRow(credential: data[i], onTap: () => context.push('/settings/keys/$i')),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  const _CredentialRow({required this.credential, required this.onTap});

  final Credential credential;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return DataComCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(credential.abbr, style: const TextStyle(fontFamily: 'monospace', fontSize: 10.5)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(credential.name, style: textTheme.bodyLarge),
                Text(
                  credential.masked,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.circle, size: 8, color: statusColor(context, credential.level)),
        ],
      ),
    );
  }
}
