import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'l10n/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _defaultFromCurrency = 'USD';
  String _defaultToCurrency = 'THB';
  //bool _isDarkMode = false;
  //String _selectedLanguage = 'English';

  final List<String> _currencies = ['USD', 'THB', 'EUR', 'JPY', 'GBP', 'CNY', 'AUD', 'KRW'];
  //final List<String> _languages = ['English', 'Thailand'];
  /*final List<String> _languageFlags = [
    'assets/images/usa_flag.png', // ธงสำหรับภาษาอังกฤษ
    'assets/images/thai_flag.png', // ธงสำหรับภาษาไทย
  ];*/

  @override
  void initState() {
    super.initState();
    _loadDefaultCurrencies();
  }

  // ฟังก์ชันโหลดค่าที่บันทึกไว้จาก SharedPreferences
  Future<void> _loadDefaultCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultFromCurrency = prefs.getString('defaultFromCurrency') ?? 'USD';
      _defaultToCurrency = prefs.getString('defaultToCurrency') ?? 'THB';
    });
  }

  // ฟังก์ชันบันทึกค่าลง SharedPreferences
  // ignore: unused_element
  Future<void> _saveDefaultCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultFromCurrency', _defaultFromCurrency);
    await prefs.setString('defaultToCurrency', _defaultToCurrency);
    // แสดง SnackBar
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default currencies saved')),
    );
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white, // เปลี่ยนสีตัวหนังสือเป็นสีขาว
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 191, 89, 43),
      ),
      // เพิ่มสีพื้นหลัง
      //backgroundColor: Colors.lightBlue[50],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg11.png'),
            fit: BoxFit.cover, // ปรับให้เต็มหน้าจอ
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Default Currencies section wrapped in a Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Default Currencies',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'From:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _defaultFromCurrency,
                            onChanged: (value) {
                              setState(() {
                                _defaultFromCurrency = value!;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            items: _currencies.map<DropdownMenuItem<String>>((currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'To:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _defaultToCurrency,
                            onChanged: (value) {
                              setState(() {
                                _defaultToCurrency = value!;
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            items: _currencies.map<DropdownMenuItem<String>>((currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            const SizedBox(height: 32),

            // ปุ่ม Save Settings
            Center(
              child: ElevatedButton(
                onPressed: () async {  // เปลี่ยนเป็น asynchronous
                  await _saveDefaultCurrencies();   // ฟังก์ชันการบันทึกการตั้งค่า
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                ),
                child: const Text(
                  'Save Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 191, 89, 43),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
