import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shadesmaster/main.dart';

void main() {
  testWidgets('Home screen shows the welcome text and both image sources', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome to Shade Master'), findsOneWidget);
    expect(find.text('Use Camera'), findsOneWidget);
    expect(find.text('Pick Image'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    expect(find.byIcon(Icons.folder), findsOneWidget);
  });
}
