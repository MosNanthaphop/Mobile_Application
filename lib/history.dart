import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversionHistory {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double convertedAmount;
  final DateTime timestamp;

  ConversionHistory({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedAmount,
    required this.timestamp,
  });
}

class ConversionHistoryPage extends StatefulWidget {
  final List<ConversionHistory> history;

  const ConversionHistoryPage({super.key, required this.history});

  @override
  // ignore: library_private_types_in_public_api
  _ConversionHistoryPageState createState() => _ConversionHistoryPageState();
}

class _ConversionHistoryPageState extends State<ConversionHistoryPage> {
  List<ConversionHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _history = widget.history;
  }

  // ฟังก์ชันลบประวัติแต่ละรายการ
  void _deleteHistoryItem(int index) {
    setState(() {
      _history.removeAt(index);
    });
  }

  // ฟังก์ชันล้างประวัติทั้งหมด
  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 191, 89, 43), // เปลี่ยนสีพื้นหลังเป็นสีแดง
        title: const Text(
          'Conversion History',
          style: TextStyle(
            color: Colors.white, // เปลี่ยนสีตัวหนังสือเป็นสีขาว
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          // ปุ่มล้างประวัติ
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white,),
            onPressed: _history.isNotEmpty
                ? () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm'),
                        content: const Text('Are you sure you want to clear all history?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _clearHistory();
                              Navigator.pop(context);
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  }
                : null, // ปิดการใช้งานถ้าไม่มีประวัติ
          )
        ],
      ),
      //เพิ่มสีพื้นหลัง
      //backgroundColor: Colors.lightBlue[50],
      body: Container(
      // ตั้งค่ารูปภาพพื้นหลัง
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg11.png'),
          fit: BoxFit.cover, // ปรับให้เต็มหน้าจอ
        ),
      ),
        child : Padding(
          padding: const EdgeInsets.all(8.0),
          child: _history.isNotEmpty
              ? ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    // จัดรูปแบบวันที่และเวลาให้เข้าใจง่าย
                    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(item.timestamp);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          'From: ${item.fromCurrency} To: ${item.toCurrency}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Amount: ${item.amount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Converted: ${item.convertedAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Date: $formattedDate',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text('Are you sure you want to delete this item?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteHistoryItem(index);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'No history available.',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}