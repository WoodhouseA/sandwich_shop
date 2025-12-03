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
  });
}
