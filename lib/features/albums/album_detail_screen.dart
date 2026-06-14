import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/image_utils.dart';
import '../../data/providers.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/network_image_widget.dart';

class AlbumDetailScreen extends ConsumerWidget {
  const AlbumDetailScreen({super.key, required this.albumId});

  final int albumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final album = ref.watch(albumProvider(albumId));
    final photos = ref.watch(photosByAlbumProvider(albumId));

    return Scaffold(
      appBar: AppBar(
        title: album.maybeWhen(
          data: (a) => Text(
            a.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          orElse: () => Text('Album #$albumId'),
        ),
      ),
      body: AsyncValueWidget(
        value: photos,
        onRetry: () => ref.invalidate(photosByAlbumProvider(albumId)),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(photosByAlbumProvider(albumId).future),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final photo = list[index];
              return GestureDetector(
                onTap: () => context.go('/photos/${photo.id}'),
                child: Hero(
                  tag: 'photo-${photo.id}',
                  child: AppNetworkImage(
                    url: thumbImageUrlFor(photo),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
