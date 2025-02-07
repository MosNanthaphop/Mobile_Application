class ValidationService {
  static String? validateAmount(String? value, String amount) {
    if (value!.isEmpty) {
      return 'Please enter an $amount';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null || doubleValue <= 0) {
      return 'Please enter a valid $amount greater than 0';
    }
    return null;
  }
}