import 'package:flutter/material.dart';

import 'app_state.dart';
import 'screens/usage.dart';
import 'screens/consumption.dart';

import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true; // bypass SSL check
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  AppInstance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const screens = [UsageScreen(), ConsumptionScreen()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desco Usage',
      debugShowCheckedModeBanner: false,
      home: selectedNav.watch((_) {
        if (selectedNav.value == 1) {
          ConsumptionScreen.loadData();
        }

        return Scaffold(
          body: IndexedStack(index: selectedNav.value, children: MyApp.screens),
          bottomNavigationBar: NavigationBar(
            labelBehavior: .alwaysHide,
            selectedIndex: selectedNav.value,
            onDestinationSelected: (idx) => selectedNav.set(idx),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.speed), label: 'Usage'),
              NavigationDestination(
                icon: Icon(Icons.timeline),
                label: 'Daily Consumption',
              ),
            ],
          ),
        );
      }),
    );
  }
}
