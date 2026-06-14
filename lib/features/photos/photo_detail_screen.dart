import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/image_utils.dart';
import '../../data/providers.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/network_image_widget.dart';

class PhotoDetailScreen extends ConsumerWidget {
  const PhotoDetailScreen({super.key, required this.photoId});

  final int photoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(photoProvider(photoId));
    return Scaffold(
      appBar: AppBar(title: Text('Photo #$photoId')),
      body: AsyncValueWidget(
        value: photo,
        onRetry: () => ref.invalidate(photoProvider(photoId)),
        data: (p) => ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: 'photo-${p.id}',
                child: AppNetworkImage(url: fullImageUrlFor(p)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () => context.push('/albums/${p.albumId}'),
                    icon: const Icon(Icons.collections_rounded),
                    label: Text('View album #${p.albumId}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
