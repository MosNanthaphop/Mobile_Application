import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xchango/setting.dart'; // แก้ไข path ตามโปรเจกต์ของคุณ

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsPage Widget Tests', () {
    setUp(() async {
      // Mock ข้อมูลใน SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('ทดสอบการแสดงผลค่า Default Currencies', (WidgetTester tester) async {
      // ใส่หน้า SettingsPage ลงใน widget tree
      await tester.pumpWidget(const MaterialApp(
        home: SettingsPage(),
      ));

      // ตรวจสอบว่ามี dropdown สำหรับ Default From Currency
      expect(find.text('From:'), findsOneWidget);
      expect(find.text('USD'), findsOneWidget);

      // ตรวจสอบว่ามี dropdown สำหรับ Default To Currency
      expect(find.text('To:'), findsOneWidget);
      expect(find.text('THB'), findsOneWidget);
    });

    testWidgets('ทดสอบการเปลี่ยนค่า Default From Currency', (WidgetTester tester) async {
      // ใส่หน้า SettingsPage ลงใน widget tree
      await tester.pumpWidget(const MaterialApp(
        home: SettingsPage(),
      ));

      // กด Dropdown "From:" และเลือกค่าใหม่
      await tester.tap(find.text('USD'));
      await tester.pumpAndSettle(); // รอให้ dropdown แสดงรายการทั้งหมด

      // เลือกค่าใหม่เป็น 'EUR'
      await tester.tap(find.text('EUR').last);
      await tester.pumpAndSettle();

      // ตรวจสอบว่าค่าเปลี่ยนเป็น 'EUR'
      expect(find.text('EUR'), findsOneWidget);
    });

    testWidgets('ทดสอบการบันทึกการตั้งค่าเมื่อคลิกปุ่ม Save Settings', (WidgetTester tester) async {
      // Mock ข้อมูลใน SharedPreferences
      SharedPreferences.setMockInitialValues({
        'defaultFromCurrency': 'USD',
        'defaultToCurrency': 'THB',
      });

      await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

      // ให้ UI อัพเดทข้อมูล
      await tester.pumpAndSettle();

      // เลือกค่าใหม่สำหรับ Default Currencies
      await tester.tap(find.text('USD')); // กดปุ่ม Dropdown "From:"
      await tester.pumpAndSettle(); // รอให้ Dropdown แสดงผล

      // เลือกค่าใหม่ 'EUR' สำหรับ Default From Currency
      await tester.tap(find.text('EUR').last);
      await tester.pumpAndSettle();

      // กดปุ่ม Save Settings
      await tester.tap(find.text('Save Settings'));
      await tester.pump(); // ให้แน่ใจว่า SnackBar ถูกแสดงขึ้น

      // รอให้ SnackBar แสดงผล
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // ตรวจสอบค่าใน SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('defaultFromCurrency'), 'EUR'); // ต้องตรงกับค่าที่เลือกใหม่
      expect(prefs.getString('defaultToCurrency'), 'THB'); // ค่าที่เลือกยังคงเป็น 'THB'
    });
  });
}
