import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/image_utils.dart';
import '../../data/providers.dart';
import '../../widgets/async_value_widget.dart';
import '../../widgets/network_image_widget.dart';

class PhotosScreen extends ConsumerWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(photosProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),
      body: AsyncValueWidget(
        value: photos,
        onRetry: () => ref.invalidate(photosProvider),
        data: (list) => RefreshIndicator(
          onRefresh: () => ref.refresh(photosProvider.future),
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
                onTap: () => context.push('/photos/${photo.id}'),
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
