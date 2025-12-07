import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/views/order_history_screen.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('OrderHistoryScreen', () {
    setUpAll(() {
      initializeTestDatabase();
    });

    testWidgets('displays loading indicator initially',
        (WidgetTester tester) async {
      const OrderHistoryScreen orderHistoryScreen = OrderHistoryScreen();
      const MaterialApp app = MaterialApp(home: orderHistoryScreen);

      await tester.pumpWidget(app);

<<<<<<< HEAD
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Order History')), findsOneWidget);
=======
      expect(find.text('Order History'), findsOneWidget);
>>>>>>> 899750d192265fe0882eb84e662eb4cfc95e5da4
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      testCommonAppBarLogo(tester);
      testBasicScaffoldStructure(tester);
    });
  });
}
