import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/datacom_app_bar.dart';
import '../widgets/datacom_card.dart';
import '../widgets/datacom_toast.dart';

class AddConnectionFormScreen extends StatefulWidget {
  const AddConnectionFormScreen({super.key, this.connectorType});

  final String? connectorType;

  @override
  State<AddConnectionFormScreen> createState() => _AddConnectionFormScreenState();
}

class _AddConnectionFormScreenState extends State<AddConnectionFormScreen> {
  final _nameController = TextEditingController(text: 'orders-primary');
  final _hostController = TextEditingController(text: '10.0.4.11');
  final _portController = TextEditingController(text: '5432');
  final _databaseController = TextEditingController(text: 'orders');
  final _userController = TextEditingController(text: 'datacom_ro');
  final _passwordController = TextEditingController(text: '');

  bool _useTls = true;
  bool _testing = false;
  bool _tested = false;
  String? _testResult;

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _databaseController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _testing = true;
      _testResult = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      _testing = false;
      _tested = true;
      _testResult = 'add_form_test_result'.tr();
    });
  }

  void _save() {
    showDataComToast(context, 'toast_saved_to_device'.tr());
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DataComAppBar(
        title: widget.connectorType ?? 'PostgreSQL',
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
        children: [
          _FormField(label: 'add_form_field_name'.tr(), controller: _nameController),
          _FormField(label: 'add_form_field_host'.tr(), controller: _hostController, monospace: true),
          _FormField(label: 'add_form_field_port'.tr(), controller: _portController, monospace: true),
          _FormField(label: 'add_form_field_database'.tr(), controller: _databaseController, monospace: true),
          _FormField(label: 'add_form_field_user'.tr(), controller: _userController, monospace: true),
          _FormField(
            label: 'add_form_field_password'.tr(),
            controller: _passwordController,
            monospace: true,
            obscure: true,
          ),
          const SizedBox(height: 4),
          DataComCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('add_form_use_tls'.tr(), style: Theme.of(context).textTheme.bodyLarge),
                      Text('add_form_use_tls_sub'.tr(), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Switch(value: _useTls, onChanged: (value) => setState(() => _useTls = value)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _testing ? null : _testConnection,
                  child: Text(
                    _testing
                        ? 'add_form_testing'.tr()
                        : (_tested ? 'add_form_tested'.tr() : 'add_form_test_connection'.tr()),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  child: Text('add_form_save'.tr()),
                ),
              ),
            ],
          ),
          if (_testResult != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _testResult!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.monospace = false,
    this.obscure = false,
  });

  final String label;
  final TextEditingController controller;
  final bool monospace;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscure,
            style: TextStyle(fontFamily: monospace ? 'monospace' : null, fontSize: 14),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            ),
          ),
        ],
      ),
    );
  }
}
