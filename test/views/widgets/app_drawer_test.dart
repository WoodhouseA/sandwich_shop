import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/widgets/app_drawer.dart';

void main() {
  testWidgets('AppDrawer renders all menu items', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppDrawer(currentRoute: '/order'),
        ),
      ),
    );

    expect(find.text('Sandwich Shop'), findsOneWidget);
    expect(find.text('Order'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Sign In / Sign Up'), findsOneWidget);
  });
}
