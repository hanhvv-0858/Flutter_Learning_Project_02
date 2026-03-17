# Music Discovery 🎵

Ứng dụng mobile học Flutter, sử dụng **iTunes API** (miễn phí, không cần xác thực) để khám phá và lưu trữ album âm nhạc. Dự án được xây dựng theo kiến trúc **Clean Architecture 3 tầng** (Domain → Data → Presentation) với BLoC pattern.

**Nền tảng**: Android 6.0+ / iOS 13+

---

## Tính năng (User Stories)

| # | Màn hình | Mô tả | Độ ưu tiên |
|---|----------|-------|------------|
| US1 | Splash & Onboarding | Splash animation (fade-in + scale), tutorial 3 trang, lưu trạng thái bằng SharedPreferences | P1 |
| US2 | Home — Khám phá âm nhạc | Danh sách Top Albums từ iTunes RSS Feed, pull-to-refresh, loading/error/data states | P2 |
| US3 | Detail — Chi tiết album | Danh sách track qua iTunes Lookup API, thời lượng mm:ss, lưu/xóa yêu thích (Sqflite) | P3 |
| US4 | Favorites — Ngoại tuyến | Danh sách album đã lưu, hoạt động offline, vuốt Dismissible để xóa | P4 |
| US5 | Settings — Cài đặt | Chuyển ngôn ngữ EN/VI ngay lập tức, lưu qua SharedPreferences, giữ qua lần khởi động | P5 |
| US6 | Search — Tìm kiếm | Debounced live search (300ms) qua iTunes Search API, auto-focus TextField | P6 |

---

## Tech Stack

| Thành phần | Thư viện / Công nghệ |
|------------|----------------------|
| Ngôn ngữ | Dart ^3.11.0 |
| Framework | Flutter 3.41+ (stable) |
| State Management | `flutter_bloc` ^9.1.0 (BLoC + Cubit) + `equatable` ^2.0.7 |
| Navigation | `go_router` ^14.8.0 (StatefulShellRoute + redirect guard) |
| Networking | `dio` ^5.7.0 |
| Local DB | `sqflite` ^2.4.1 (favorites) |
| Key-Value Storage | `shared_preferences` ^2.3.4 (onboarding, settings) |
| Image Cache | `cached_network_image` ^3.4.1 |
| Dependency Injection | `get_it` ^8.0.3 + `injectable` ^2.5.0 (code-generated) |
| Serialization | `json_annotation` ^4.11.0 + `json_serializable` ^6.9.4 |
| Error Handling | `dartz` ^0.10.1 (`Either<Failure, T>`) |
| Internationalization | `flutter_localizations` + `intl` (EN / VI) |
| Stream Utils | `stream_transform` ^2.1.1 (debounce cho SearchBloc) |
| Linting | `flutter_lints` ^6.0.0 (zero-warning policy) |
| Testing | `bloc_test` ^10.0.0 + `mocktail` ^1.0.4 |
| Code Generation | `build_runner` ^2.4.14 + `injectable_generator` ^2.7.0 + `freezed` ^3.0.0 |
| API | iTunes RSS Feed + Search + Lookup API (free, no auth) |

---

## Kiến trúc

```
Domain (Business Logic)  ←  Data (Implementation)  ←  Presentation (UI)
  lib/core/domain/           lib/features/*/data/       lib/features/*/presentation/
  lib/features/*/domain/     lib/core/data/             lib/shared/
```

- **Domain** (`domain/`): Entities thuần Dart (`Album`, `Track`), abstract Repository contracts, UseCase pattern (`UseCase<Type, Params>`), sealed `Failure` hierarchy. Không phụ thuộc framework.
- **Data** (`data/`): Repository implementations, Datasources (Remote via Dio, Local via Sqflite/SharedPreferences), Models (DTOs) với `fromJson`/`toJson`. Đăng ký qua `@LazySingleton(as: Repository)`.
- **Presentation** (`presentation/`): BLoC/Cubit cho state management, StatelessWidget/StatefulWidget thuần túy. Không import data layer trực tiếp.

### Dependency Injection

Sử dụng **GetIt + injectable** với code generation. Tất cả dependencies được đăng ký tự động:

