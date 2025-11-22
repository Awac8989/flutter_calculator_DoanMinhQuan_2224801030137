// models/calculation_history.dart
class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;
  final String mode; // basic, scientific, programmer

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
    required this.mode,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'mode': mode,
    };
  }

  // Create from JSON
  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      expression: json['expression'] as String,
      result: json['result'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      mode: json['mode'] as String,
    );
  }

  @override
  String toString() {
    return '$expression = $result';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalculationHistory &&
        other.expression == expression &&
        other.result == result &&
        other.timestamp == timestamp &&
        other.mode == mode;
  }

  @override
  int get hashCode {
    return Object.hash(expression, result, timestamp, mode);
  }
}