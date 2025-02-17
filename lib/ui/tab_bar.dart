// Use GoRouter for manage Routing click below link for more detail
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart

import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/route/go_route.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithTabBar extends StatelessWidget {
  const ScaffoldWithTabBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Shopping'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Cart'),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }

  /// NOTE: For a slightly more sophisticated branch switching, change the onTap
  /// handler on the BottomNavigationBar above to the following:
  /// `onTap: (int index) => _onTap(context, index),`
  // ignore: unused_element
  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 1:
        context.push(AppRouter.cart);
      default:
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
    }
  }
}
