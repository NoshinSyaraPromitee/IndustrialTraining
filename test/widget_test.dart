import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:firstapp/main.dart';

void main() {
  testWidgets('App boots to the home screen with Top/New/Best tabs', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger one frame. We deliberately do NOT call
    // pumpAndSettle() here: NewsScreen kicks off a real network request
    // via Injector, and that Future never resolves in a test environment
    // (no network access), so pumpAndSettle would hang/time out. A single
    // pump() is enough to verify the shell renders correctly.
    await tester.pumpWidget(const HackerNewsApp());
    await tester.pump();

    // The three-tab bottom navigation should be present immediately.
    expect(find.text('Top'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(find.text('Best'), findsOneWidget);

    // The Top tab's app bar should be showing by default.
    expect(find.text('Top News'), findsOneWidget);

    // While the story fetch is in flight, the loading spinner should show.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}