```dart
// lib/core/di/injection.dart
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

### Error Handling

Mọi repository trả về `Either<Failure, T>` (từ `dartz`). Sealed class hierarchy:

```dart
sealed class Failure extends Equatable {
  final String message;
}
├── ServerFailure     // HTTP 4xx, 5xx
├── NetworkFailure    // Timeout, no connectivity
├── CacheFailure      // Sqflite / SharedPreferences error
└── UnknownFailure    // Catch-all
```

---

## Cài đặt & Chạy ứng dụng

### Yêu cầu

- Flutter SDK 3.41+ (stable channel) — kiểm tra bằng `flutter --version`
- Dart SDK ^3.11.0 (đi kèm với Flutter)
- Android Studio hoặc Xcode (cho emulator/simulator)

> Ứng dụng sử dụng **iTunes API** — hoàn toàn miễn phí, **không cần API key hay tài khoản** nào.

### 1. Clone và cài đặt

```bash
git clone <repo-url>
cd flutter_learning_project_2
```

### 2. Cài đặt dependencies

```bash
flutter pub get
```

### 3. Sinh code (injectable + JSON serialization)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Sinh file localization

```bash
flutter gen-l10n
```

### 5. Chạy ứng dụng

```bash
# Android emulator
flutter run

# iOS simulator
flutter run -d iphone

