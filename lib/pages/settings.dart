import 'package:desco_usage/signal.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  static final theme = CreateState(ThemeMode.light);
  static final showConsumerInfo = CreateState(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          theme.watch(
            (_) => SwitchListTile(
              title: const Text("Dark Mode"),
              subtitle: const Text("Use dark theme"),
              secondary: const Icon(Icons.dark_mode),
              value: theme.value == .dark,
              onChanged: (value) {
                theme.set(value ? .dark : .light);
              },
            ),
          ),
          showConsumerInfo.watch(
            (_) => SwitchListTile(
              title: const Text("Consumer Info"),
              subtitle: const Text("Enable to display consumer details"),
              secondary: const Icon(Icons.person),
              value: showConsumerInfo.value,
              onChanged: (value) {
                showConsumerInfo.set(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
