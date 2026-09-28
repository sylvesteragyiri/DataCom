import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_connection_form_screen.dart';
import '../screens/add_connection_type_screen.dart';
import '../screens/alert_detail_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/bucket_detail_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/database_detail_screen.dart';
import '../screens/inbox_screen.dart';
import '../screens/key_detail_screen.dart';
import '../screens/keys_screen.dart';
import '../screens/redis_detail_screen.dart';
import '../screens/services_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/table_detail_screen.dart';
import '../screens/vercel_detail_screen.dart';
import '../widgets/datacom_bottom_nav.dart';

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
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => const AddConnectionTypeScreen(),
                  routes: [
                    GoRoute(
                      path: 'form',
                      builder: (context, state) => AddConnectionFormScreen(
                        connectorType: state.extra as String?,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'db/:connId',
                  builder: (context, state) => DatabaseDetailScreen(
                    connectionId: state.pathParameters['connId']!,
                    title: (state.extra as String?) ?? state.pathParameters['connId']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'table/:tableName',
                      builder: (context, state) => TableDetailScreen(
                        connectionId: state.pathParameters['connId']!,
                        tableName: state.pathParameters['tableName']!,
                        connectionTitle: (state.extra as String?) ?? state.pathParameters['connId']!,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'redis/:connId',
                  builder: (context, state) => RedisDetailScreen(
                    connectionId: state.pathParameters['connId']!,
                    title: (state.extra as String?) ?? state.pathParameters['connId']!,
                  ),
                ),
                GoRoute(
                  path: 'storage/:bucketId',
                  builder: (context, state) => BucketDetailScreen(
                    bucketId: state.pathParameters['bucketId']!,
                    title: (state.extra as String?) ?? state.pathParameters['bucketId']!,
                  ),
                ),
                GoRoute(
                  path: 'cloud/vercel/:connId',
                  builder: (context, state) => VercelDetailScreen(
                    connectionId: state.pathParameters['connId']!,
                    title: (state.extra as String?) ?? state.pathParameters['connId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'keys',
                  builder: (context, state) => const KeysScreen(),
                  routes: [
                    GoRoute(
                      path: ':credId',
                      builder: (context, state) => KeyDetailScreen(
                        index: int.parse(state.pathParameters['credId']!),
                      ),
                    ),
                  ],
                ),
              ],
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
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        // Row, not Center: Center/Align expand to fill the loose-but-finite
        // height Scaffold gives bottomNavigationBar, then center the child
        // *within that full-height box* — which renders as "stuck in the
        // middle of the screen". Row's cross axis always shrink-wraps to its
        // tallest child regardless of incoming constraints, so this actually
        // hugs the pill's own height while still centering it horizontally.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DataComBottomNav(
              currentIndex: navigationShell.currentIndex,
              onSelect: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
