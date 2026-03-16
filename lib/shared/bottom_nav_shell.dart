import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Bottom navigation scaffold used as the ShellRoute widget.
/// Wraps [StatefulNavigationShell] to maintain tab state independently.
class BottomNavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavShell({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    // goBranch with initialLocation: true re-navigates to the branch root
    // when tapping the already-active tab (scroll-to-top pattern).
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
