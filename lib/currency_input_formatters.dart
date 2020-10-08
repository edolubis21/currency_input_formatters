library currency_input_formatters;

import 'package:flutter/services.dart';

class CurrencyFormatter extends TextInputFormatter {
  CurrencyFormatter({this.decimal = 0, this.maxLength = 21});
  int decimal;
  String currentText;
  num currentNumber;
  String decimalValue = '';
  final int maxLength;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == "") {
      currentNumber = 0;
      currentText = '';
      return newValue;
    }
    final oldValueValid = _isValid(_getCleanNumber(oldValue.text).replaceAll(".", ""));
    final newValueValid = _isValid(_getCleanNumber(newValue.text).replaceAll(".", ""));
    if (oldValueValid && !newValueValid ||
        newValue.text.length >= maxLength ||
        !_isDecimalValid(_getCleanNumber(newValue.text).replaceAll(".", ""))) {
      return oldValue;
    }
    currentNumber = _getValueNumber(_getCleanNumber(newValue.text));
    final String newText = _getFormatted(currentNumber, _getCleanNumber(newValue.text));
    currentText = newText;
    final selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
    final cursorPosition = newText.length - selectionIndexFromTheRight;
    return TextEditingValue(text: newText, selection: TextSelection.fromPosition(TextPosition(offset: cursorPosition)));
  }

  num _getValueNumber(String oldValue) {
    if (oldValue == '' || oldValue == null) {
      return 0;
    }
    return num.parse(oldValue.replaceAll('.', '').replaceAll(',', '.'));
  }

  String _getFormatted(num amount, String currentText) {
    try {
      var numberString = amount % 1 == 0 ? amount.toInt().toString() : amount.toString(),
          split = numberString.split('.'),
          sisa = split[0].length % 3,
          rupiah = split[0].substring(0, sisa),
          ribuan = RegexCurrency.getInstance.regExp.allMatches(split[0].substring(sisa)).map((e) => e.group(0));
      if (ribuan != null && ribuan.isNotEmpty) {
        String separator = sisa != null && sisa > 0 ? '.' : '';
        rupiah += separator + ribuan.join('.');
      }
      if (currentText.contains(',')) {
        rupiah = split.length > 1 ? rupiah + ',' + split[1] : rupiah + ',' + decimalValue;
      } else {
        rupiah = split.length > 1 ? rupiah + ',' + split[1] : rupiah;
      }
      return rupiah;
    } catch (e) {
      print(e);
      return "";
    }
  }

  String _getCleanNumber(String number) {
    if (number != null && number.length > 0 && (number.endsWith('.') || number.endsWith(','))) {
      return number.substring(0, number.length - 1) + ",";
    }
    return number;
  }

  bool _isDecimalValid(String value) {
    if (value.contains(',')) {
      List newList = value.split(',');
      decimalValue = newList.length > 0 ? newList[1] : "";
      if (newList.length > 0 && value.split(',')[1].length > decimal) {
        return false;
      }
    }
    return true;
  }

  bool _isValid(String value) {
    try {
      RegExp regex;
      if (decimal != 0) {
        regex = RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\,[0-9]{0,})?\$');
      } else {
        regex = RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\[0-9]{0,})?\$');
      }
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      assert(false, e.toString());
      return true;
    }
  }
}

class RegexCurrency {
  RegExp regExp;
  static RegexCurrency _instance;
  RegexCurrency._() {
    regExp = new RegExp(
      r"\d{1,3}",
      caseSensitive: false,
      multiLine: false,
    );
  }
  static RegexCurrency get getInstance => _instance = _instance ?? RegexCurrency._();
}
