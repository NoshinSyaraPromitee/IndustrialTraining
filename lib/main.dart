import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';

void main() {
  // Web only: since go_router 8, push() no longer updates the URL bar by default.
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const HackerNewsApp());
}

class HackerNewsApp extends StatelessWidget {
  const HackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hacker News',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}