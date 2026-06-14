import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../models/todo.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/create_record_sheet.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showCreateSheet(
      context: context,
      title: 'New Todo',
      fields: const [
        SheetField(key: 'title', label: 'Task'),
        SheetField(key: 'userId', label: 'User id', initial: '1', number: true),
      ],
    );
    if (result == null) return;
    if (!context.mounted) return;
    final api = ref.read(apiServiceProvider);
    await runCreate<Todo>(
      context: context,
      label: 'Todo',
      create: () => api.createTodo(Todo(
        userId: int.tryParse(result['userId'] ?? '') ?? 1,
        id: 0,
        title: result['title'] ?? '',
        completed: false,
      )),
      idOf: (t) => t.id,
      onCreated: (t) => ref.read(localTodosProvider.notifier).add(t),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    final overrides = ref.watch(todoOverridesProvider);
    final local = ref.watch(localTodosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            tooltip: 'Add todo',
            icon: const Icon(Icons.add),
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: todos,
        onRetry: () => ref.invalidate(todosProvider),
        data: (list) {
          // Group todos by user id for a sectioned checklist.
          final byUser = <int, List<Todo>>{};
          for (final t in [...local, ...list]) {
            byUser.putIfAbsent(t.userId, () => []).add(t);
          }
          final userIds = byUser.keys.toList()..sort();

          return RefreshIndicator(
            onRefresh: () => ref.refresh(todosProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: userIds.length,
              itemBuilder: (context, index) {
                final userId = userIds[index];
                final items = byUser[userId]!;
                final done = items
                    .where(
                        (t) => ref.read(todoOverridesProvider.notifier).resolve(
                              t.id,
                              t.completed,
                            ))
                    .length;
                return ExpansionTile(
                  initiallyExpanded: index == 0,
                  leading: CircleAvatar(child: Text('$userId')),
                  title: Text('User $userId'),
                  subtitle: Text('$done / ${items.length} completed'),
                  children: items.map((t) {
                    final checked = overrides[t.id] ?? t.completed;
                    return CheckboxListTile(
                      value: checked,
                      title: Text(
                        t.title,
                        style: TextStyle(
                          decoration:
                              checked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      onChanged: (_) => ref
                          .read(todoOverridesProvider.notifier)
                          .toggle(t.id, checked),
                    );
                  }).toList(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
