import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

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

  testWidgets('ResponsiveScaffold shows Sidebar on desktop',
      (WidgetTester tester) async {
    // Set screen size to desktop
    tester.view.physicalSize = const Size(1200, 800);
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

    // Verify AppDrawer is shown permanently
    expect(find.byType(AppDrawer), findsOneWidget);

    // Verify Hamburger menu does NOT exist (automaticallyImplyLeading: false)
    expect(find.byIcon(Icons.menu), findsNothing);
  });

  testWidgets('Navigation links navigate to correct routes',
      (WidgetTester tester) async {
    // Set screen size to mobile to use Drawer
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      MaterialApp(
        initialRoute: '/order',
        routes: {
          '/order': (context) => const ResponsiveScaffold(
                body: Text('Order Screen'),
                title: Text('Order'),
                currentRoute: '/order',
              ),
          '/cart': (context) => const ResponsiveScaffold(
                body: Text('Cart Screen'),
                title: Text('Cart'),
                currentRoute: '/cart',
              ),
          '/profile': (context) => const ResponsiveScaffold(
                body: Text('Profile Screen'),
                title: Text('Profile'),
                currentRoute: '/profile',
              ),
          '/settings': (context) => const ResponsiveScaffold(
                body: Text('Settings Screen'),
                title: Text('Settings'),
                currentRoute: '/settings',
              ),
        },
      ),
    );

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Tap Cart link
    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();

    // Verify navigation to Cart
    expect(find.text('Cart Screen'), findsOneWidget);
    expect(find.text('Order Screen'), findsNothing);

    // Open drawer again (on Cart screen)
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Tap Profile link
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify navigation to Profile
    expect(find.text('Profile Screen'), findsOneWidget);
  });
}
