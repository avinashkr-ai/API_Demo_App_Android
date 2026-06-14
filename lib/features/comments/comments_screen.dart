import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../models/comment.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/create_record_sheet.dart';

/// Holds the active post-id filter for the comments screen (null = all).
final commentFilterProvider = StateProvider<int?>((ref) => null);

class CommentsScreen extends ConsumerWidget {
  const CommentsScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showCreateSheet(
      context: context,
      title: 'New Comment',
      fields: const [
        SheetField(key: 'name', label: 'Name'),
        SheetField(key: 'email', label: 'Email'),
        SheetField(key: 'body', label: 'Comment', multiline: true),
        SheetField(key: 'postId', label: 'Post id', initial: '1', number: true),
      ],
    );
    if (result == null) return;
    if (!context.mounted) return;
    final api = ref.read(apiServiceProvider);
    await runCreate<Comment>(
      context: context,
      label: 'Comment',
      create: () => api.createComment(Comment(
        postId: int.tryParse(result['postId'] ?? '') ?? 1,
        id: 0,
        name: result['name'] ?? '',
        email: result['email'] ?? '',
        body: result['body'] ?? '',
      )),
      idOf: (c) => c.id,
      onCreated: (c) => ref.read(localCommentsProvider.notifier).add(c),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(commentFilterProvider);
    final comments = filter == null
        ? ref.watch(commentsProvider)
        : ref.watch(commentsByPostProvider(filter));
    final local = ref.watch(localCommentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          IconButton(
            tooltip: 'Add comment',
            icon: const Icon(Icons.add),
            onPressed: () => _add(context, ref),
          ),
          IconButton(
            tooltip: 'Filter by post',
            icon: Icon(
                filter == null ? Icons.filter_alt_outlined : Icons.filter_alt),
            onPressed: () => _showFilterSheet(context, ref, filter),
          ),
        ],
      ),
      body: Column(
        children: [
          if (filter != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  label: Text('Post #$filter'),
                  onDeleted: () =>
                      ref.read(commentFilterProvider.notifier).state = null,
                ),
              ),
            ),
          Expanded(
            child: AsyncValueWidget(
              value: comments,
              onRetry: () => filter == null
                  ? ref.invalidate(commentsProvider)
                  : ref.invalidate(commentsByPostProvider(filter)),
              data: (list) {
                final localFiltered = filter == null
                    ? local
                    : local.where((c) => c.postId == filter).toList();
                final all = [...localFiltered, ...list];
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: all.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final c = all[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${c.postId}')),
                        title: Text(c.name),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.email,
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                              const SizedBox(height: 4),
                              Text(c.body),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterSheet(
    BuildContext context,
    WidgetRef ref,
    int? current,
  ) async {
    final controller = TextEditingController(text: current?.toString() ?? '');
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter comments by post id',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Post id (1-100)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    ref.read(commentFilterProvider.notifier).state = null;
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    final id = int.tryParse(controller.text.trim());
                    ref.read(commentFilterProvider.notifier).state = id;
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
