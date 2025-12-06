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

    testWidgets('displays all UI elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.text('Current size: 16px'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('This is sample text to preview the font size.'), findsOneWidget);
      expect(find.text('Back to Order'), findsOneWidget);
    });

    testWidgets('slider updates font size', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Current size: 16px'), findsOneWidget);
      expect(AppStyles.baseFontSize, 16.0);

      final Finder sliderFinder = find.byType(Slider);
      await tester.drag(sliderFinder, const Offset(50, 0));
      await tester.pumpAndSettle();
      
      expect(AppStyles.baseFontSize, isNot(16.0));
    });
  });
}
