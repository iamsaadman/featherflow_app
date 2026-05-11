// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:featherflow/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FeatherflowApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Featherflow'), findsOneWidget);
    expect(find.text('Smart Poultry Farm Management'), findsOneWidget);

    // Advance past the splash screen timers so no pending timers remain.
    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pumpAndSettle();
  });
}
