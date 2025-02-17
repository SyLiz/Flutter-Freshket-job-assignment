// Use GoRouter for manage Routing click below link for more detail
// https://pub.dev/packages/go_router

import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/ui/tab_bar.dart';
import 'package:go_router/go_router.dart';

import '../ui/cart/cart_page.dart';
import '../ui/shopping/shopping_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static const shopping = "/shopping";
  static const cart = "/cart";

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: shopping,
    routes: <RouteBase>[
      // #docregion configuration-builder
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return ScaffoldWithTabBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: shopping,
                builder: (BuildContext context, GoRouterState state) => const ShoppingPage(),
                routes: <RouteBase>[],
              ),
            ],
            // To enable preloading of the initial locations of branches, pass
            // 'true' for the parameter `preload` (false is default).
          ),
        ],
      ),
      GoRoute(
        path: cart,
        builder: (BuildContext context, GoRouterState state) => const CartPage(),
        routes: <RouteBase>[],
      ),
    ],
  );
}
