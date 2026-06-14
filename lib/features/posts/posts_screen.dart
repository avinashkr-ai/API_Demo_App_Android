import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/create_record_sheet.dart';

class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showCreateSheet(
      context: context,
      title: 'New Post',
      fields: const [
        SheetField(key: 'title', label: 'Title'),
        SheetField(key: 'body', label: 'Body', multiline: true),
        SheetField(key: 'userId', label: 'User id', initial: '1', number: true),
      ],
    );
    if (result == null) return;
    if (!context.mounted) return;
    final api = ref.read(apiServiceProvider);
    await runCreate<Post>(
      context: context,
      label: 'Post',
      create: () => api.createPost(Post(
        userId: int.tryParse(result['userId'] ?? '') ?? 1,
        id: 0,
        title: result['title'] ?? '',
        body: result['body'] ?? '',
      )),
      idOf: (p) => p.id,
      onCreated: (p) => ref.read(localPostsProvider.notifier).add(p),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final users = ref.watch(usersProvider);
    final local = ref.watch(localPostsProvider);

    final userById = <int, User>{
      for (final u in users.asData?.value ?? const <User>[]) u.id: u,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            tooltip: 'Add post',
            icon: const Icon(Icons.add),
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: posts,
        onRetry: () => ref.invalidate(postsProvider),
        data: (list) {
          final all = [...local, ...list];
          return RefreshIndicator(
            onRefresh: () => ref.refresh(postsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: all.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final post = all[index];
                final author =
                    userById[post.userId]?.name ?? 'User ${post.userId}';
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
          );
        },
      ),
    );
  }
}
