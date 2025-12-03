import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/widgets/responsive_scaffold.dart';
import 'package:sandwich_shop/views/widgets/app_drawer.dart';

void main() {
  testWidgets('ResponsiveScaffold shows Drawer on mobile',
      (WidgetTester tester) async {
    // Set screen size to mobile
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: ResponsiveScaffold(
          body: Text('Body Content'),
          title: Text('Title'),
          currentRoute: '/test',
        ),
      ),
    );

    // Verify body is shown
    expect(find.text('Body Content'), findsOneWidget);

    // Verify Drawer is NOT shown initially (it's modal)
    expect(find.byType(AppDrawer), findsNothing);

    // Verify Hamburger menu exists (Scaffold automatically adds it)
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Verify Drawer is shown
    expect(find.byType(AppDrawer), findsOneWidget);
  });
}
