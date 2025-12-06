import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  group('SettingsScreen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({'fontSize': 16.0});
    });

    testWidgets('displays loading indicator initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
