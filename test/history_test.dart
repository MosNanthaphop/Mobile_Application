import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xchango/history.dart'; // นำเข้าไฟล์ history.dart

void main() {
  group('History Tests', () {
    // ข้อมูลตัวอย่างสำหรับทดสอบ
    // Mock ประวัติการแปลงสกุลเงิน
    final mockHistory = [
      ConversionHistory(
        amount: 100.0,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        convertedAmount: 85.0,
        timestamp: DateTime.now(),
      ),
      ConversionHistory(
        amount: 200.0,
        fromCurrency: 'GBP',
        toCurrency: 'JPY',
        convertedAmount: 30000.0,
        timestamp: DateTime.now(),
      ),
    ];


    testWidgets('แสดงผลรายการประวัติอย่างถูกต้อง', (WidgetTester tester) async {
      // สร้างหน้า ConversionHistoryPage พร้อมข้อมูล mock
      await tester.pumpWidget(MaterialApp(
        home: ConversionHistoryPage(history: mockHistory),
      ));

      // ตรวจสอบว่ามีรายการประวัติแสดงอยู่
      expect(find.text('From: USD To: EUR'), findsOneWidget);
      expect(find.text('From: GBP To: JPY'), findsOneWidget);
    });
    testWidgets('ลบรายการประวัติเมื่อกดปุ่มลบ', (WidgetTester tester) async {
      // ใส่หน้า ConversionHistoryPage ลงใน widget tree
      await tester.pumpWidget(MaterialApp(
        home: ConversionHistoryPage(history: mockHistory),
      ));

      // ตรวจสอบว่ามีรายการอยู่
      expect(find.text('From: USD To: EUR'), findsOneWidget);

      // กดปุ่มลบรายการแรก (ไอคอนลบสีแดงใน ListTile)
      await tester.tap(find.widgetWithIcon(ListTile, Icons.remove_circle).first);
      
      // บังคับให้ Flutter แสดง Dialog
      await tester.pump();
    });


    testWidgets('ล้างประวัติทั้งหมดเมื่อกดปุ่มลบทั้งหมด', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ConversionHistoryPage(history: mockHistory),
      ));

      // ตรวจสอบว่ามีรายการประวัติอยู่
      expect(find.text('From: USD To: EUR'), findsOneWidget);
      expect(find.text('From: GBP To: JPY'), findsOneWidget);

      // กดปุ่มล้างประวัติ (ไอคอนถังขยะบน AppBar)
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle(); // รอให้ Dialog แสดง

      // ยืนยันการล้างประวัติ
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle(); // รอให้ประวัติถูกล้าง

      // ตรวจสอบว่าประวัติทั้งหมดถูกล้าง
      expect(find.text('No history available.'), findsOneWidget);
      expect(find.text('From: USD To: EUR'), findsNothing);
      expect(find.text('From: GBP To: JPY'), findsNothing);
    });
  });
}