# Xem danh sách thiết bị
flutter devices
```

---

## Cấu trúc thư mục

```
lib/
├── main.dart                       # Entry point — khởi tạo DI, load locale, runApp
├── app.dart                        # MaterialApp.router + l10n + theme + SettingsCubit
├── core/
│   ├── data/
│   │   ├── models/
│   │   │   ├── album_model.dart        # AlbumModel — fromItunesRss / fromItunesSearch / toJson
│   │   │   └── track_model.dart        # TrackModel — fromItunesLookup / toJson
│   │   └── datasources/
│   │       └── database_helper.dart    # Sqflite init + migration v1 (bảng favorites)
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── album.dart              # Album entity (Equatable)
│   │   │   └── track.dart              # Track entity (Equatable)
│   │   ├── failure/
│   │   │   └── failure.dart            # Sealed Failure hierarchy (Server/Network/Cache/Unknown)
│   │   └── usecase/
│   │       └── usecase.dart            # Abstract UseCase<Type, Params> base class
│   ├── di/
│   │   ├── injection.dart              # GetIt instance + @InjectableInit setup
│   │   ├── injection.config.dart       # Generated injectable configuration
│   │   └── register_module.dart        # Manual/factory registrations (Dio, SharedPreferences...)
│   ├── network/
│   │   ├── api_constants.dart          # iTunes RSS/Search/Lookup URLs + timeouts
│   │   └── dio_client.dart             # Dio singleton + LogInterceptor (debug mode)
│   ├── router/
│   │   ├── app_router.dart             # GoRouter config — StatefulShellRoute + redirect guard
│   │   └── route_constants.dart        # Hằng số đường dẫn (/splash, /home, /detail/:id...)
│   ├── theme/
│   │   └── app_theme.dart              # Material 3 theme (seed color #6750A4)
│   ├── l10n/
│   │   ├── app_en.arb                  # Chuỗi tiếng Anh (26 keys)
│   │   └── app_vi.arb                  # Chuỗi tiếng Việt (26 keys)
│   └── widgets/
│       ├── cached_image.dart           # CachedNetworkImage wrapper (placeholder + errorWidget)
│       ├── loading_view.dart           # CircularProgressIndicator centered
│       └── error_view.dart             # Error message + Retry button
├── features/
│   ├── splash/                         # US1 — Splash animation (Cubit)
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── splash_cubit.dart       # SplashAnimating → SplashComplete
│   │       │   └── splash_state.dart
│   │       └── pages/
│   │           └── splash_page.dart        # AnimatedOpacity + AnimatedScale
│   ├── onboarding/                     # US1 — Tutorial 3 trang (Cubit)
│   │   ├── domain/
│   │   │   ├── repositories/onboarding_repository.dart
│   │   │   └── usecases/
│   │   │       ├── check_onboarding_status.dart
│   │   │       └── complete_onboarding.dart
│   │   ├── data/
│   │   │   ├── repositories/onboarding_repository_impl.dart
│   │   │   └── datasources/onboarding_local_datasource.dart  # SharedPreferences
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── onboarding_cubit.dart   # nextPage / skip → OnboardingComplete
│   │       │   └── onboarding_state.dart
│   │       ├── pages/onboarding_page.dart  # PageView + dots indicator
│   │       └── widgets/
│   │           ├── onboarding_page_item.dart
│   │           └── tutorial_page_data.dart
│   ├── home/                           # US2 — Top Albums (BLoC)
│   │   ├── domain/
│   │   │   ├── repositories/home_repository.dart
│   │   │   └── usecases/get_top_albums.dart
│   │   ├── data/
│   │   │   ├── repositories/home_repository_impl.dart
│   │   │   └── datasources/home_remote_datasource.dart       # Dio → iTunes RSS Feed
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── home_bloc.dart          # HomeFetchRequested → Loading → Loaded/Error
│   │       │   ├── home_event.dart
│   │       │   └── home_state.dart
│   │       ├── pages/home_page.dart        # RefreshIndicator + ListView
│   │       └── widgets/album_list_item.dart # CachedImage card
│   ├── detail/                         # US3 — Track list + favorite toggle (BLoC)
│   │   ├── domain/
│   │   │   ├── repositories/detail_repository.dart
│   │   │   └── usecases/get_album_tracks.dart
│   │   ├── data/
│   │   │   ├── repositories/detail_repository_impl.dart
│   │   │   └── datasources/detail_remote_datasource.dart     # Dio → iTunes Lookup API
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── detail_bloc.dart        # DetailLoadRequested + DetailToggleFavorite
│   │       │   ├── detail_event.dart
│   │       │   └── detail_state.dart
│   │       ├── pages/detail_page.dart      # SliverAppBar + track list + FAB
│   │       └── widgets/
│   │           ├── favorite_button.dart
│   │           └── track_list_item.dart    # Track row với thời lượng mm:ss
│   ├── favorites/                      # US4 — Album đã lưu, offline (BLoC)
│   │   ├── domain/
│   │   │   ├── repositories/favorites_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_favorites.dart
│   │   │       ├── save_favorite.dart
│   │   │       ├── remove_favorite.dart
│   │   │       └── check_is_favorite.dart
│   │   ├── data/
│   │   │   ├── models/favorite_model.dart  # FavoriteModel — toMap / fromMap
│   │   │   ├── repositories/favorites_repository_impl.dart
│   │   │   └── datasources/favorites_local_datasource.dart   # Sqflite CRUD
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── favorites_bloc.dart     # FavoritesLoadRequested + FavoritesRemoveRequested
│   │       │   ├── favorites_event.dart
│   │       │   └── favorites_state.dart
│   │       ├── pages/favorites_page.dart   # Dismissible list (hoạt động offline)
│   │       └── widgets/favorite_list_item.dart
│   ├── search/                         # US6 — iTunes Search (BLoC + debounce)
│   │   ├── domain/
│   │   │   ├── repositories/search_repository.dart
│   │   │   └── usecases/search_albums.dart
│   │   ├── data/
│   │   │   ├── repositories/search_repository_impl.dart
│   │   │   └── datasources/search_remote_datasource.dart     # Dio → iTunes Search API
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── search_bloc.dart        # SearchQueryChanged (debounce 300ms) + SearchSubmitted
│   │       │   ├── search_event.dart
│   │       │   └── search_state.dart
│   │       ├── pages/search_page.dart      # Auto-focus TextField + BlocBuilder
│   │       └── widgets/search_result_item.dart
│   └── settings/                       # US5 — Ngôn ngữ EN/VI (Cubit)
│       ├── domain/
│       │   ├── repositories/settings_repository.dart
│       │   └── usecases/
│       │       ├── get_current_locale.dart
│       │       └── change_locale.dart
│       ├── data/
│       │   ├── repositories/settings_repository_impl.dart
│       │   └── datasources/settings_local_datasource.dart    # SharedPreferences (locale_code)
│       └── presentation/
│           ├── bloc/
│           │   ├── settings_cubit.dart     # loadLocale / changeLocale → SettingsState
│           │   └── settings_state.dart
│           └── pages/settings_page.dart    # Radio list: English / Tiếng Việt
└── shared/
    └── bottom_nav_shell.dart           # StatefulShellRoute wrapper — 3 tabs (Home, Favorites, Settings)
