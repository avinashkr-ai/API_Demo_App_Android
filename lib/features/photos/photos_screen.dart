import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/image_utils.dart';
import '../../data/providers.dart';
import '../../models/photo.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/create_record_sheet.dart';
import '../../widgets/network_image_widget.dart';

class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showCreateSheet(
      context: context,
      title: 'New Photo',
      fields: const [
        SheetField(key: 'title', label: 'Title'),
        SheetField(
            key: 'albumId', label: 'Album id', initial: '1', number: true),
      ],
    );
    if (result == null) return;
    if (!context.mounted) return;
    final api = ref.read(apiServiceProvider);
    await runCreate<Photo>(
      context: context,
      label: 'Photo',
      create: () => api.createPhoto(Photo(
        albumId: int.tryParse(result['albumId'] ?? '') ?? 1,
        id: 0,
        title: result['title'] ?? '',
        url: '',
        thumbnailUrl: '',
      )),
      idOf: (p) => p.id,
      onCreated: (p) => ref.read(localPhotosProvider.notifier).add(p),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(photosProvider);
    final local = ref.watch(localPhotosProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
        actions: [
          IconButton(
            tooltip: 'Add photo',
            icon: const Icon(Icons.add),
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: photos,
        onRetry: () => ref.invalidate(photosProvider),
        data: (list) {
          final all = [...local, ...list];
          return RefreshIndicator(
            onRefresh: () => ref.refresh(photosProvider.future),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: all.length,
              itemBuilder: (context, index) {
                final photo = all[index];
                return GestureDetector(
                  onTap: () => context.push('/photos/${photo.id}'),
                  child: Hero(
                    tag: 'photo-${photo.id}-$index',
                    child: AppNetworkImage(
                      url: thumbImageUrlFor(photo),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
