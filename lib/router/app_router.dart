import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/alert_detail_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/inbox_screen.dart';
import '../screens/placeholder_screen.dart';
import '../screens/services_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
              routes: [
                GoRoute(
                  path: 'inbox',
                  builder: (context, state) => const InboxScreen(),
                ),
                GoRoute(
                  path: 'alerts',
                  builder: (context, state) => const AlertsScreen(),
                  routes: [
                    GoRoute(
                      path: ':alertId',
                      builder: (context, state) => AlertDetailScreen(
                        alertId: int.parse(state.pathParameters['alertId']!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/services',
              builder: (context, state) => const ServicesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) =>
                  const PlaceholderScreen(label: 'Settings'),
            ),
          ],
        ),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'nav_home'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.dns_outlined),
            selectedIcon: const Icon(Icons.dns),
            label: 'nav_services'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: 'nav_settings'.tr(),
          ),
        ],
      ),
    );
  }
}
