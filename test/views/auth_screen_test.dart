import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/auth_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: AuthScreen(),
    );
  }

  testWidgets('AuthScreen starts in Sign In mode', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Check title and button text
    expect(find.text('Sign In'), findsWidgets); // AppBar and Button
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Need an account? Sign Up'), findsOneWidget);

    // Confirm Password field should NOT be present
    expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsNothing);
  });

  testWidgets('Switching between Sign In and Sign Up modes', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap to switch to Sign Up
    await tester.tap(find.text('Need an account? Sign Up'));
    await tester.pump();

    // Check updated UI
    expect(find.text('Sign Up'), findsWidgets);
    expect(find.text('Create an Account'), findsOneWidget);
    expect(find.text('Already have an account? Sign In'), findsOneWidget);

    // Confirm Password field SHOULD be present
    expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);

    // Tap to switch back to Sign In
    await tester.tap(find.text('Already have an account? Sign In'));
    await tester.pump();

    // Confirm Password field should be gone
    expect(find.widgetWithText(TextFormField, 'Confirm Password'), findsNothing);
  });
}
