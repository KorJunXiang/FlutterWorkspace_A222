import 'package:flutter/material.dart';
import 'package:mynelayan/color_schemes.g.dart';
import 'package:mynelayan/splashscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Nelayan',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      home: const SplashScreen(),
    );
  }
}
