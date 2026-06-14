import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import '../models/album.dart';
import '../models/comment.dart';
import '../models/photo.dart';
import '../models/post.dart';
import '../models/todo.dart';
import '../models/user.dart';
import 'api_service.dart';

/// Shared Dio instance.
final dioProvider = Provider<Dio>((ref) => createDio());

/// API service backed by the shared Dio instance.
final apiServiceProvider =
    Provider<ApiService>((ref) => ApiService(ref.watch(dioProvider)));

// ---- Collection providers ----
final photosProvider = FutureProvider<List<Photo>>(
  (ref) => ref.watch(apiServiceProvider).getPhotos(),
);

final albumsProvider = FutureProvider<List<Album>>(
  (ref) => ref.watch(apiServiceProvider).getAlbums(),
);

final postsProvider = FutureProvider<List<Post>>(
  (ref) => ref.watch(apiServiceProvider).getPosts(),
);

final usersProvider = FutureProvider<List<User>>(
  (ref) => ref.watch(apiServiceProvider).getUsers(),
);

final commentsProvider = FutureProvider<List<Comment>>(
  (ref) => ref.watch(apiServiceProvider).getComments(),
);

final todosProvider = FutureProvider<List<Todo>>(
  (ref) => ref.watch(apiServiceProvider).getTodos(),
);

// ---- Single-entity providers ----
final photoProvider = FutureProvider.family<Photo, int>(
  (ref, id) => ref.watch(apiServiceProvider).getPhoto(id),
);

final albumProvider = FutureProvider.family<Album, int>(
  (ref, id) => ref.watch(apiServiceProvider).getAlbum(id),
);

final postProvider = FutureProvider.family<Post, int>(
  (ref, id) => ref.watch(apiServiceProvider).getPost(id),
);

final userProvider = FutureProvider.family<User, int>(
  (ref, id) => ref.watch(apiServiceProvider).getUser(id),
);

// ---- Relationship providers ----
final photosByAlbumProvider = FutureProvider.family<List<Photo>, int>(
  (ref, albumId) => ref.watch(apiServiceProvider).getPhotos(albumId: albumId),
);

final commentsByPostProvider = FutureProvider.family<List<Comment>, int>(
  (ref, postId) => ref.watch(apiServiceProvider).getComments(postId: postId),
);

final postsByUserProvider = FutureProvider.family<List<Post>, int>(
  (ref, userId) => ref.watch(apiServiceProvider).getPosts(userId: userId),
);

final albumsByUserProvider = FutureProvider.family<List<Album>, int>(
  (ref, userId) => ref.watch(apiServiceProvider).getAlbums(userId: userId),
);

final todosByUserProvider = FutureProvider.family<List<Todo>, int>(
  (ref, userId) => ref.watch(apiServiceProvider).getTodos(userId: userId),
);

/// Local-only overrides for todo completion toggles. JSONPlaceholder fakes
/// writes, so we keep the toggle state on the client keyed by todo id.
final todoOverridesProvider =
    StateNotifierProvider<TodoOverrides, Map<int, bool>>(
  (ref) => TodoOverrides(),
);

class TodoOverrides extends StateNotifier<Map<int, bool>> {
  TodoOverrides() : super(const {});

  void toggle(int id, bool current) {
    state = {...state, id: !current};
  }

  bool resolve(int id, bool original) => state[id] ?? original;
}

/// In-memory store of records created via the "+" button on each screen.
/// JSONPlaceholder fakes writes (it returns a new id but never persists), so
/// we keep created items locally and show them at the top of each list.
class ListStore<T> extends StateNotifier<List<T>> {
  ListStore() : super(const []);

  void add(T item) => state = [item, ...state];
}

final localPhotosProvider =
    StateNotifierProvider<ListStore<Photo>, List<Photo>>(
  (ref) => ListStore<Photo>(),
);

final localAlbumsProvider =
    StateNotifierProvider<ListStore<Album>, List<Album>>(
  (ref) => ListStore<Album>(),
);

final localPostsProvider = StateNotifierProvider<ListStore<Post>, List<Post>>(
  (ref) => ListStore<Post>(),
);

final localUsersProvider = StateNotifierProvider<ListStore<User>, List<User>>(
  (ref) => ListStore<User>(),
);

final localCommentsProvider =
    StateNotifierProvider<ListStore<Comment>, List<Comment>>(
  (ref) => ListStore<Comment>(),
);

final localTodosProvider = StateNotifierProvider<ListStore<Todo>, List<Todo>>(
  (ref) => ListStore<Todo>(),
);
