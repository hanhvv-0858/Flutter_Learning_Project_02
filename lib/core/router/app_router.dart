import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:example_flutter_02/core/di/injection.dart';
import 'package:example_flutter_02/core/domain/entities/album.dart';
import 'package:example_flutter_02/core/router/route_constants.dart';
import 'package:example_flutter_02/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:example_flutter_02/features/detail/presentation/bloc/detail_event.dart';
import 'package:example_flutter_02/features/detail/presentation/pages/detail_page.dart';
import 'package:example_flutter_02/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:example_flutter_02/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:example_flutter_02/features/favorites/presentation/pages/favorites_page.dart';
import 'package:example_flutter_02/features/home/presentation/bloc/home_bloc.dart';
import 'package:example_flutter_02/features/home/presentation/bloc/home_event.dart';
import 'package:example_flutter_02/features/home/presentation/pages/home_page.dart';
import 'package:example_flutter_02/features/onboarding/presentation/bloc/onboarding_cubit.dart';
import 'package:example_flutter_02/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:example_flutter_02/features/search/presentation/bloc/search_bloc.dart';
import 'package:example_flutter_02/features/search/presentation/pages/search_page.dart';
import 'package:example_flutter_02/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:example_flutter_02/features/settings/presentation/pages/settings_page.dart';
import 'package:example_flutter_02/features/splash/presentation/bloc/splash_cubit.dart';
import 'package:example_flutter_02/features/splash/presentation/pages/splash_page.dart';
import 'package:example_flutter_02/shared/bottom_nav_shell.dart';

/// Central GoRouter configuration for the entire app.
///
/// Structure:
///   /splash              → SplashPage (no bottom nav)
///   /onboarding          → OnboardingPage (no bottom nav)
///   /detail/:id          → DetailPage – Phase 7 (no bottom nav)
///   /search              → SearchPage – Phase 10 (no bottom nav)
///   StatefulShellRoute   → BottomNavShell with 3 branches:
///     /home              → HomePage – Phase 6
///     /favorites         → FavoritesPage – Phase 8
///     /settings          → SettingsPage – Phase 9
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,
    redirect: _redirect,
    routes: [
      // --- Standalone routes (no bottom navigation bar) ---
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => BlocProvider(
          // Start the 2-second timer as soon as the cubit is created.
          create: (_) => getIt<SplashCubit>()..startAnimation(),
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.onboarding,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<OnboardingCubit>(),
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.detailPath,
        builder: (context, state) {
          final album = state.extra as Album?;
          if (album == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Detail')),
              body: Center(
                child: Text(
                  'Album not found (ID: ${state.pathParameters['id']})',
                ),
              ),
            );
          }
          return BlocProvider(
            create: (_) => getIt<DetailBloc>()..add(DetailLoadRequested(album)),
            child: DetailPage(album: album),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.search,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<SearchBloc>(),
          child: const SearchPage(),
        ),
      ),

      // --- Shell route — tabs share a persistent bottom navigation bar ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BottomNavShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.home,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<HomeBloc>()..add(const HomeFetchRequested()),
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.favorites,
                builder: (context, state) => BlocProvider(
                  create: (_) =>
                      getIt<FavoritesBloc>()
                        ..add(const FavoritesLoadRequested()),
                  child: const FavoritesPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.settings,
                builder: (context, state) => BlocProvider.value(
                  value: getIt<SettingsCubit>(),
                  child: const SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  /// Redirect guard: intercepts navigation to shell tabs and sends
  /// first-time users to onboarding.
  static String? _redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;
    final shellPaths = [
      RouteConstants.home,
      RouteConstants.favorites,
      RouteConstants.settings,
    ];

    if (shellPaths.contains(path)) {
      final prefs = getIt<SharedPreferences>();
      final onboardingDone = prefs.getBool('onboarding_completed') ?? false;
      if (!onboardingDone) return RouteConstants.onboarding;
    }

    return null;
  }
}
