import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/storage_models.dart';
import '../providers/storage_providers.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_sheet.dart';
import '../widgets/datacom_toast.dart';

class BucketDetailScreen extends ConsumerWidget {
  const BucketDetailScreen({super.key, required this.bucketId, required this.title});

  final String bucketId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objects = ref.watch(bucketObjectsProvider(bucketId));

    return Scaffold(
      appBar: DataComAppBar(title: title, showBack: true, onBack: () => context.pop()),
      body: objects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
              child: Text(
                'bucket_breadcrumb'.tr(namedArgs: {'bucket': bucketId}),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            for (final object in data) ...[
              _ObjectRow(object: object),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _ObjectRow extends StatelessWidget {
  const _ObjectRow({required this.object});

  final StorageObject object;

  void _openSheet(BuildContext context) {
    showDataComSheet(
      context,
      title: object.name,
      actions: [
        DataComSheetAction(
          icon: Icons.visibility_outlined,
          label: 'sheet_preview_object'.tr(),
          onTap: () => showDataComToast(context, 'toast_preview_unavailable'.tr()),
        ),
        DataComSheetAction(
          icon: Icons.info_outline,
          label: '${object.size} · ${object.modified}',
          onTap: () {},
        ),
        DataComSheetAction(
          icon: Icons.download_outlined,
          label: 'sheet_download_object'.tr(),
          onTap: () => showDataComToast(context, 'toast_downloading'.tr(namedArgs: {'name': object.name})),
        ),
        DataComSheetAction(
          icon: Icons.delete_outline,
          label: 'sheet_delete_object'.tr(),
          destructive: true,
          onTap: () => showDataComToast(context, 'toast_delete_requires_write'.tr()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return DataComCard(
      onTap: () => _openSheet(context),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(object.ext, style: const TextStyle(fontFamily: 'monospace', fontSize: 10)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(object.name, style: textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                Text(object.modified, style: textTheme.bodySmall),
              ],
            ),
          ),
          Text(object.size, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
