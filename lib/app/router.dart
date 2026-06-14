import 'package:go_router/go_router.dart';

import '../features/albums/album_detail_screen.dart';
import '../features/albums/albums_screen.dart';
import '../features/comments/comments_screen.dart';
import '../features/home/home_screen.dart';
import '../features/photos/photo_detail_screen.dart';
import '../features/photos/photos_screen.dart';
import '../features/posts/post_detail_screen.dart';
import '../features/posts/posts_screen.dart';
import '../features/todos/todos_screen.dart';
import '../features/users/user_detail_screen.dart';
import '../features/users/users_screen.dart';

int _id(GoRouterState state) =>
    int.tryParse(state.pathParameters['id'] ?? '') ?? 0;

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/photos',
      builder: (context, state) => const PhotosScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => PhotoDetailScreen(photoId: _id(state)),
        ),
      ],
    ),
    GoRoute(
      path: '/albums',
      builder: (context, state) => const AlbumsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => AlbumDetailScreen(albumId: _id(state)),
        ),
      ],
    ),
    GoRoute(
      path: '/posts',
      builder: (context, state) => const PostsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => PostDetailScreen(postId: _id(state)),
        ),
      ],
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => const UsersScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) => UserDetailScreen(userId: _id(state)),
        ),
      ],
    ),
    GoRoute(
      path: '/comments',
      builder: (context, state) => const CommentsScreen(),
    ),
    GoRoute(
      path: '/todos',
      builder: (context, state) => const TodosScreen(),
    ),
  ],
);
