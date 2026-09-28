import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/credential_models.dart';
import '../providers/credentials_providers.dart';
import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_toast.dart';

class KeyDetailScreen extends ConsumerStatefulWidget {
  const KeyDetailScreen({super.key, required this.index});

  final int index;

  @override
  ConsumerState<KeyDetailScreen> createState() => _KeyDetailScreenState();
}

class _KeyDetailScreenState extends ConsumerState<KeyDetailScreen> {
  bool _revealed = false;
  bool _verifying = false;
  String? _verifyResult;

  Future<void> _verify(Credential credential) async {
    setState(() {
      _verifying = true;
      _verifyResult = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() {
      _verifying = false;
      _verifyResult = credential.state == 'MISSING'
          ? 'key_verify_failed'.tr()
          : 'key_verify_ok'.tr(namedArgs: {'scope': credential.scope});
    });
  }

  @override
  Widget build(BuildContext context) {
    final credential = ref.watch(credentialByIndexProvider(widget.index));

    return Scaffold(
      appBar: DataComAppBar(title: 'key_detail_title'.tr(), showBack: true, onBack: () => context.pop()),
      body: credential.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('$error')),
        data: (data) {
          if (data == null) return Center(child: Text('key_not_found'.tr()));
          return _KeyDetailBody(
            credential: data,
            revealed: _revealed,
            onToggleReveal: () => setState(() => _revealed = !_revealed),
            verifying: _verifying,
            verifyResult: _verifyResult,
            onVerify: () => _verify(data),
            onSave: () {
              showDataComToast(context, 'toast_saved_to_device'.tr());
              context.pop();
            },
            onDelete: () {
              showDataComToast(context, 'toast_credential_deleted'.tr());
              context.pop();
            },
          );
        },
      ),
    );
  }
}

class _KeyDetailBody extends StatelessWidget {
  const _KeyDetailBody({
    required this.credential,
    required this.revealed,
    required this.onToggleReveal,
    required this.verifying,
    required this.verifyResult,
    required this.onVerify,
    required this.onSave,
    required this.onDelete,
  });

  final Credential credential;
  final bool revealed;
  final VoidCallback onToggleReveal;
  final bool verifying;
  final String? verifyResult;
  final VoidCallback onVerify;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final secretValue = credential.secret.isEmpty
        ? 'not set'
        : (revealed ? credential.secret : credential.masked);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
      children: [
        _Field(label: 'key_field_label'.tr(), value: credential.name),
        _Field(
          label: credential.field,
          value: secretValue,
          monospace: true,
          trailing: credential.secret.isEmpty
              ? null
              : IconButton(
                  icon: Icon(revealed ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: onToggleReveal,
                ),
        ),
        _Field(
          label: 'key_field_scope'.tr(),
          value: credential.scope.isEmpty ? 'key_field_scope_readonly'.tr() : credential.scope,
          monospace: true,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: verifying ? null : onVerify,
                child: Text(verifying ? 'key_verifying'.tr() : 'key_verify'.tr()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(onPressed: onSave, child: Text('key_save'.tr())),
            ),
          ],
        ),
        if (verifyResult != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(verifyResult!, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ),
        ],
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onDelete,
          style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          child: Text('key_delete'.tr()),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value, this.monospace = false, this.trailing});

  final String label;
  final String value;
  final bool monospace;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          DataComCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(fontFamily: monospace ? 'monospace' : null, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
