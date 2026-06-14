import '../models/photo.dart';

/// The image URLs that the `/photos` endpoint returns point at
/// `via.placeholder.com`, a service that has since shut down, so those
/// images no longer load. We deterministically map each photo to a working
/// image from picsum.photos based on its id so the UI actually renders images.
///
/// picsum exposes ids 0-1084, so we wrap the photo id into that range.
String _picsum(int id, int size) {
  final safeId = id % 1000;
  return 'https://picsum.photos/id/$safeId/$size/$size';
}

/// Full-size image URL for a photo detail view.
String fullImageUrlFor(Photo photo) => _picsum(photo.id, 600);

/// Thumbnail image URL for grids and list tiles.
String thumbImageUrlFor(Photo photo) => _picsum(photo.id, 200);

/// Image URL keyed only by an integer id (e.g. album cover from its id).
String imageUrlForId(int id, {int size = 300}) => _picsum(id, size);
