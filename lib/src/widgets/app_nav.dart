import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNav extends StatelessWidget {
  final Widget child;

  const AppNav({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Row(
      children: [
        NavigationRail(
          selectedIndex: _index(location),
          onDestinationSelected: (i) {
            if (i == 0) context.go('/home');
            if (i == 1) context.go('/todo/new');
            if (i == 2) context.go('/settings');
          },
          labelType: NavigationRailLabelType.all,
          leading: const SizedBox(height: 16),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text('Accueil'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle),
              label: Text('Ajouter'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: Text('Réglages'),
            ),
          ],
        ),
        Expanded(child: child),
      ],
    );
  }

  int _index(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/todo')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }
}
