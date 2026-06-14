import 'package:dio/dio.dart';

import '../models/album.dart';
import '../models/comment.dart';
import '../models/photo.dart';
import '../models/post.dart';
import '../models/todo.dart';
import '../models/user.dart';

/// Thin wrapper around [Dio] exposing one method per JSONPlaceholder resource.
class ApiService {
  ApiService(this._dio);

  final Dio _dio;

  List<T> _mapList<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = response.data as List<dynamic>;
    return data
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  // ---- Photos ----
  Future<List<Photo>> getPhotos({int? albumId}) async {
    final res = await _dio.get(
      '/photos',
      queryParameters: albumId != null ? {'albumId': albumId} : null,
    );
    return _mapList(res, Photo.fromJson);
  }

  Future<Photo> createPhoto(Photo photo) async {
    final res = await _dio.post('/photos', data: {
      'albumId': photo.albumId,
      'title': photo.title,
      'url': photo.url,
      'thumbnailUrl': photo.thumbnailUrl,
    });
    return Photo.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Photo> getPhoto(int id) async {
    final res = await _dio.get('/photos/$id');
    return Photo.fromJson(res.data as Map<String, dynamic>);
  }

  // ---- Albums ----
  Future<List<Album>> getAlbums({int? userId}) async {
    final res = await _dio.get(
      '/albums',
      queryParameters: userId != null ? {'userId': userId} : null,
    );
    return _mapList(res, Album.fromJson);
  }

  Future<Album> createAlbum(Album album) async {
    final res = await _dio.post('/albums', data: {
      'userId': album.userId,
      'title': album.title,
    });
    return Album.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Album> getAlbum(int id) async {
    final res = await _dio.get('/albums/$id');
    return Album.fromJson(res.data as Map<String, dynamic>);
  }

  // ---- Posts ----
  Future<List<Post>> getPosts({int? userId}) async {
    final res = await _dio.get(
      '/posts',
      queryParameters: userId != null ? {'userId': userId} : null,
    );
    return _mapList(res, Post.fromJson);
  }

  Future<Post> createPost(Post post) async {
    final res = await _dio.post('/posts', data: {
      'userId': post.userId,
      'title': post.title,
      'body': post.body,
    });
    return Post.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Post> getPost(int id) async {
    final res = await _dio.get('/posts/$id');
    return Post.fromJson(res.data as Map<String, dynamic>);
  }

  // ---- Users ----
  Future<List<User>> getUsers() async {
    final res = await _dio.get('/users');
    return _mapList(res, User.fromJson);
  }

  Future<User> createUser(User user) async {
    final res = await _dio.post('/users', data: {
      'name': user.name,
      'username': user.username,
      'email': user.email,
      'phone': user.phone,
    });
    return User.fromJson(res.data as Map<String, dynamic>);
  }

  Future<User> getUser(int id) async {
    final res = await _dio.get('/users/$id');
    return User.fromJson(res.data as Map<String, dynamic>);
  }

  // ---- Comments ----
  Future<List<Comment>> getComments({int? postId}) async {
    final res = await _dio.get(
      '/comments',
      queryParameters: postId != null ? {'postId': postId} : null,
    );
    return _mapList(res, Comment.fromJson);
  }

  Future<Comment> createComment(Comment comment) async {
    final res = await _dio.post('/comments', data: {
      'postId': comment.postId,
      'name': comment.name,
      'email': comment.email,
      'body': comment.body,
    });
    return Comment.fromJson(res.data as Map<String, dynamic>);
  }

  // ---- Todos ----
  Future<List<Todo>> getTodos({int? userId}) async {
    final res = await _dio.get(
      '/todos',
      queryParameters: userId != null ? {'userId': userId} : null,
    );
    return _mapList(res, Todo.fromJson);
  }

  Future<Todo> createTodo(Todo todo) async {
    final res = await _dio.post('/todos', data: {
      'userId': todo.userId,
      'title': todo.title,
      'completed': todo.completed,
    });
    return Todo.fromJson(res.data as Map<String, dynamic>);
  }
}
