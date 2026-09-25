import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu/core/localization/language_provider.dart';
import 'package:shilpsetu/core/theme/tokens.dart';
import 'package:shilpsetu/features/auth/presentation/auth_screen.dart';
import 'package:shilpsetu/features/capture/presentation/capture_screen.dart';
import 'package:shilpsetu/features/catalog/presentation/catalog_screen.dart';
import 'package:shilpsetu/features/cataloger/presentation/cataloger_screen.dart';
import 'package:shilpsetu/features/home/presentation/home_screen.dart';
import 'package:shilpsetu/features/language/presentation/language_selection_screen.dart';
import 'package:shilpsetu/features/pricing/presentation/pricing_screen.dart';
import 'package:shilpsetu/features/splash/presentation/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/language',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/auth',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/capture',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CaptureScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/catalog',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CatalogScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/cataloger',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CatalogerScreen(),
      ),
      GoRoute(
        path: '/pricing',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PricingScreen(),
      ),
    ],
  );
});

class _ScaffoldWithNavBar extends ConsumerWidget {
  const _ScaffoldWithNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langState = ref.watch(languageProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Palette.ink.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 76,
            indicatorColor: Palette.purpleContainerLight,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined, size: 28),
                selectedIcon: const Icon(
                  Icons.home_rounded,
                  size: 30,
                  color: Palette.purpleContainerDark,
                ),
                label: langState.strings.navHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.camera_alt_outlined, size: 28),
                selectedIcon: const Icon(
                  Icons.camera_alt_rounded,
                  size: 30,
                  color: Palette.purpleContainerDark,
                ),
                label: langState.strings.navCapture,
              ),
              NavigationDestination(
                icon: const Icon(Icons.grid_view_outlined, size: 28),
                selectedIcon: const Icon(
                  Icons.grid_view_rounded,
                  size: 30,
                  color: Palette.purpleContainerDark,
                ),
                label: langState.strings.navCatalog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
