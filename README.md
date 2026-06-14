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

## Navigation

The app uses `go_router` with a push-based stack: the Home dashboard opens each
section, and every other screen (lists, details, and cross-links such as
post -> author or photo -> album) is pushed on top. As a result, every non-home
screen shows a back arrow in the app bar, and backing out always returns to the
Home dashboard.

## Environment setup

This project was set up with Flutter 3.44.2 and OpenJDK 17. On macOS (Homebrew),
configure the toolchain once per terminal session:

```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@17
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH="$JAVA_HOME/bin:/opt/homebrew/bin:$ANDROID_HOME/platform-tools:$PATH"
cd "<path-to>/api_demo_app"
```

## Running on an emulator

```bash
flutter pub get
flutter emulators --launch Pixel_9_Pro   # start an emulator and wait for it to boot
flutter run                              # build + install + hot reload (debug)
```

While running: `r` = hot reload, `R` = hot restart, `q` = quit.

## Building the APK

```bash
flutter build apk --release   # -> build/app/outputs/flutter-apk/app-release.apk
flutter build apk --debug     # -> build/app/outputs/flutter-apk/app-debug.apk
```

The Android `INTERNET` permission is declared in `android/app/src/main/AndroidManifest.xml`.
This is required for release/profile builds, since Flutter only adds it automatically to the
debug manifest.

## Prebuilt APK

A ready-to-install release APK is kept (outside the git-ignored `build/` folder) at:

```
dist/api_demo_app-v1.0.0-release.apk
```

Install it on a running emulator or connected device with:

```bash
adb install -r dist/api_demo_app-v1.0.0-release.apk
```

## iOS (later)

The same codebase builds for iOS. On a Mac with Xcode + CocoaPods installed:

```bash
cd ios && pod install && cd ..
flutter build ios
```
