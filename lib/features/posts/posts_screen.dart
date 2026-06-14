import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../models/user.dart';
import '../../widgets/async_value_widget.dart';

class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final users = ref.watch(usersProvider);

    final userById = <int, User>{
      for (final u in users.asData?.value ?? const <User>[]) u.id: u,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: AsyncValueWidget(
        value: posts,
        onRetry: () => ref.invalidate(postsProvider),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(postsProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final post = list[index];
              final author = userById[post.userId]?.name ?? 'User ${post.userId}';
              return Card(
                child: ListTile(
                  title: Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              author,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  onTap: () => context.push('/posts/${post.id}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
