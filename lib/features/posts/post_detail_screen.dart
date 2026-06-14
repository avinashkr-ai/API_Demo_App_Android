import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../widgets/async_value_widget.dart';

class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postProvider(postId));
    final comments = ref.watch(commentsByPostProvider(postId));

    return Scaffold(
      appBar: AppBar(title: Text('Post #$postId')),
      body: AsyncValueWidget(
        value: post,
        onRetry: () => ref.invalidate(postProvider(postId)),
        data: (p) {
          final author = ref.watch(userProvider(p.userId));
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(p.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              author.when(
                data: (u) => InkWell(
                  onTap: () => context.go('/users/${u.id}'),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        child: Text(
                          u.initials,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('by ${u.name}',
                          style: Theme.of(context).textTheme.labelLarge),
                      const Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => Text('by user ${p.userId}'),
              ),
              const Divider(height: 32),
              Text(p.body, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.mode_comment_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text('Comments',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 8),
              comments.when(
                data: (list) => Column(
                  children: list
                      .map((c) => Card(
                            child: ListTile(
                              title: Text(c.name),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(c.email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    const SizedBox(height: 4),
                                    Text(c.body),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const Text('Could not load comments.'),
              ),
            ],
          );
        },
      ),
    );
  }
}
