import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

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
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('AppDrawer highlights the current route', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppDrawer(currentRoute: '/cart'),
        ),
      ),
    );

    // Helper to check color
    void expectColor(String text, Color? color) {
      final textWidget = tester.widget<Text>(find.text(text));
      expect(textWidget.style?.color, color);
      
      final listTile = tester.widget<ListTile>(find.ancestor(
        of: find.text(text),
        matching: find.byType(ListTile),
      ));
      final icon = listTile.leading as Icon;
      expect(icon.color, color);
    }

    // Cart should be blue (highlighted)
    expectColor('Cart', Colors.blue);

    // Others should be null (default color)
    expectColor('Order', null);
    expectColor('Profile', null);
  });

  testWidgets('AppDrawer highlights Profile route correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppDrawer(currentRoute: '/profile'),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text('Profile'));
    expect(textWidget.style?.color, Colors.blue);
    
    final orderTextWidget = tester.widget<Text>(find.text('Order'));
    expect(orderTextWidget.style?.color, null);
  });
}
