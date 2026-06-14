import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/api_client.dart';

/// Runs a create (POST) call, reports the result via a SnackBar, and lets the
/// caller store the created item locally. Keeps the per-screen handlers small.
Future<void> runCreate<T>({
  required BuildContext context,
  required String label,
  required Future<T> Function() create,
  required int Function(T created) idOf,
  required void Function(T created) onCreated,
}) async {
  try {
    final created = await create();
    onCreated(created);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$label sent via POST. API returned id ${idOf(created)} '
            '(JSONPlaceholder fakes saving, kept locally).',
          ),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(describeDioError(e))),
      );
    }
  }
}

/// Description of a single input in a create-record form.
class SheetField {
  const SheetField({
    required this.key,
    required this.label,
    this.initial = '',
    this.multiline = false,
    this.number = false,
    this.required = true,
  });

  final String key;
  final String label;
  final String initial;
  final bool multiline;
  final bool number;
  final bool required;
}

/// Shows a modal bottom sheet with the given [fields] and returns the entered
/// values keyed by field key, or null if the user cancels.
Future<Map<String, String>?> showCreateSheet({
  required BuildContext context,
  required String title,
  required List<SheetField> fields,
}) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _CreateSheet(title: title, fields: fields),
  );
}

class _CreateSheet extends StatefulWidget {
  const _CreateSheet({required this.title, required this.fields});

  final String title;
  final List<SheetField> fields;

  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers = {
    for (final f in widget.fields)
      f.key: TextEditingController(text: f.initial),
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      {for (final e in _controllers.entries) e.key: e.value.text.trim()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 4,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            for (final field in widget.fields) ...[
              TextFormField(
                controller: _controllers[field.key],
                keyboardType: field.number
                    ? TextInputType.number
                    : (field.multiline
                        ? TextInputType.multiline
                        : TextInputType.text),
                inputFormatters: field.number
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                maxLines: field.multiline ? 4 : 1,
                minLines: field.multiline ? 3 : 1,
                decoration: InputDecoration(
                  labelText: field.label,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (field.required &&
                      (value == null || value.trim().isEmpty)) {
                    return '${field.label} is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.cloud_upload_outlined),
              label: const Text('Save (POST)'),
            ),
          ],
        ),
      ),
    );
  }
}
