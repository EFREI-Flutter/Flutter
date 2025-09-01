import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../stores/theme_store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Thème'),
            subtitle: Text(theme.mode == ThemeMode.light ? 'Clair' : theme.mode == ThemeMode.dark ? 'Sombre' : 'Système'),
            trailing: DropdownButton<ThemeMode>(
              value: theme.mode,
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('Système')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Clair')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Sombre')),
              ],
              onChanged: (v) => theme.setMode(v ?? ThemeMode.system),
            ),
          ),
        ],
      ),
    );
  }
}
