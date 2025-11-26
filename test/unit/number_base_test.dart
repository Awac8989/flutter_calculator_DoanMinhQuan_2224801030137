// test/unit/number_base_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/number_base.dart';

void main() {
  group('NumberBase', () {
    group('Extension Methods', () {
      test('should provide correct display names', () {
        expect(NumberBase.binary.displayName, equals('BIN'));
        expect(NumberBase.octal.displayName, equals('OCT'));
        expect(NumberBase.decimal.displayName, equals('DEC'));
        expect(NumberBase.hexadecimal.displayName, equals('HEX'));
      });

      test('should provide correct radix values', () {
        expect(NumberBase.binary.radix, equals(2));
        expect(NumberBase.octal.radix, equals(8));
        expect(NumberBase.decimal.radix, equals(10));
        expect(NumberBase.hexadecimal.radix, equals(16));
      });

      test('should provide correct prefixes', () {
        expect(NumberBase.binary.prefix, equals('0b'));
        expect(NumberBase.octal.prefix, equals('0o'));
        expect(NumberBase.decimal.prefix, equals(''));
        expect(NumberBase.hexadecimal.prefix, equals('0x'));
      });
    });
  });

  group('NumberBaseConverter', () {
    group('Base Conversion', () {
      test('should convert decimal to binary', () {
        expect(NumberBaseConverter.convertToBase(10, NumberBase.binary), equals('1010'));
        expect(NumberBaseConverter.convertToBase(15, NumberBase.binary), equals('1111'));
        expect(NumberBaseConverter.convertToBase(0, NumberBase.binary), equals('0'));
      });

      test('should convert decimal to octal', () {
        expect(NumberBaseConverter.convertToBase(8, NumberBase.octal), equals('10'));
        expect(NumberBaseConverter.convertToBase(15, NumberBase.octal), equals('17'));
        expect(NumberBaseConverter.convertToBase(64, NumberBase.octal), equals('100'));
      });

      test('should convert decimal to hexadecimal', () {
        expect(NumberBaseConverter.convertToBase(15, NumberBase.hexadecimal), equals('F'));
        expect(NumberBaseConverter.convertToBase(16, NumberBase.hexadecimal), equals('10'));
        expect(NumberBaseConverter.convertToBase(255, NumberBase.hexadecimal), equals('FF'));
      });

      test('should keep decimal numbers as decimal', () {
        expect(NumberBaseConverter.convertToBase(123, NumberBase.decimal), equals('123'));
        expect(NumberBaseConverter.convertToBase(0, NumberBase.decimal), equals('0'));
      });

      test('should handle negative numbers', () {
        // For negative numbers, should use two's complement representation
        expect(NumberBaseConverter.convertToBase(-1, NumberBase.binary), isNotEmpty);
        expect(NumberBaseConverter.convertToBase(-1, NumberBase.hexadecimal), isNotEmpty);
        expect(NumberBaseConverter.convertToBase(-5, NumberBase.decimal), equals('-5'));
      });
    });

    group('Base Parsing', () {
      test('should parse binary strings', () {
        expect(NumberBaseConverter.convertFromBase('1010', NumberBase.binary), equals(10));
        expect(NumberBaseConverter.convertFromBase('1111', NumberBase.binary), equals(15));
        expect(NumberBaseConverter.convertFromBase('0', NumberBase.binary), equals(0));
      });

      test('should parse octal strings', () {
        expect(NumberBaseConverter.convertFromBase('10', NumberBase.octal), equals(8));
        expect(NumberBaseConverter.convertFromBase('17', NumberBase.octal), equals(15));
        expect(NumberBaseConverter.convertFromBase('100', NumberBase.octal), equals(64));
      });

      test('should parse hexadecimal strings', () {
        expect(NumberBaseConverter.convertFromBase('F', NumberBase.hexadecimal), equals(15));
        expect(NumberBaseConverter.convertFromBase('10', NumberBase.hexadecimal), equals(16));
        expect(NumberBaseConverter.convertFromBase('FF', NumberBase.hexadecimal), equals(255));
        expect(NumberBaseConverter.convertFromBase('f', NumberBase.hexadecimal), equals(15)); // lowercase
      });

      test('should parse decimal strings', () {
        expect(NumberBaseConverter.convertFromBase('123', NumberBase.decimal), equals(123));
        expect(NumberBaseConverter.convertFromBase('0', NumberBase.decimal), equals(0));
      });

      test('should handle prefixed strings', () {
        expect(NumberBaseConverter.convertFromBase('0b1010', NumberBase.binary), equals(10));
        expect(NumberBaseConverter.convertFromBase('0o17', NumberBase.octal), equals(15));
        expect(NumberBaseConverter.convertFromBase('0xFF', NumberBase.hexadecimal), equals(255));
      });
    });

    group('All Base Conversion', () {
      test('should convert to all bases correctly', () {
        final result = NumberBaseConverter.convertToAllBases(15);
        
        expect(result[NumberBase.binary], equals('1111'));
        expect(result[NumberBase.octal], equals('17'));
        expect(result[NumberBase.decimal], equals('15'));
        expect(result[NumberBase.hexadecimal], equals('F'));
      });

      test('should handle zero in all bases', () {
        final result = NumberBaseConverter.convertToAllBases(0);
        
        expect(result[NumberBase.binary], equals('0'));
        expect(result[NumberBase.octal], equals('0'));
        expect(result[NumberBase.decimal], equals('0'));
        expect(result[NumberBase.hexadecimal], equals('0'));
      });

      test('should handle large numbers', () {
        final result = NumberBaseConverter.convertToAllBases(255);
        
        expect(result[NumberBase.binary], equals('11111111'));
        expect(result[NumberBase.octal], equals('377'));
        expect(result[NumberBase.decimal], equals('255'));
        expect(result[NumberBase.hexadecimal], equals('FF'));
      });
    });

    group('Error Handling', () {
      test('should throw on invalid input for base', () {
        expect(
          () => NumberBaseConverter.convertFromBase('2', NumberBase.binary),
          throwsFormatException
        );
        expect(
          () => NumberBaseConverter.convertFromBase('8', NumberBase.octal),
          throwsFormatException
        );
        expect(
          () => NumberBaseConverter.convertFromBase('G', NumberBase.hexadecimal),
          throwsFormatException
        );
      });

      test('should handle empty strings', () {
        expect(
          () => NumberBaseConverter.convertFromBase('', NumberBase.decimal),
          throwsFormatException
        );
      });
    });

    group('Round Trip Conversion', () {
      test('should maintain value through round trip conversions', () {
        const testValues = [0, 1, 15, 16, 255, 256, 1023, 1024];
        
        for (final value in testValues) {
          for (final base in NumberBase.values) {
            final converted = NumberBaseConverter.convertToBase(value, base);
            final backConverted = NumberBaseConverter.convertFromBase(converted, base);
            expect(backConverted, equals(value), reason: 'Failed for $value in base ${base.displayName}');
          }
        }
      });
    });
  });
}