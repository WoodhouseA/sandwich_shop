import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void dummyFunction() {}

void main() {
  group('CommonAppBar', () {
    testWidgets('displays title and logo correctly',
        (WidgetTester tester) async {
      const CommonAppBar appBar = CommonAppBar(title: 'Test Title');
      const MaterialApp app = MaterialApp(
        home: Scaffold(appBar: appBar),
      );

      await tester.pumpWidget(app);

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final Image logoImage = tester.widget(find.byType(Image));
      expect(
          (logoImage.image as AssetImage).assetName, 'assets/images/logo.png');
    });

    testWidgets('displays actions when provided', (WidgetTester tester) async {
      const CommonAppBar appBar = CommonAppBar(
        title: 'Test Title',
        actions: [
          Icon(Icons.shopping_cart),
          Text('Cart'),
        ],
      );
      const MaterialApp app = MaterialApp(
        home: Scaffold(appBar: appBar),
      );

      await tester.pumpWidget(app);

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('Cart'), findsOneWidget);
    });

    testWidgets('has correct preferred size', (WidgetTester tester) async {
      const CommonAppBar appBar = CommonAppBar(title: 'Test Title');

      expect(
          appBar.preferredSize, equals(const Size.fromHeight(kToolbarHeight)));
    });
  });

  group('StyledButton', () {
    testWidgets('renders correctly with icon and label when enabled',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isTrue);
    });

    testWidgets('renders correctly and is disabled when onPressed is null',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: null,
        icon: Icons.add_shopping_cart,
        label: 'Test Button',
        backgroundColor: Colors.green,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);

      final Finder elevatedButtonFinder = find.byType(ElevatedButton);
      final ElevatedButton button =
          tester.widget<ElevatedButton>(elevatedButtonFinder);
      expect(button.enabled, isFalse);
    });

    testWidgets('displays different icons correctly',
        (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.settings,
        label: 'Settings',
        backgroundColor: Colors.grey,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('has row layout structure', (WidgetTester tester) async {
      const StyledButton testButton = StyledButton(
        onPressed: dummyFunction,
        icon: Icons.star,
        label: 'Star Button',
        backgroundColor: Colors.blue,
      );

      const MaterialApp testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );

      await tester.pumpWidget(testApp);

      expect(find.byType(Row), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('Star Button'), findsOneWidget);
    });
  });
<<<<<<< HEAD

  group('AppDrawer', () {
    testWidgets('renders all menu items', (WidgetTester tester) async {
      const MaterialApp app = MaterialApp(
        home: Scaffold(
          drawer: AppDrawer(),
          body: SizedBox(),
        ),
      );

      await tester.pumpWidget(app);
      
      // Open the drawer
      await tester.dragFrom(const Offset(0, 100), const Offset(300, 0));
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Order'), findsOneWidget);
      expect(find.text('Order History'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });
  });

  group('ResponsiveScaffold', () {
    testWidgets('shows drawer icon on mobile (small screen)',
        (WidgetTester tester) async {
      // Set screen size to mobile portrait
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const MaterialApp app = MaterialApp(
        home: ResponsiveScaffold(
          title: 'Test Title',
          body: Text('Body Content'),
        ),
      );

      await tester.pumpWidget(app);

      // Should find the menu icon (hamburger)
      expect(find.byIcon(Icons.menu), findsOneWidget);
      
      // Drawer should not be visible initially
      expect(find.text('Sandwich Shop'), findsNothing);

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Drawer content should be visible
      expect(find.text('Sandwich Shop'), findsOneWidget);
    });

    testWidgets('shows permanent drawer on desktop (large screen)',
        (WidgetTester tester) async {
      // Set screen size to desktop landscape
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const MaterialApp app = MaterialApp(
        home: ResponsiveScaffold(
          title: 'Test Title',
          body: Text('Body Content'),
        ),
      );

      await tester.pumpWidget(app);

      // Should NOT find the menu icon (hamburger) because drawer is permanent
      expect(find.byIcon(Icons.menu), findsNothing);

      // Drawer content should be visible immediately
      expect(find.text('Sandwich Shop'), findsOneWidget);
      
      // Body content should be visible
      expect(find.text('Body Content'), findsOneWidget);
    });
  });
}

=======
}
>>>>>>> 899750d192265fe0882eb84e662eb4cfc95e5da4
