# API Demo

A Flutter demo app (Android first, iOS-ready from the same codebase) that consumes the
six [JSONPlaceholder](https://jsonplaceholder.typicode.com/) endpoints and renders
both images and data across multiple linked screens.

## Endpoints used

| Endpoint | Screen |
| --- | --- |
| `/photos` | Photo grid + photo detail |
| `/albums` | Album list + album's photo grid |
| `/posts` | Post list + post detail (body, author, comments) |
| `/users` | User list + profile with linked posts/albums/todos |
| `/comments` | Comment list, filterable by post id |
| `/todos` | Checklist grouped by user (local completed toggle) |

## Tech stack

- **Flutter / Dart** (single codebase for Android APK and iOS)
- **dio** - HTTP client with timeouts and friendly error messages
- **flutter_riverpod** - async data fetching and caching (`FutureProvider`)
- **go_router** - declarative nested navigation (list -> detail)
- **cached_network_image** - image caching with placeholder/error states

## Note on photo images

The `/photos` endpoint returns image URLs pointing at `via.placeholder.com`,
a service that has since shut down, so those URLs no longer load. The app maps
each photo deterministically to a working image from
[picsum.photos](https://picsum.photos) (see `lib/core/image_utils.dart`) so the
grids and detail screens actually render images.

## Project structure

```
lib/
  main.dart                  App entry (ProviderScope + MaterialApp.router)
  app/router.dart            go_router routes
  app/theme.dart             Material 3 light/dark themes
  core/api_client.dart       Dio factory + error description
  core/image_utils.dart      picsum image-url mapping
  data/api_service.dart      One method per resource
  data/providers.dart        Riverpod providers (collections, entities, relations)
  models/                    Photo, Album, Post, User, Comment, Todo
  features/                  home, photos, albums, posts, users, comments, todos
  widgets/                   AsyncValueWidget (loading/error/retry), AppNetworkImage
```

## Running

```bash
flutter pub get
flutter run                 # on an Android emulator or device
```

## Building the APK

```bash
flutter build apk --debug   # or: flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

The Android `INTERNET` permission is included via the default Flutter manifest.

## iOS (later)

The same codebase builds for iOS. On a Mac with Xcode + CocoaPods installed:

```bash
cd ios && pod install && cd ..
flutter build ios
```