```

---

## Unit Tests

122 tests — **0 failures** (`flutter test`).

```
test/
├── placeholder_test.dart                   # Smoke test
├── core/
│   ├── domain/entities/
│   │   └── album_track_test.dart               # Album & Track equality, props, immutability
│   └── data/models/
│       ├── album_model_test.dart                # fromItunesRss, fromItunesSearch, image upscaling
│       └── track_model_test.dart                # fromItunesLookup, wrapperType == "track" filter
├── features/
│   ├── splash/presentation/bloc/
│   │   └── splash_cubit_test.dart               # SplashAnimating → SplashComplete
│   ├── onboarding/
│   │   ├── data/repositories/
│   │   │   └── onboarding_repository_impl_test.dart  # Mock datasource, Right/Left paths
│   │   └── presentation/bloc/
│   │       └── onboarding_cubit_test.dart            # nextPage, skip → OnboardingComplete
│   ├── home/
│   │   ├── data/repositories/
│   │   │   └── home_repository_impl_test.dart        # Success, NetworkFailure, ServerFailure
│   │   └── presentation/bloc/
│   │       └── home_bloc_test.dart                   # HomeFetchRequested → [Loading, Loaded/Error]
│   ├── detail/
│   │   ├── data/repositories/
│   │   │   └── detail_repository_impl_test.dart      # Track list success, all Failure types
│   │   └── presentation/bloc/
│   │       └── detail_bloc_test.dart                 # DetailLoadRequested + DetailToggleFavorite
│   ├── favorites/
│   │   ├── data/repositories/
│   │   │   └── favorites_repository_impl_test.dart   # Insert, delete, getAll, isFavorite + CacheFailure
│   │   └── presentation/bloc/
│   │       └── favorites_bloc_test.dart              # FavoritesLoadRequested → Loaded/Empty, Remove
│   ├── search/
│   │   ├── data/repositories/
│   │   │   └── search_repository_impl_test.dart      # Success, empty, 5 network types, ServerFailure
│   │   └── presentation/bloc/
│   │       └── search_bloc_test.dart                 # Debounce, SearchSubmitted → Loaded/Empty/Error
│   └── settings/presentation/bloc/
│       └── settings_cubit_test.dart                  # loadLocale, changeLocale persistence
```

Chạy toàn bộ tests:

```bash
flutter test
```

Chạy với coverage:

```bash
flutter test --coverage
# File output: coverage/lcov.info
```

---

## Luồng điều hướng

```
Launch → main.dart (configureDependencies + loadLocale)
  → Splash (fade-in + scale animation)
      ├── Lần đầu dùng → Onboarding (3 trang + dots) → Home
      └── Đã dùng rồi  → Home (bỏ qua onboarding — redirect guard)

Home [tab 0]
  ├── Tap album card → Detail (track list + favorite toggle FAB)
  └── Tap search icon → Search (debounced 300ms + instant submit)

Favorites [tab 1]
  ├── Album đã lưu (hoạt động offline — Sqflite)
  ├── Tap album → Detail
  └── Swipe trái → xóa (Dismissible)

Settings [tab 2]
  └── Chọn ngôn ngữ: English / Tiếng Việt
      → Cập nhật ngay lập tức toàn bộ app (BlocBuilder trên SettingsCubit)
```

---

## iTunes API Endpoints

| Endpoint | URL | Mục đích |
|----------|-----|----------|
| RSS Feed | `https://itunes.apple.com/{country}/rss/topalbums/limit={n}/json` | Danh sách top albums (Home) |
| Search | `https://itunes.apple.com/search?term={query}&entity=album&limit=30` | Tìm kiếm album (Search) |
| Lookup | `https://itunes.apple.com/lookup?id={albumId}&entity=song` | Danh sách track (Detail) |

> Tất cả API đều **miễn phí** và **không cần API key**.

---

## Các lệnh thường dùng

| Lệnh | Mục đích |
|------|----------|
| `flutter pub get` | Cài / cập nhật dependencies |
| `dart run build_runner build --delete-conflicting-outputs` | Sinh lại code (injectable + json_serializable) |
| `flutter gen-l10n` | Tạo lại code localization từ .arb |
| `flutter analyze` | Kiểm tra lint (phải đạt zero warnings) |
| `dart format lib/` | Format toàn bộ code Dart |
| `flutter test` | Chạy tất cả 122 unit tests |
| `flutter test --coverage` | Chạy tests + sinh coverage/lcov.info |
| `flutter build apk --debug` | Build Android debug APK |
| `flutter build ios --debug --no-codesign` | Build iOS debug |
