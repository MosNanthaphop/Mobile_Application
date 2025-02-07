import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_btn/loading_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'history.dart';
import 'setting.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'l10n/l10n.dart';

void main() {
  runApp(const CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  const CurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'THB';
  double _convertedAmount = 0.0;

  final List<ConversionHistory> _conversionHistory = [];
  final List<String> _currencies = ['USD', 'THB', 'EUR', 'JPY', 'GBP', 'CNY', 'AUD', 'KRW'];
  /* สกุลเงินที่ใช้
    //USD ดอลลาร์สหรัฐ
    //THB บาทไทย
    //EUR ยูโร
    //JPY เยนญี่ปุ่น
    //GBP ปอนด์อังกฤษ
    //CNY หยวนจีน
    //AUD ดอลลาร์ออสเตรเลีย
    //KRW วอนเกาหลี
  */

  // รายการประวัติการแปลง
  @override
  void initState() {
    super.initState();
    _loadDefaultCurrencies();  // โหลดค่าจาก SharedPreferences
  }

  // ฟังก์ชันดึงค่าจาก SharedPreferences
  Future<void> _loadDefaultCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fromCurrency = prefs.getString('defaultFromCurrency') ?? 'USD';
      _toCurrency = prefs.getString('defaultToCurrency') ?? 'THB';
    });
  }

  bool validateAmount() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return false;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount greater than 0')),
      );
      return false;
    }

    return true;
  }

  Future<void> _convertCurrency() async {
    if (!validateAmount()) return; //Check Amount

    try {
      String apiKey = 'a3b6b0c13f191474740a160a';
      String apiUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/$_fromCurrency';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        double rate = data['conversion_rates'][_toCurrency];

        // บันทึกการแปลงในประวัติ
        double amount = double.parse(_amountController.text);
        setState(() {
          _convertedAmount = double.parse((amount * rate).toStringAsFixed(2)); // ปัดเป็นทศนิยม 2 ตำแหน่ง
          _conversionHistory.add(ConversionHistory(
            amount: amount,
            fromCurrency: _fromCurrency,
            toCurrency: _toCurrency,
            convertedAmount: _convertedAmount,
            timestamp: DateTime.now(),
          ));
        });

        // ตรวจสอบว่าตัววิดเจ็ตยังอยู่ในต้นไม้
        if (!mounted) return;
      } else {
        throw Exception('Failed to load exchange rate');
      }
    } catch (e) {
      // ตรวจสอบว่าตัววิดเจ็ตยังอยู่ในต้นไม้
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot connect to server: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 191, 89, 43),
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversionHistoryPage(history: _conversionHistory),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ).then((value) {
                // เมื่อผู้ใช้กลับมาจากหน้า Settings ให้โหลดค่าที่อัปเดต
                _loadDefaultCurrencies();
              });
            },
          ),
        ],
      ),
      // เพิ่มสีพื้นหลังที่นี่
      //backgroundColor: Colors.lightBlue[50], // เปลี่ยนเป็นสีที่ต้องการ
      body: Container(
      // ตั้งค่ารูปภาพพื้นหลัง
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg11.png'),
          fit: BoxFit.cover, // ปรับให้เต็มหน้าจอ
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card สำหรับ Input Amount และ Dropdowns
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.blue[50],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: _fromCurrency,
                            onChanged: (value) {
                              setState(() {
                                _fromCurrency = value!;
                              });
                            },
                            items: _currencies.map<DropdownMenuItem<String>>((currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                          ),
                          const Spacer(),
                          const Text('to'),
                          const Spacer(),
                          DropdownButton<String>(
                            value: _toCurrency,
                            onChanged: (value) {
                              setState(() {
                                _toCurrency = value!;
                              });
                            },
                            items: _currencies.map<DropdownMenuItem<String>>((currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // ปุ่ม Convert อยู่แยกออกมาข้างล่าง
              LoadingBtn(
                height: 50,
                borderRadius: 30,
                animate: true,
                color: const Color.fromARGB(255, 255, 255, 255),
                width: MediaQuery.of(context).size.width * 0.45,
                loader: Container(
                  padding: const EdgeInsets.all(10),
                  width: 40,
                  height: 40,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 191, 89, 43)),
                  ),
                ),
                onTap: ((startLoading, stopLoading, btnState) async {
                  if (btnState == ButtonState.idle) {
                    startLoading();
                    await Future.delayed(const Duration(seconds: 1));
                    await _convertCurrency();
                    stopLoading();
                  }
                }),
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    color: Color.fromARGB(255, 191, 89, 43),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // แสดงผลการแปลง
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: _convertedAmount != 0
                          ? 'Converted Amount: '
                          : 'Enter amount and convert',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    TextSpan(
                      text: _convertedAmount != 0
                          ? ' ${_convertedAmount.toStringAsFixed(2)}'
                          : '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                    TextSpan(
                      text: _convertedAmount != 0
                          ? ' $_toCurrency'
                          : '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
