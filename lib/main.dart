import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() => runApp(const PokeFlutterApp());

class PokeFlutterApp extends StatelessWidget {
  const PokeFlutterApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'PokéFlutter',
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    routerConfig: appRouter,
  );
}
