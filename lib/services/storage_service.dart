// services/storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import '../models/calculator_settings.dart';
import '../utils/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  // Initialize shared preferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Ensure prefs is initialized
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  // ===== CALCULATION HISTORY =====
  
  // Save calculation history
  static Future<void> saveHistory(List<CalculationHistory> history) async {
    try {
      final List<Map<String, dynamic>> jsonList = 
          history.map((calc) => calc.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);
      await prefs.setString(StorageKeys.calculatorHistory, jsonString);
    } catch (e) {
      print('Error saving history: $e');
    }
  }
  
  // Load calculation history
  static List<CalculationHistory> loadHistory() {
    try {
      final String? jsonString = prefs.getString(StorageKeys.calculatorHistory);
      if (jsonString == null) return [];
      
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => CalculationHistory.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading history: $e');
      return [];
    }
  }
  
  // Clear history
  static Future<void> clearHistory() async {
    await prefs.remove(StorageKeys.calculatorHistory);
  }

  // ===== CALCULATOR SETTINGS =====
  
  // Save settings
  static Future<void> saveSettings(CalculatorSettings settings) async {
    try {
      final String jsonString = jsonEncode(settings.toJson());
      await prefs.setString(StorageKeys.calculatorSettings, jsonString);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }
  
  // Load settings
  static CalculatorSettings loadSettings() {
    try {
      final String? jsonString = prefs.getString(StorageKeys.calculatorSettings);
      if (jsonString == null) return const CalculatorSettings();
      
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return CalculatorSettings.fromJson(json);
    } catch (e) {
      print('Error loading settings: $e');
      return const CalculatorSettings();
    }
  }

  // ===== MEMORY VALUE =====
  
  // Save memory value
  static Future<void> saveMemoryValue(double value) async {
    await prefs.setDouble(StorageKeys.memoryValue, value);
  }
  
  // Load memory value
  static double loadMemoryValue() {
    return prefs.getDouble(StorageKeys.memoryValue) ?? 0.0;
  }
  
  // Clear memory
  static Future<void> clearMemory() async {
    await prefs.remove(StorageKeys.memoryValue);
  }

  // ===== CALCULATOR MODE =====
  
  // Save current mode
  static Future<void> saveCurrentMode(String mode) async {
    await prefs.setString(StorageKeys.currentMode, mode);
  }
  
  // Load current mode
  static String loadCurrentMode() {
    return prefs.getString(StorageKeys.currentMode) ?? 'basic';
  }

  // ===== UTILITY METHODS =====
  
  // Clear all data
  static Future<void> clearAllData() async {
    await prefs.clear();
  }
  
  // Check if key exists
  static bool hasKey(String key) {
    return prefs.containsKey(key);
  }
  
  // Get all keys (for debugging)
  static Set<String> getAllKeys() {
    return prefs.getKeys();
  }
}