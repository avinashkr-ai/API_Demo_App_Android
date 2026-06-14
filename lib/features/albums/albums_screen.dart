import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/image_utils.dart';
import '../../data/providers.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/network_image_widget.dart';

class AlbumsScreen extends ConsumerWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albums = ref.watch(albumsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: AsyncValueWidget(
        value: albums,
        onRetry: () => ref.invalidate(albumsProvider),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(albumsProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final album = list[index];
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
                  subtitle: Text('Album #${album.id}  -  by user ${album.userId}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/albums/${album.id}'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
