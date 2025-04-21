import 'package:cit_238_sensors/screens/code-scan_screen.dart';
import 'package:flutter/material.dart';

import 'screens/sensors1_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/scan',
      routes: {
        '/': (context) => const Sensors1Screen(),
        '/scan': (context) => const CodeScanScreen(),
      },
    );
  }
}
