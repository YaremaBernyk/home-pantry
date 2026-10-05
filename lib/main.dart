import 'package:flutter/material.dart';

import 'core/widgets/pantry_widgets.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Home Pantry',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: PantryColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: PantryColors.accent),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: PantryColors.ink,
        displayColor: PantryColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: PantryColors.muted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: PantryColors.border),
        ),
      ),
    ),
    initialRoute: '/login',
    routes: {
      '/login': (_) => const AuthScreen(mode: AuthMode.login),
      '/register': (_) => const AuthScreen(mode: AuthMode.register),
      '/reset': (_) => const AuthScreen(mode: AuthMode.reset),
      '/home': (context) => HomeScreen(
        userName:
            ModalRoute.of(context)?.settings.arguments as String? ?? 'Yarema',
      ),
    },
  );
}
