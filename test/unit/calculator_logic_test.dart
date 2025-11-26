// test/unit/calculator_logic_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../../lib/utils/calculator_logic.dart';
import '../../lib/models/calculator_settings.dart';

void main() {
  group('CalculatorLogic', () {
    group('Basic Arithmetic', () {
      test('should perform addition correctly', () {
        expect(CalculatorLogic.add(2.0, 3.0), equals(5.0));
        expect(CalculatorLogic.add(-1.0, 1.0), equals(0.0));
        expect(CalculatorLogic.add(0.1, 0.2), closeTo(0.3, 1e-10));
      });

      test('should perform subtraction correctly', () {
        expect(CalculatorLogic.subtract(5.0, 3.0), equals(2.0));
        expect(CalculatorLogic.subtract(1.0, 1.0), equals(0.0));
        expect(CalculatorLogic.subtract(-5.0, -3.0), equals(-2.0));
      });

      test('should perform multiplication correctly', () {
        expect(CalculatorLogic.multiply(4.0, 3.0), equals(12.0));
        expect(CalculatorLogic.multiply(-2.0, 3.0), equals(-6.0));
        expect(CalculatorLogic.multiply(0.0, 100.0), equals(0.0));
      });

      test('should perform division correctly', () {
        expect(CalculatorLogic.divide(8.0, 2.0), equals(4.0));
        expect(CalculatorLogic.divide(1.0, 3.0), closeTo(0.333333, 1e-5));
        expect(() => CalculatorLogic.divide(5.0, 0.0), throwsException);
      });
    });

    group('Scientific Functions', () {
      test('should calculate trigonometric functions in radians', () {
        expect(
          CalculatorLogic.sine(0.0, AngleMode.radians),
          closeTo(0.0, 1e-10)
        );
        expect(
          CalculatorLogic.cosine(0.0, AngleMode.radians),
          closeTo(1.0, 1e-10)
        );
        expect(
          CalculatorLogic.tangent(0.0, AngleMode.radians),
          closeTo(0.0, 1e-10)
        );
      });

      test('should calculate trigonometric functions in degrees', () {
        expect(
          CalculatorLogic.sine(30.0, AngleMode.degrees),
          closeTo(0.5, 1e-10)
        );
        expect(
          CalculatorLogic.cosine(60.0, AngleMode.degrees),
          closeTo(0.5, 1e-10)
        );
        expect(
          CalculatorLogic.tangent(45.0, AngleMode.degrees),
          closeTo(1.0, 1e-10)
        );
      });

      test('should calculate inverse trigonometric functions', () {
        expect(
          CalculatorLogic.arcsine(0.5, AngleMode.degrees),
          closeTo(30.0, 1e-10)
        );
        expect(
          CalculatorLogic.arccosine(0.5, AngleMode.degrees),
          closeTo(60.0, 1e-10)
        );
        expect(
          CalculatorLogic.arctangent(1.0, AngleMode.degrees),
          closeTo(45.0, 1e-10)
        );
      });

      test('should calculate logarithmic functions', () {
        expect(CalculatorLogic.naturalLog(1.0), closeTo(0.0, 1e-10));
        expect(CalculatorLogic.logBase10(10.0), closeTo(1.0, 1e-10));
        expect(CalculatorLogic.logBase2(8.0), closeTo(3.0, 1e-10));
        expect(() => CalculatorLogic.naturalLog(-1.0), throwsException);
      });

      test('should calculate power functions', () {
        expect(CalculatorLogic.power(2.0, 3.0), equals(8.0));
        expect(CalculatorLogic.squareRoot(16.0), equals(4.0));
        expect(CalculatorLogic.cubeRoot(27.0), closeTo(3.0, 1e-10));
        expect(() => CalculatorLogic.squareRoot(-4.0), throwsException);
      });

      test('should calculate factorial', () {
        expect(CalculatorLogic.factorial(5.0), equals(120.0));
        expect(CalculatorLogic.factorial(0.0), equals(1.0));
        expect(() => CalculatorLogic.factorial(-1.0), throwsException);
        expect(() => CalculatorLogic.factorial(1.5), throwsException);
      });
    });

    group('Constants', () {
      test('should provide mathematical constants', () {
        expect(CalculatorLogic.pi, closeTo(3.14159265359, 1e-10));
        expect(CalculatorLogic.e, closeTo(2.71828182846, 1e-10));
      });
    });

    group('Number Formatting', () {
      test('should format integers correctly', () {
        expect(CalculatorLogic.formatNumber(5.0, 2), equals('5'));
        expect(CalculatorLogic.formatNumber(123.0, 2), equals('123'));
      });

      test('should format decimals correctly', () {
        expect(CalculatorLogic.formatNumber(3.14, 2), equals('3.14'));
        expect(CalculatorLogic.formatNumber(3.10, 2), equals('3.1'));
        expect(CalculatorLogic.formatNumber(3.00, 2), equals('3'));
      });

      test('should handle special values', () {
        expect(
          CalculatorLogic.formatNumber(double.infinity, 2),
          equals('Infinity')
        );
        expect(
          CalculatorLogic.formatNumber(double.nan, 2),
          equals('NaN')
        );
      });
    });

    group('Validation', () {
      test('should validate results correctly', () {
        expect(CalculatorLogic.isValidResult(5.0), isTrue);
        expect(CalculatorLogic.isValidResult(0.0), isTrue);
        expect(CalculatorLogic.isValidResult(-3.14), isTrue);
        expect(CalculatorLogic.isValidResult(double.infinity), isFalse);
        expect(CalculatorLogic.isValidResult(double.nan), isFalse);
      });
    });

    group('Angle Conversion', () {
      test('should convert degrees to radians', () {
        expect(
          CalculatorLogic.degToRad(180.0),
          closeTo(3.14159265359, 1e-10)
        );
        expect(CalculatorLogic.degToRad(90.0), closeTo(1.5707963268, 1e-10));
      });

      test('should convert radians to degrees', () {
        expect(
          CalculatorLogic.radToDeg(3.14159265359),
          closeTo(180.0, 1e-10)
        );
        expect(CalculatorLogic.radToDeg(1.5707963268), closeTo(90.0, 1e-10));
      });
    });

    group('Memory Operations', () {
      test('should perform memory operations', () {
        expect(CalculatorLogic.memoryAdd(5.0, 3.0), equals(8.0));
        expect(CalculatorLogic.memorySubtract(5.0, 3.0), equals(2.0));
      });
    });

    group('Programmer Mode Functions', () {
      test('should perform bitwise operations', () {
        expect(CalculatorLogic.bitwiseAnd(5, 3), equals(1)); // 101 & 011 = 001
        expect(CalculatorLogic.bitwiseOr(5, 3), equals(7)); // 101 | 011 = 111
        expect(CalculatorLogic.bitwiseXor(5, 3), equals(6)); // 101 ^ 011 = 110
        expect(CalculatorLogic.bitwiseNot(5), equals(-6)); // ~101 = ...11111010
      });

      test('should perform shift operations', () {
        expect(CalculatorLogic.leftShift(5, 1), equals(10)); // 101 << 1 = 1010
        expect(CalculatorLogic.rightShift(10, 1), equals(5)); // 1010 >> 1 = 101
      });
    });
  });
}