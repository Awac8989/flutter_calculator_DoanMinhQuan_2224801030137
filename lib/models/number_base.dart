// models/number_base.dart
enum NumberBase {
  binary,
  octal,
  decimal,
  hexadecimal,
}

extension NumberBaseExtension on NumberBase {
  String get displayName {
    switch (this) {
      case NumberBase.binary:
        return 'BIN';
      case NumberBase.octal:
        return 'OCT';
      case NumberBase.decimal:
        return 'DEC';
      case NumberBase.hexadecimal:
        return 'HEX';
    }
  }

  int get radix {
    switch (this) {
      case NumberBase.binary:
        return 2;
      case NumberBase.octal:
        return 8;
      case NumberBase.decimal:
        return 10;
      case NumberBase.hexadecimal:
        return 16;
    }
  }

  String get prefix {
    switch (this) {
      case NumberBase.binary:
        return '0b';
      case NumberBase.octal:
        return '0o';
      case NumberBase.decimal:
        return '';
      case NumberBase.hexadecimal:
        return '0x';
    }
  }
}

class NumberBaseConverter {
  static String convertToBase(int value, NumberBase base) {
    if (value < 0) {
      // Handle negative numbers with two's complement for non-decimal bases
      if (base != NumberBase.decimal) {
        const int bitWidth = 32; // 32-bit integers
        value = (1 << bitWidth) + value;
      }
    }

    switch (base) {
      case NumberBase.binary:
        return value.toRadixString(2);
      case NumberBase.octal:
        return value.toRadixString(8);
      case NumberBase.decimal:
        return value.toString();
      case NumberBase.hexadecimal:
        return value.toRadixString(16).toUpperCase();
    }
  }

  static int convertFromBase(String value, NumberBase base) {
    // Remove prefix if present
    String cleanValue = value.toLowerCase();
    switch (base) {
      case NumberBase.binary:
        cleanValue = cleanValue.replaceFirst('0b', '');
        break;
      case NumberBase.octal:
        cleanValue = cleanValue.replaceFirst('0o', '');
        break;
      case NumberBase.hexadecimal:
        cleanValue = cleanValue.replaceFirst('0x', '');
        break;
      case NumberBase.decimal:
        break;
    }

    return int.parse(cleanValue, radix: base.radix);
  }

  static Map<NumberBase, String> convertToAllBases(int value) {
    return {
      for (NumberBase base in NumberBase.values)
        base: convertToBase(value, base)
    };
  }
}