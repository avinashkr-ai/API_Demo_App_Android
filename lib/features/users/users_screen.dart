import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../widgets/async_value_widget.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: AsyncValueWidget(
        value: users,
        onRetry: () => ref.invalidate(usersProvider),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(usersProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = list[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(user.initials)),
                  title: Text(user.name),
                  subtitle: Text('@${user.username}  -  ${user.email}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/users/${user.id}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
