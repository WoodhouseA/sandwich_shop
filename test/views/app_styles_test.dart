import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/app_styles.dart';

void main() {
  group('AppStyles', () {
    test('loadFontSize loads default when no preference saved', () async {
      SharedPreferences.setMockInitialValues({});
      
      await AppStyles.loadFontSize();
      
      expect(AppStyles.baseFontSize, 16.0);
    });

    test('loadFontSize loads saved value', () async {
      SharedPreferences.setMockInitialValues({'fontSize': 20.0});
      
      await AppStyles.loadFontSize();
      
      expect(AppStyles.baseFontSize, 20.0);
    });

    test('loadFontSize ignores invalid values (too small)', () async {
      SharedPreferences.setMockInitialValues({'fontSize': 5.0});
      
      await AppStyles.loadFontSize();
      
      expect(AppStyles.baseFontSize, 16.0); // Should remain default
    });

    test('loadFontSize ignores invalid values (too large)', () async {
      SharedPreferences.setMockInitialValues({'fontSize': 50.0});
      
      await AppStyles.loadFontSize();
      
      expect(AppStyles.baseFontSize, 16.0); // Should remain default
    });

    test('saveFontSize saves value and updates state', () async {
      SharedPreferences.setMockInitialValues({});
      
      await AppStyles.saveFontSize(22.0);
      
      expect(AppStyles.baseFontSize, 22.0);
      
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('fontSize'), 22.0);
    });

    test('text styles update based on baseFontSize', () async {
      SharedPreferences.setMockInitialValues({});
      await AppStyles.saveFontSize(20.0);
      
      expect(AppStyles.normalText.fontSize, 20.0);
      expect(AppStyles.heading1.fontSize, 28.0); // 20 + 8
      expect(AppStyles.heading2.fontSize, 24.0); // 20 + 4
    });
  });
}
