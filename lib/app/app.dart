import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskboard/app/shell/home_page.dart';
import 'package:taskboard/core/theme/trello.dart';

/// Lets the board scroll sideways with a mouse drag on desktop/web too.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

const _homeKey = ValueKey('home');

/// `/` is the dock; `/view/:id` opens a full-screen view (table, calendar...).
/// Both share one page key so the dock's panel selection survives navigation.
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (_, _) =>
          const NoTransitionPage(key: _homeKey, child: HomePage()),
    ),
    GoRoute(
      path: '/view/:id',
      pageBuilder: (_, state) => NoTransitionPage(
        key: _homeKey,
        child: HomePage(viewId: state.pathParameters['id']),
      ),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'TaskBoard',
    debugShowCheckedModeBanner: false,
    scrollBehavior: const _AppScrollBehavior(),
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Trello.accent,
        brightness: Brightness.dark,
      ),
    ),
    routerConfig: _router,
  );
}
