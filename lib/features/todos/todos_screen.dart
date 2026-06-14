import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../models/todo.dart';
import '../../widgets/async_value_widget.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    final overrides = ref.watch(todoOverridesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: AsyncValueWidget(
        value: todos,
        onRetry: () => ref.invalidate(todosProvider),
        data: (list) {
          // Group todos by user id for a sectioned checklist.
          final byUser = <int, List<Todo>>{};
          for (final t in list) {
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
                    .where((t) =>
                        ref.read(todoOverridesProvider.notifier).resolve(
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
                          decoration: checked
                              ? TextDecoration.lineThrough
                              : null,
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
