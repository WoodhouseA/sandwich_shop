import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

void main() {
  group('StyledButton', () {
    testWidgets('renders with correct label and icon', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StyledButton(
              onPressed: () => pressed = true,
              icon: Icons.add,
              label: 'Test Button',
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      
      await tester.tap(find.byType(StyledButton));
      expect(pressed, isTrue);
    });
  });

  group('CartBadge', () {
    testWidgets('displays correct item count', (WidgetTester tester) async {
      final Cart cart = Cart();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              body: CartBadge(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });
  });

  group('SandwichShopAppBar', () {
    testWidgets('renders title and cart badge by default', (WidgetTester tester) async {
      final Cart cart = Cart();
      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(
            home: Scaffold(
              appBar: SandwichShopAppBar(title: 'Test Title'),
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.byType(CartBadge), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
