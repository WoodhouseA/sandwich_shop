import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/about_screen.dart';

void main() {
  testWidgets('AboutScreen displays correct title and content', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));

    // Verify AppBar title
    expect(find.text('About Us'), findsOneWidget);

    // Verify Body content
    expect(find.text('Welcome to Sandwich Shop!'), findsOneWidget);
    expect(find.textContaining('We are a family-owned business'), findsOneWidget);
  });
}
