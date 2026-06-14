import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/image_utils.dart';
import '../../data/providers.dart';
import '../../models/album.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/create_record_sheet.dart';
import '../../widgets/network_image_widget.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showCreateSheet(
      context: context,
      title: 'New Album',
      fields: const [
        SheetField(key: 'title', label: 'Title'),
        SheetField(key: 'userId', label: 'User id', initial: '1', number: true),
      ],
    );
    if (result == null) return;
    if (!context.mounted) return;
    final api = ref.read(apiServiceProvider);
    await runCreate<Album>(
      context: context,
      label: 'Album',
      create: () => api.createAlbum(Album(
        userId: int.tryParse(result['userId'] ?? '') ?? 1,
        id: 0,
        title: result['title'] ?? '',
      )),
      idOf: (a) => a.id,
      onCreated: (a) => ref.read(localAlbumsProvider.notifier).add(a),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);
    final local = ref.watch(localAlbumsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        actions: [
          IconButton(
            tooltip: 'Add album',
            icon: const Icon(Icons.add),
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: albums,
        onRetry: () => ref.invalidate(albumsProvider),
        data: (list) {
          final all = [...local, ...list];
          return RefreshIndicator(
            onRefresh: () => ref.refresh(albumsProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: all.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final album = all[index];
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 56,
                      height: 56,
                      child: AppNetworkImage(
                        url: imageUrlForId(album.id, size: 120),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    title: Text(
                      album.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle:
                        Text('Album #${album.id}  -  by user ${album.userId}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/albums/${album.id}'),
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
