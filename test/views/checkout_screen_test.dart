import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

void main() {
  group('CheckoutScreen', () {
    late Cart cart;
    late Sandwich sandwich1;
    late Sandwich sandwich2;

    setUp(() {
      cart = Cart();
      sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );
    });

    testWidgets('displays order summary correctly', (WidgetTester tester) async {
      // Arrange
      cart.add(sandwich1, quantity: 2); // 2 * 7.00 = 14.00
      cart.add(sandwich2, quantity: 1); // 1 * 11.00 = 11.00
      // Total = 25.00

      await tester.pumpWidget(MaterialApp(
        home: CheckoutScreen(cart: cart),
      ));

      // Assert
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('2x Veggie Delight'), findsOneWidget);
      expect(find.text('£14.00'), findsOneWidget);
      expect(find.text('1x Chicken Teriyaki'), findsOneWidget);
      expect(find.text('£11.00'), findsOneWidget);
      expect(find.text('Total:'), findsOneWidget);
      expect(find.text('£25.00'), findsOneWidget);
      expect(find.text('Payment Method: Card ending in 1234'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsOneWidget);
    });

    testWidgets('shows loading state when payment is confirmed',
        (WidgetTester tester) async {
      // Arrange
      cart.add(sandwich1);
      await tester.pumpWidget(MaterialApp(
        home: CheckoutScreen(cart: cart),
      ));

      // Act
      await tester.tap(find.text('Confirm Payment'));
      await tester.pump(); // Start the animation/state change

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing payment...'), findsOneWidget);
      expect(find.text('Confirm Payment'), findsNothing);

      // Finish the timer to avoid pending timer exception
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('navigates back with order confirmation after processing',
        (WidgetTester tester) async {
      // Arrange
      cart.add(sandwich1);
      Map? returnedResult;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              returnedResult = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(cart: cart),
                ),
              );
            },
            child: const Text('Go to Checkout'),
          ),
        ),
      ));

      // Navigate to checkout
      await tester.tap(find.text('Go to Checkout'));
      await tester.pumpAndSettle();

      // Act - Confirm Payment
      await tester.tap(find.text('Confirm Payment'));
      await tester.pump(); // Rebuild to show loading

      // Wait for the 2-second delay
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(); // Handle navigation animation

      // Assert
      expect(find.text('Go to Checkout'), findsOneWidget); // Should be back at home
      expect(returnedResult, isNotNull);
      expect(returnedResult!['totalAmount'], equals(7.00));
      expect(returnedResult!['itemCount'], equals(1));
      expect(returnedResult!['orderId'], isNotNull);
    });
  });
}
