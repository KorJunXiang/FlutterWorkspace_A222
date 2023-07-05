import 'package:flutter/material.dart';
import 'package:lab_assignment_2/splashscreen.dart';

import 'color_schemes.g.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterIT',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      home: const SplashScreen(),
    );
  }
}
