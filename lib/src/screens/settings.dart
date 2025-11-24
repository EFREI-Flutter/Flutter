import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stores/theme_store.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeStore>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha:0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.color_lens_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Thème de l'application",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Choisis entre clair, sombre ou le thème du système.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<ThemeMode>(
                      value: theme.mode,
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('Système'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Clair'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Sombre'),
                        ),
                      ],
                      onChanged: (v) =>
                          theme.setMode(v ?? ThemeMode.system),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
