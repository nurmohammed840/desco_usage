import 'package:flutter/material.dart';

import 'signal.dart';
import 'dialogs/add_meter.dart';
import 'screens/usage.dart';
import 'screens/consumption.dart';
import 'api/api.dart';

import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true; // bypass SSL check
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

final selectedNav = CreateState(0);
final isLoading = CreateState(0);

Future<T?> loadData<T>(Future<T> Function() cb) async {
  isLoading.set(isLoading.value + 1);
  try {
    return await cb();
  } catch (err) {
    // print(err);
  } finally {
    isLoading.set(isLoading.value - 1);
  }
  return null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desco Usage',
      debugShowCheckedModeBanner: false,
      home: selectedNav.watch((_) {
        final body = [
          const UsageScreen(),
          const ConsumptionScreen(),
        ][selectedNav.value];

        return Scaffold(
          appBar: AppBar(
            title: Text(body.title),
            actions: [
              isLoading.watch(
                (_) => isLoading.value == 0
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
              ),
              PopupMenuButton(
                position: .under,
                icon: const Padding(
                  padding: .symmetric(horizontal: 8),
                  child: Icon(Icons.more_vert),
                ),
                onSelected: (value) {},
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () async {
                      final info = await acceptMeterInfo(context);
                      if (info != null) {
                        final data = await loadData(() => getBalance(info));
                        if (data != null) {
                          
                        }
                      }
                    },
                    value: 'add_meter',
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Add Meter'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 8),
                        Text('Settings'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: body,
          bottomNavigationBar: NavigationBar(
            labelBehavior: .alwaysHide,
            selectedIndex: selectedNav.value,
            onDestinationSelected: (idx) => selectedNav.set(idx),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Usage'),
              NavigationDestination(
                icon: Icon(Icons.bolt),
                label: 'Consumption',
              ),
            ],
          ),
        );
      }),
    );
  }
}
