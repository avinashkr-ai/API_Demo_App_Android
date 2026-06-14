import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../widgets/async_value_widget.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider(userId));
    return Scaffold(
      appBar: AppBar(title: Text('User #$userId')),
      body: AsyncValueWidget(
        value: user,
        onRetry: () => ref.invalidate(userProvider(userId)),
        data: (u) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                CircleAvatar(radius: 32, child: Text(u.initials)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('@${u.username}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _InfoTile(Icons.email_outlined, 'Email', u.email),
            _InfoTile(Icons.phone_outlined, 'Phone', u.phone),
            _InfoTile(Icons.language_outlined, 'Website', u.website),
            _InfoTile(Icons.location_on_outlined, 'Address',
                u.address.formatted),
            _InfoTile(Icons.business_outlined, 'Company',
                '${u.company.name}\n${u.company.catchPhrase}'),
            const SizedBox(height: 24),
            Text('Activity', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _CountRow(userId: u.id),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountRow extends ConsumerWidget {
  const _CountRow({required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsByUserProvider(userId));
    final albums = ref.watch(albumsByUserProvider(userId));
    final todos = ref.watch(todosByUserProvider(userId));

    String count<T>(AsyncValue<List<T>> v) =>
        v.asData?.value.length.toString() ?? '-';

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.article_rounded,
            label: 'Posts',
            value: count(posts),
            onTap: () => context.push('/posts'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.collections_rounded,
            label: 'Albums',
            value: count(albums),
            onTap: () => context.push('/albums'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.checklist_rounded,
            label: 'Todos',
            value: count(todos),
            onTap: () => context.push('/todos'),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text(label, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
