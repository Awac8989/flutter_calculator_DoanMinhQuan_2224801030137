// test/widget/calculator_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import '../../lib/providers/calculator_provider.dart';
import '../../lib/models/calculator_mode.dart';
import '../../lib/models/calculator_settings.dart';

void main() {
  group('CalculatorProvider', () {
    late CalculatorProvider calculatorProvider;

    setUp(() {
      calculatorProvider = CalculatorProvider();
    });

    group('Basic Operations', () {
      test('should initialize with default values', () {
        expect(calculatorProvider.display, equals('0'));
        expect(calculatorProvider.currentMode, equals(CalculatorMode.basic));
        expect(calculatorProvider.hasError, isFalse);
        expect(calculatorProvider.memoryValue, equals(0.0));
      });

      test('should handle number input correctly', () {
        calculatorProvider.inputNumber('5');
        expect(calculatorProvider.display, equals('5'));

        calculatorProvider.inputNumber('3');
        expect(calculatorProvider.display, equals('53'));
      });

      test('should handle decimal input', () {
        calculatorProvider.inputNumber('3');
        calculatorProvider.inputDecimal();
        calculatorProvider.inputNumber('14');
        expect(calculatorProvider.display, equals('3.14'));
      });

      test('should prevent multiple decimals', () {
        calculatorProvider.inputNumber('3');
        calculatorProvider.inputDecimal();
        calculatorProvider.inputNumber('1');
        calculatorProvider.inputDecimal(); // Should be ignored
        calculatorProvider.inputNumber('4');
        expect(calculatorProvider.display, equals('3.14'));
      });

      test('should handle basic arithmetic', () {
        calculatorProvider.inputNumber('5');
        calculatorProvider.inputOperation('+');
        calculatorProvider.inputNumber('3');
        calculatorProvider.calculate();
        expect(calculatorProvider.display, equals('8'));
      });

      test('should handle multiple operations', () {
        calculatorProvider.inputNumber('10');
        calculatorProvider.inputOperation('+');
        calculatorProvider.inputNumber('5');
        calculatorProvider.inputOperation('*');
        calculatorProvider.inputNumber('2');
        calculatorProvider.calculate();
        expect(calculatorProvider.display, equals('30')); // (10 + 5) * 2
      });

      test('should handle clear operations', () {
        calculatorProvider.inputNumber('123');
        calculatorProvider.clear();
        expect(calculatorProvider.display, equals('0'));
      });

      test('should handle all clear', () {
        calculatorProvider.inputNumber('5');
        calculatorProvider.inputOperation('+');
        calculatorProvider.inputNumber('3');
        calculatorProvider.allClear();
        
        expect(calculatorProvider.display, equals('0'));
        expect(calculatorProvider.expression, equals(''));
      });
    });

    group('Mode Switching', () {
      test('should switch modes correctly', () {
        calculatorProvider.changeMode(CalculatorMode.scientific);
        expect(calculatorProvider.currentMode, equals(CalculatorMode.scientific));
        
        calculatorProvider.changeMode(CalculatorMode.programmer);
        expect(calculatorProvider.currentMode, equals(CalculatorMode.programmer));
        expect(calculatorProvider.isProgrammerMode, isTrue);
      });

      test('should clear display when switching modes', () {
        calculatorProvider.inputNumber('123');
        calculatorProvider.changeMode(CalculatorMode.scientific);
        expect(calculatorProvider.display, equals('0'));
      });
    });

    group('Scientific Mode', () {
      setUp(() {
        calculatorProvider.changeMode(CalculatorMode.scientific);
      });

      test('should calculate scientific functions', () {
        calculatorProvider.inputScientificFunction('sin');
        calculatorProvider.inputNumber('0');
        calculatorProvider.calculate();
        expect(double.parse(calculatorProvider.display), closeTo(0.0, 1e-10));
      });

      test('should handle constants', () {
        calculatorProvider.inputConstant('pi');
        final piValue = double.parse(calculatorProvider.display);
        expect(piValue, closeTo(3.14159265359, 1e-10));
      });
    });

    group('Memory Operations', () {
      test('should store and recall memory', () {
        calculatorProvider.inputNumber('42');
        calculatorProvider.memoryStore();
        expect(calculatorProvider.memoryValue, equals(42.0));
        expect(calculatorProvider.hasMemory, isTrue);

        calculatorProvider.clear();
        calculatorProvider.memoryRecall();
        expect(calculatorProvider.display, equals('42'));
      });

      test('should add to memory', () {
        calculatorProvider.inputNumber('10');
        calculatorProvider.memoryStore();
        
        calculatorProvider.inputNumber('5');
        calculatorProvider.memoryAdd();
        expect(calculatorProvider.memoryValue, equals(15.0));
      });

      test('should subtract from memory', () {
        calculatorProvider.inputNumber('10');
        calculatorProvider.memoryStore();
        
        calculatorProvider.inputNumber('3');
        calculatorProvider.memorySubtract();
        expect(calculatorProvider.memoryValue, equals(7.0));
      });

      test('should clear memory', () {
        calculatorProvider.inputNumber('42');
        calculatorProvider.memoryStore();
        calculatorProvider.memoryClear();
        
        expect(calculatorProvider.memoryValue, equals(0.0));
        expect(calculatorProvider.hasMemory, isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle division by zero', () {
        calculatorProvider.inputNumber('5');
        calculatorProvider.inputOperation('/');
        calculatorProvider.inputNumber('0');
        calculatorProvider.calculate();
        
        expect(calculatorProvider.hasError, isTrue);
        expect(calculatorProvider.display, equals('Error'));
      });

      test('should clear error on next input', () {
        calculatorProvider.inputNumber('5');
        calculatorProvider.inputOperation('/');
        calculatorProvider.inputNumber('0');
        calculatorProvider.calculate();
        
        expect(calculatorProvider.hasError, isTrue);
        
        calculatorProvider.inputNumber('1');
        expect(calculatorProvider.hasError, isFalse);
        expect(calculatorProvider.display, equals('1'));
      });
    });

    group('History Management', () {
      test('should add calculations to history', () {
        calculatorProvider.inputNumber('5');
        calculatorProvider.inputOperation('+');
        calculatorProvider.inputNumber('3');
        calculatorProvider.calculate();
        
        expect(calculatorProvider.history.length, equals(1));
        expect(calculatorProvider.history.first.expression, equals('5 + 3'));
        expect(calculatorProvider.history.first.result, equals('8'));
      });

      test('should load from history', () {
        // Add a calculation to history
        calculatorProvider.inputNumber('7');
        calculatorProvider.inputOperation('*');
        calculatorProvider.inputNumber('6');
        calculatorProvider.calculate();
        
        // Load the result back
        calculatorProvider.loadFromHistory(calculatorProvider.history.first);
        expect(calculatorProvider.display, equals('42'));
      });

      test('should clear history', () {
        calculatorProvider.inputNumber('1');
        calculatorProvider.inputOperation('+');
        calculatorProvider.inputNumber('1');
        calculatorProvider.calculate();
        
        calculatorProvider.clearHistory();
        expect(calculatorProvider.history.isEmpty, isTrue);
      });
    });

    group('Saved Calculations', () {
      test('should save current calculation', () async {
        calculatorProvider.inputNumber('25');
        await calculatorProvider.saveCurrentCalculation('Test Calculation');
        
        expect(calculatorProvider.savedCalculations.length, equals(1));
        expect(calculatorProvider.savedCalculations.first.name, equals('Test Calculation'));
        expect(calculatorProvider.savedCalculations.first.result, equals('25'));
      });

      test('should load saved calculation', () async {
        calculatorProvider.inputNumber('100');
        await calculatorProvider.saveCurrentCalculation('Hundred');
        
        calculatorProvider.clear();
        calculatorProvider.loadSavedCalculation(calculatorProvider.savedCalculations.first);
        expect(calculatorProvider.display, equals('100'));
      });

      test('should delete saved calculation', () async {
        calculatorProvider.inputNumber('50');
        await calculatorProvider.saveCurrentCalculation('Fifty');
        
        await calculatorProvider.deleteSavedCalculation(calculatorProvider.savedCalculations.first.id);
        expect(calculatorProvider.savedCalculations.isEmpty, isTrue);
      });

      test('should toggle favorite status', () async {
        calculatorProvider.inputNumber('99');
        await calculatorProvider.saveCurrentCalculation('Ninety Nine');
        
        final calculation = calculatorProvider.savedCalculations.first;
        expect(calculation.isFavorite, isFalse);
        
        await calculatorProvider.toggleCalculationFavorite(calculation.id);
        final updatedCalculation = calculatorProvider.savedCalculations.first;
        expect(updatedCalculation.isFavorite, isTrue);
      });
    });

    group('Settings Management', () {
      test('should update settings', () {
        const newSettings = CalculatorSettings(
          decimalPrecision: 4,
          angleMode: AngleMode.degrees,
          themeMode: ThemeMode.dark,
        );
        
        calculatorProvider.updateSettings(newSettings);
        expect(calculatorProvider.settings.decimalPrecision, equals(4));
        expect(calculatorProvider.settings.angleMode, equals(AngleMode.degrees));
        expect(calculatorProvider.settings.themeMode, equals(ThemeMode.dark));
      });
    });

    group('Expression Display', () {
      test('should show current expression', () {
        calculatorProvider.inputNumber('5');
        calculatorProvider.inputOperation('+');
        calculatorProvider.inputNumber('3');
        
        expect(calculatorProvider.expression, equals('5 + 3'));
      });

      test('should show last completed expression', () {
        calculatorProvider.inputNumber('8');
        calculatorProvider.inputOperation('-');
        calculatorProvider.inputNumber('3');
        calculatorProvider.calculate();
        
        expect(calculatorProvider.expression, contains('8 - 3 = 5'));
      });

      test('should clear expression on new input', () {
        calculatorProvider.inputNumber('8');
        calculatorProvider.inputOperation('-');
        calculatorProvider.inputNumber('3');
        calculatorProvider.calculate();
        
        // Start new calculation
        calculatorProvider.inputNumber('1');
        expect(calculatorProvider.expression, equals(''));
      });
    });
  });
}