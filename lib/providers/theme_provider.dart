// providers/theme_provider.dart
import 'package:flutter/material.dart';
import '../models/calculator_settings.dart' as calc_settings;
import '../utils/constants.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  calc_settings.CalculatorSettings _settings = const calc_settings.CalculatorSettings();
  
  calc_settings.CalculatorSettings get settings => _settings;
  
  bool get isDarkMode {
    switch (_settings.themeMode) {
      case calc_settings.ThemeMode.light:
        return false;
      case calc_settings.ThemeMode.dark:
        return true;
      case calc_settings.ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
  }

  // Initialize theme from storage
  Future<void> initializeTheme() async {
    try {
      _settings = StorageService.loadSettings();
      notifyListeners();
    } catch (e) {
      print('Error loading theme settings: $e');
    }
  }

  // Update theme mode
  Future<void> updateThemeMode(calc_settings.ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }

  // Update settings
  Future<void> updateSettings(calc_settings.CalculatorSettings newSettings) async {
    _settings = newSettings;
    await StorageService.saveSettings(_settings);
    notifyListeners();
  }

  // Get light theme
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.lightPrimary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.lightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(
            fontSize: AppSizes.buttonFontSize,
            fontWeight: FontWeight.w500,
          ),
          animationDuration: AppDurations.buttonPress,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppSizes.displayFontSize,
          fontWeight: FontWeight.w300,
          color: AppColors.lightPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: AppSizes.secondaryDisplayFontSize,
          fontWeight: FontWeight.w400,
          color: AppColors.lightSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.historyFontSize,
          color: AppColors.lightSecondary,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.buttonFontSize,
          color: AppColors.lightPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        error: AppColors.lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightPrimary,
        onError: Colors.white,
      ),
    );
  }

  // Get dark theme
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.darkPrimary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shadowColor: Colors.white.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(
            fontSize: AppSizes.buttonFontSize,
            fontWeight: FontWeight.w500,
          ),
          animationDuration: AppDurations.buttonPress,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppSizes.displayFontSize,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: AppSizes.secondaryDisplayFontSize,
          fontWeight: FontWeight.w400,
          color: AppColors.darkSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.historyFontSize,
          color: AppColors.darkSecondary,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          fontSize: AppSizes.buttonFontSize,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        error: AppColors.darkError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.black,
      ),
    );
  }

  // Get current theme based on settings
  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;
}