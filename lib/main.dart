import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import './constants.dart';

void main() => runApp(MuzikMatchApp());

class MuzikMatchApp extends StatelessWidget {
  const MuzikMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuzikMatch by znx',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color($primaryColor),
          foregroundColor: Colors.white,
          toolbarTextStyle:
              TextTheme(
                bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
                titleLarge: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                // Puedes agregar más estilos
              ).bodyMedium,
          titleTextStyle:
              TextTheme(
                bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
                titleLarge: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                // Puedes agregar más estilos
              ).titleLarge,
        ),
        scaffoldBackgroundColor: Color($secondaryColor),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
          bodyLarge: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
