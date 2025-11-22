// utils/calculator_logic.dart
import 'dart:math' as math;
import '../models/calculator_settings.dart';

class CalculatorLogic {
  
  // Basic arithmetic operations
  static double add(double a, double b) => a + b;
  static double subtract(double a, double b) => a - b;
  static double multiply(double a, double b) => a * b;
  static double divide(double a, double b) {
    if (b == 0) throw Exception('Division by zero');
    return a / b;
  }
  
  // Scientific functions
  static double sine(double x, AngleMode angleMode) {
    final radians = angleMode == AngleMode.degrees ? x * math.pi / 180 : x;
    return math.sin(radians);
  }
  
  static double cosine(double x, AngleMode angleMode) {
    final radians = angleMode == AngleMode.degrees ? x * math.pi / 180 : x;
    return math.cos(radians);
  }
  
  static double tangent(double x, AngleMode angleMode) {
    final radians = angleMode == AngleMode.degrees ? x * math.pi / 180 : x;
    return math.tan(radians);
  }
  
  static double arcsine(double x, AngleMode angleMode) {
    final result = math.asin(x);
    return angleMode == AngleMode.degrees ? result * 180 / math.pi : result;
  }
  
  static double arccosine(double x, AngleMode angleMode) {
    final result = math.acos(x);
    return angleMode == AngleMode.degrees ? result * 180 / math.pi : result;
  }
  
  static double arctangent(double x, AngleMode angleMode) {
    final result = math.atan(x);
    return angleMode == AngleMode.degrees ? result * 180 / math.pi : result;
  }
  
  // Logarithmic functions
  static double naturalLog(double x) {
    if (x <= 0) throw Exception('Invalid input for ln');
    return math.log(x);
  }
  
  static double logBase10(double x) {
    if (x <= 0) throw Exception('Invalid input for log');
    return math.log(x) / math.ln10;
  }
  
  static double logBase2(double x) {
    if (x <= 0) throw Exception('Invalid input for log2');
    return math.log(x) / math.ln2;
  }
  
  // Power functions
  static double power(double base, double exponent) {
    return math.pow(base, exponent).toDouble();
  }
  
  static double squareRoot(double x) {
    if (x < 0) throw Exception('Invalid input for sqrt');
    return math.sqrt(x);
  }
  
  static double cubeRoot(double x) {
    return math.pow(x.abs(), 1/3).toDouble() * (x >= 0 ? 1 : -1);
  }
  
  static double square(double x) => x * x;
  static double cube(double x) => x * x * x;
  
  // Factorial
  static double factorial(double x) {
    if (x < 0 || x != x.floor()) throw Exception('Invalid input for factorial');
    if (x > 170) throw Exception('Factorial too large'); // Prevent overflow
    
    double result = 1;
    for (int i = 2; i <= x; i++) {
      result *= i;
    }
    return result;
  }
  
  // Percentage
  static double percentage(double x) => x / 100;
  
  // Constants
  static double get pi => math.pi;
  static double get e => math.e;
  
  // Number formatting
  static String formatNumber(double number, int precision) {
    if (number.isInfinite) return 'Infinity';
    if (number.isNaN) return 'NaN';
    
    // Remove unnecessary decimal places
    if (number == number.floor() && number.abs() < 1e15) {
      return number.toInt().toString();
    }
    
    // Format with specified precision
    String formatted = number.toStringAsFixed(precision);
    
    // Remove trailing zeros
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'\.?0+$'), '');
    }
    
    return formatted;
  }
  
  // Check if result is valid
  static bool isValidResult(double result) {
    return !result.isNaN && !result.isInfinite;
  }
  
  // Convert angle from degrees to radians
  static double degToRad(double degrees) => degrees * math.pi / 180;
  
  // Convert angle from radians to degrees  
  static double radToDeg(double radians) => radians * 180 / math.pi;
  
  // Memory operations helpers
  static double memoryAdd(double memory, double value) => memory + value;
  static double memorySubtract(double memory, double value) => memory - value;
  
  // Programmer mode functions (for future implementation)
  static int bitwiseAnd(int a, int b) => a & b;
  static int bitwiseOr(int a, int b) => a | b;
  static int bitwiseXor(int a, int b) => a ^ b;
  static int bitwiseNot(int a) => ~a;
  static int leftShift(int a, int positions) => a << positions;
  static int rightShift(int a, int positions) => a >> positions;
}