// models/calculator_mode.dart
enum CalculatorMode {
  basic,
  scientific,
  programmer,
}

extension CalculatorModeExtension on CalculatorMode {
  String get displayName {
    switch (this) {
      case CalculatorMode.basic:
        return 'Basic';
      case CalculatorMode.scientific:
        return 'Scientific';
      case CalculatorMode.programmer:
        return 'Programmer';
    }
  }

  String get iconName {
    switch (this) {
      case CalculatorMode.basic:
        return '🔢';
      case CalculatorMode.scientific:
        return '🔬';
      case CalculatorMode.programmer:
        return '💻';
    }
  }
}