// test/unit/expression_parser_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../../lib/utils/expression_parser.dart';
import '../../lib/models/calculator_settings.dart';

void main() {
  group('ExpressionParser', () {
    group('Basic Arithmetic', () {
      test('should evaluate simple addition', () {
        expect(ExpressionParser.evaluate('2 + 3'), equals(5.0));
        expect(ExpressionParser.evaluate('10 + 20'), equals(30.0));
        expect(ExpressionParser.evaluate('1.5 + 2.5'), equals(4.0));
      });

      test('should evaluate simple subtraction', () {
        expect(ExpressionParser.evaluate('5 - 2'), equals(3.0));
        expect(ExpressionParser.evaluate('10 - 15'), equals(-5.0));
        expect(ExpressionParser.evaluate('3.7 - 1.2'), equals(2.5));
      });

      test('should evaluate simple multiplication', () {
        expect(ExpressionParser.evaluate('4 * 3'), equals(12.0));
        expect(ExpressionParser.evaluate('2.5 * 4'), equals(10.0));
        expect(ExpressionParser.evaluate('-3 * 2'), equals(-6.0));
      });

      test('should evaluate simple division', () {
        expect(ExpressionParser.evaluate('8 / 2'), equals(4.0));
        expect(ExpressionParser.evaluate('10 / 4'), equals(2.5));
        expect(ExpressionParser.evaluate('1 / 0'), equals(double.infinity));
      });

      test('should handle operator precedence', () {
        expect(ExpressionParser.evaluate('2 + 3 * 4'), equals(14.0));
        expect(ExpressionParser.evaluate('10 - 4 / 2'), equals(8.0));
        expect(ExpressionParser.evaluate('6 / 2 * 3'), equals(9.0));
      });

      test('should handle parentheses', () {
        expect(ExpressionParser.evaluate('(2 + 3) * 4'), equals(20.0));
        expect(ExpressionParser.evaluate('2 * (10 - 5)'), equals(10.0));
        expect(ExpressionParser.evaluate('((2 + 3) * 4) / 2'), equals(10.0));
      });
    });

    group('Scientific Functions', () {
      test('should evaluate trigonometric functions in radians', () {
        const angleMode = AngleMode.radians;
        expect(
          ExpressionParser.evaluate('sin(0)', angleMode: angleMode),
          closeTo(0.0, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('cos(0)', angleMode: angleMode),
          closeTo(1.0, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('tan(0)', angleMode: angleMode),
          closeTo(0.0, 1e-10)
        );
      });

      test('should evaluate trigonometric functions in degrees', () {
        const angleMode = AngleMode.degrees;
        expect(
          ExpressionParser.evaluate('sin(30)', angleMode: angleMode),
          closeTo(0.5, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('cos(60)', angleMode: angleMode),
          closeTo(0.5, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('tan(45)', angleMode: angleMode),
          closeTo(1.0, 1e-10)
        );
      });

      test('should evaluate logarithmic functions', () {
        expect(
          ExpressionParser.evaluate('ln(1)'),
          closeTo(0.0, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('log(10)'),
          closeTo(1.0, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('log2(8)'),
          closeTo(3.0, 1e-10)
        );
      });

      test('should evaluate power and root functions', () {
        expect(ExpressionParser.evaluate('sqrt(16)'), equals(4.0));
        expect(ExpressionParser.evaluate('cbrt(27)'), closeTo(3.0, 1e-10));
        expect(ExpressionParser.evaluate('2 ** 3'), equals(8.0));
      });

      test('should handle factorial', () {
        expect(ExpressionParser.evaluate('5!'), equals(120.0));
        expect(ExpressionParser.evaluate('0!'), equals(1.0));
        expect(ExpressionParser.evaluate('1!'), equals(1.0));
      });

      test('should evaluate constants', () {
        expect(
          ExpressionParser.evaluate('pi'),
          closeTo(3.14159265359, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('e'),
          closeTo(2.71828182846, 1e-10)
        );
      });
    });

    group('Complex Expressions', () {
      test('should evaluate mixed expressions', () {
        expect(
          ExpressionParser.evaluate('2 * sin(pi/2)'),
          closeTo(2.0, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('sqrt(2^2 + 3^2)'),
          closeTo(3.605551275, 1e-6)
        );
        expect(
          ExpressionParser.evaluate('ln(e^2)'),
          closeTo(2.0, 1e-10)
        );
      });

      test('should handle nested functions', () {
        expect(
          ExpressionParser.evaluate('sin(cos(0))'),
          closeTo(0.8414709848, 1e-10)
        );
        expect(
          ExpressionParser.evaluate('sqrt(abs(-16))'),
          equals(4.0)
        );
      });

      test('should handle scientific notation', () {
        expect(
          ExpressionParser.evaluate('1.23e2'),
          equals(123.0)
        );
        expect(
          ExpressionParser.evaluate('5e-3'),
          equals(0.005)
        );
      });
    });

    group('Error Handling', () {
      test('should throw FormatException for invalid expressions', () {
        expect(() => ExpressionParser.evaluate('2 +'), throwsFormatException);
        expect(() => ExpressionParser.evaluate('(2 + 3'), throwsFormatException);
        expect(() => ExpressionParser.evaluate('2 + )'), throwsFormatException);
        expect(() => ExpressionParser.evaluate('unknown(5)'), throwsFormatException);
      });

      test('should handle mathematical errors gracefully', () {
        expect(ExpressionParser.evaluate('ln(-1)'), isNaN);
        expect(ExpressionParser.evaluate('sqrt(-4)'), isNaN);
        expect(ExpressionParser.evaluate('factorial(-1)'), isNaN);
      });
    });

    group('Validation', () {
      test('should validate expressions correctly', () {
        expect(ExpressionParser.isValidExpression('2 + 3'), isTrue);
        expect(ExpressionParser.isValidExpression('sin(pi)'), isTrue);
        expect(ExpressionParser.isValidExpression('(2 + 3) * 4'), isTrue);
        
        expect(ExpressionParser.isValidExpression('2 +'), isFalse);
        expect(ExpressionParser.isValidExpression('(2 + 3'), isFalse);
        expect(ExpressionParser.isValidExpression('unknown()'), isFalse);
      });
    });

    group('Function and Constant Lists', () {
      test('should provide available functions', () {
        final functions = ExpressionParser.availableFunctions;
        expect(functions, contains('sin'));
        expect(functions, contains('cos'));
        expect(functions, contains('tan'));
        expect(functions, contains('ln'));
        expect(functions, contains('log'));
        expect(functions, contains('sqrt'));
        expect(functions, contains('factorial'));
      });

      test('should provide available constants', () {
        final constants = ExpressionParser.availableConstants;
        expect(constants, contains('pi'));
        expect(constants, contains('e'));
        expect(constants, contains('π'));
      });
    });
  });
}