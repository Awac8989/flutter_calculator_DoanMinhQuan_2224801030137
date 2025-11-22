// models/calculator_settings.dart
enum AngleMode { degrees, radians }
enum ThemeMode { light, dark, system }

class CalculatorSettings {
  final ThemeMode themeMode;
  final int decimalPrecision; // 2-10
  final AngleMode angleMode; // for scientific mode
  final bool hapticFeedback;
  final bool soundEffects;
  final int historySize; // 25/50/100
  final double fontSize; // for accessibility

  const CalculatorSettings({
    this.themeMode = ThemeMode.system,
    this.decimalPrecision = 6,
    this.angleMode = AngleMode.degrees,
    this.hapticFeedback = true,
    this.soundEffects = false,
    this.historySize = 50,
    this.fontSize = 1.0,
  });

  // Copy with method for immutability
  CalculatorSettings copyWith({
    ThemeMode? themeMode,
    int? decimalPrecision,
    AngleMode? angleMode,
    bool? hapticFeedback,
    bool? soundEffects,
    int? historySize,
    double? fontSize,
  }) {
    return CalculatorSettings(
      themeMode: themeMode ?? this.themeMode,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      angleMode: angleMode ?? this.angleMode,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundEffects: soundEffects ?? this.soundEffects,
      historySize: historySize ?? this.historySize,
      fontSize: fontSize ?? this.fontSize,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'decimalPrecision': decimalPrecision,
      'angleMode': angleMode.index,
      'hapticFeedback': hapticFeedback,
      'soundEffects': soundEffects,
      'historySize': historySize,
      'fontSize': fontSize,
    };
  }

  // Create from JSON
  factory CalculatorSettings.fromJson(Map<String, dynamic> json) {
    return CalculatorSettings(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
      decimalPrecision: json['decimalPrecision'] as int? ?? 6,
      angleMode: AngleMode.values[json['angleMode'] as int? ?? 0],
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      soundEffects: json['soundEffects'] as bool? ?? false,
      historySize: json['historySize'] as int? ?? 50,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 1.0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalculatorSettings &&
        other.themeMode == themeMode &&
        other.decimalPrecision == decimalPrecision &&
        other.angleMode == angleMode &&
        other.hapticFeedback == hapticFeedback &&
        other.soundEffects == soundEffects &&
        other.historySize == historySize &&
        other.fontSize == fontSize;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      decimalPrecision,
      angleMode,
      hapticFeedback,
      soundEffects,
      historySize,
      fontSize,
    );
  }
}