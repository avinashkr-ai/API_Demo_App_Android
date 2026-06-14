import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../models/user.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/create_record_sheet.dart';

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showCreateSheet(
      context: context,
      title: 'New User',
      fields: const [
        SheetField(key: 'name', label: 'Full name'),
        SheetField(key: 'username', label: 'Username'),
        SheetField(key: 'email', label: 'Email'),
        SheetField(key: 'phone', label: 'Phone', required: false),
      ],
    );
    if (result == null) return;
    if (!context.mounted) return;
    final api = ref.read(apiServiceProvider);
    await runCreate<User>(
      context: context,
      label: 'User',
      create: () => api.createUser(User(
        id: 0,
        name: result['name'] ?? '',
        username: result['username'] ?? '',
        email: result['email'] ?? '',
        address: const Address(
          street: '',
          suite: '',
          city: '',
          zipcode: '',
          geo: Geo(lat: '', lng: ''),
        ),
        phone: result['phone'] ?? '',
        website: '',
        company: const Company(name: '', catchPhrase: '', bs: ''),
      )),
      idOf: (u) => u.id,
      onCreated: (u) => ref.read(localUsersProvider.notifier).add(u),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    final local = ref.watch(localUsersProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            tooltip: 'Add user',
            icon: const Icon(Icons.add),
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: users,
        onRetry: () => ref.invalidate(usersProvider),
        data: (list) {
          final all = [...local, ...list];
          return RefreshIndicator(
            onRefresh: () => ref.refresh(usersProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: all.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final user = all[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(user.initials)),
                    title: Text(user.name),
                    subtitle: Text('@${user.username}  -  ${user.email}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/users/${user.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
