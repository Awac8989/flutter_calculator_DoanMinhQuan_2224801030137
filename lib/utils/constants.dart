// utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  // Samsung-inspired Light Theme Colors
  static const lightPrimary = Color(0xFF1A1A1A);
  static const lightSecondary = Color(0xFF6C6C6C);
  static const lightAccent = Color(0xFF007AFF);
  static const lightBackground = Color(0xFFF8F9FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightError = Color(0xFFFF3B30);
  static const lightSuccess = Color(0xFF34C759);
  static const lightWarning = Color(0xFFFF9500);
  
  // Samsung-inspired Dark Theme Colors
  static const darkPrimary = Color(0xFF0A0A0A);
  static const darkSecondary = Color(0xFF1E1E1E);
  static const darkAccent = Color(0xFF0084FF);
  static const darkBackground = Color(0xFF000000);
  static const darkSurface = Color(0xFF1C1C1E);
  static const darkError = Color(0xFFFF453A);
  static const darkSuccess = Color(0xFF30D158);
  static const darkWarning = Color(0xFFFF9F0A);

  // Modern Button Colors (Light Theme)
  static const lightOperatorColor = Color(0xFF007AFF);
  static const lightNumberColor = Color(0xFFE5E5EA);
  static const lightNumberTextColor = Color(0xFF000000);
  static const lightFunctionColor = Color(0xFFA6A6A6);
  static const lightClearColor = Color(0xFFFF3B30);
  static const lightEqualsColor = Color(0xFF007AFF);
  
  // Modern Button Colors (Dark Theme)
  static const darkOperatorColor = Color(0xFF0A84FF);
  static const darkNumberColor = Color(0xFF2C2C2E);
  static const darkNumberTextColor = Color(0xFFFFFFFF);
  static const darkFunctionColor = Color(0xFF636366);
  static const darkClearColor = Color(0xFFFF453A);
  static const darkEqualsColor = Color(0xFF0A84FF);

  // Gradient Colors
  static const lightGradientStart = Color(0xFFFFFFFF);
  static const lightGradientEnd = Color(0xFFF2F2F7);
  static const darkGradientStart = Color(0xFF1C1C1E);
  static const darkGradientEnd = Color(0xFF000000);

  // Glass/Blur effect colors
  static const glassLight = Color(0x80FFFFFF);
  static const glassDark = Color(0x40000000);
  
  // Accent colors for different modes
  static const basicModeAccent = Color(0xFF007AFF);
  static const scientificModeAccent = Color(0xFF34C759);
}

class AppSizes {
  static const double screenPadding = 20.0;
  static const double buttonSpacing = 8.0;
  static const double buttonRadius = 20.0; // More rounded like Samsung
  static const double displayRadius = 24.0;
  static const double cardRadius = 16.0;
  
  // Font Sizes (Samsung-inspired typography)
  static const double displayFontSize = 48.0;
  static const double secondaryDisplayFontSize = 20.0;
  static const double buttonFontSize = 22.0;
  static const double historyFontSize = 16.0;
  static const double smallFontSize = 14.0;
  static const double largeFontSize = 28.0;
  
  // Button dimensions
  static const double buttonHeight = 70.0;
  static const double buttonWidth = 70.0;
  static const double largeButtonWidth = 150.0; // For 0 and equals
}

class AppDurations {
  static const Duration buttonPress = Duration(milliseconds: 150);
  static const Duration modeSwitch = Duration(milliseconds: 400);
  static const Duration modeTransition = Duration(milliseconds: 400);
  static const Duration fadeIn = Duration(milliseconds: 300);
  static const Duration slideIn = Duration(milliseconds: 350);
  static const Duration gridAppear = Duration(milliseconds: 400);
  static const Duration themeSwitch = Duration(milliseconds: 500);
  static const Duration ripple = Duration(milliseconds: 200);
}

class AppAnimations {
  // Scale animations
  static const double buttonPressScale = 0.95;
  static const double buttonHoverScale = 1.05;
  
  // Opacity animations
  static const double pressedOpacity = 0.7;
  static const double disabledOpacity = 0.5;
  
  // Curve animations
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve buttonCurve = Curves.elasticOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve fastCurve = Curves.easeOut;
}

class CalculatorConstants {
  static const double pi = 3.141592653589793;
  static const double e = 2.718281828459045;
  
  // Memory operations
  static const String memoryPlus = 'M+';
  static const String memoryMinus = 'M-';
  static const String memoryRecall = 'MR';
  static const String memoryClear = 'MC';
  
  // Scientific functions
  static const List<String> scientificFunctions = [
    'sin', 'cos', 'tan', 'asin', 'acos', 'atan',
    'ln', 'log', 'sqrt', 'cbrt', 'x²', 'x³', 'x^y',
    'π', 'e', '!', '(', ')', 'DEG', 'RAD'
  ];
  
  // Basic operations
  static const List<String> basicOperations = [
    '+', '-', '×', '÷', '%', '±', '=', 'C', 'CE'
  ];
  
  // Number formatting
  static const int maxDigits = 15;
  static const int defaultPrecision = 6;
}

class StorageKeys {
  static const String calculatorHistory = 'calculator_history';
  static const String calculatorSettings = 'calculator_settings';
  static const String memoryValue = 'memory_value';
  static const String currentMode = 'current_mode';
}

class AppIcons {
  static const IconData lightMode = Icons.light_mode_rounded;
  static const IconData darkMode = Icons.dark_mode_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData history = Icons.history_rounded;
  static const IconData memory = Icons.memory_rounded;
  static const IconData clear = Icons.clear_rounded;
  static const IconData backspace = Icons.backspace_rounded;
  static const IconData calculator = Icons.calculate_rounded;
  static const IconData functions = Icons.functions_rounded;
  static const IconData code = Icons.code_rounded;
}