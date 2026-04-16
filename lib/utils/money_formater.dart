import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MoneyFormater extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Parse the value and round it to the nearest whole number
    int value = int.tryParse(newText) ?? 0;
    value = (value / 100).round();

    // Format the rounded value back into currency format
    String formattedText = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0)
        .format(value);

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
