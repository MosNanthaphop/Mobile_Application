import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xchango/main.dart'; // เปลี่ยนเป็นชื่อโปรเจกต์ของคุณ
import 'package:xchango/service/validation_service.dart'; // นำเข้า LoadingBtn (ถ้ามีการใช้งาน)

void main() {
  group('Currency Converter App Tests', () {
    test('การกรอกจำนวนเงิน', () {
      expect(ValidationService.validateAmount('9.99', 'amount'), null);
    });

    testWidgets('แสดงผล CurrencyConverterApp พร้อมหน้าแรก', (WidgetTester tester) async {
      await tester.pumpWidget(const CurrencyConverterApp());

      // ตรวจสอบว่าแอปมีชื่อ 'Currency Converter'
      expect(find.text('Currency Converter'), findsOneWidget);

      // ตรวจสอบว่าหน้าแรกแสดงอยู่
      expect(find.byType(CurrencyConverterPage), findsOneWidget);
    });

    testWidgets('ทดสอบปุ่ม History', (WidgetTester tester) async {
      await tester.pumpWidget(const CurrencyConverterApp());

      // ตรวจสอบว่าปุ่ม History มีอยู่ในหน้าแรก
      final historyButton = find.byIcon(Icons.history); // เปลี่ยนให้ตรงกับ icon ของปุ่ม History
      expect(historyButton, findsOneWidget);

      // จำลองการแตะที่ปุ่ม History
      await tester.tap(historyButton);
      await tester.pumpAndSettle(); // รอให้การเปลี่ยนแปลง UI เสร็จสิ้น

      // ตรวจสอบว่าหลังจากแตะปุ่ม History จะนำไปยังหน้า History
      expect(find.text('Conversion History'), findsOneWidget); // เปลี่ยนตามชื่อหน้าที่คุณใช้
    });
    testWidgets('ทดสอบปุ่ม Settings', (WidgetTester tester) async {
      // ใส่หน้า main.dart ลงใน widget tree
      await tester.pumpWidget(const MaterialApp(home: CurrencyConverterApp()));

      // ตรวจสอบว่ามีปุ่ม Settings อยู่ในหน้าแรก
      final settingButton = find.byIcon(Icons.settings); // เปลี่ยนให้ตรงกับ icon ของปุ่ม Setting
      expect(settingButton, findsOneWidget);

      // กดปุ่ม Settings
      await tester.tap(settingButton);
      await tester.pumpAndSettle(); // รอให้การนำทางเสร็จสมบูรณ์

      // ตรวจสอบว่าหลังจากแตะปุ่ม History จะนำไปยังหน้า Setting
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
