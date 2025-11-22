// models/calculator_mode.dart
enum CalculatorMode {
  basic,
  scientific,
}

extension CalculatorModeExtension on CalculatorMode {
  String get displayName {
    switch (this) {
      case CalculatorMode.basic:
        return 'Basic';
      case CalculatorMode.scientific:
        return 'Scientific';
    }
  }

  String get iconName {
    switch (this) {
      case CalculatorMode.basic:
        return '🔢';
      case CalculatorMode.scientific:
        return '🔬';
    }
  }
}