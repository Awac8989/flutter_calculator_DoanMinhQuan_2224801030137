// providers/calculator_provider.dart
import 'package:flutter/material.dart';
import '../models/calculator_mode.dart';
import '../models/calculation_history.dart';
import '../models/saved_calculation.dart';
import '../models/calculator_settings.dart';
import '../services/storage_service.dart';
import 'dart:math' as math;

class CalculatorProvider extends ChangeNotifier {
  String _display = '0';
  String _previousNumber = '';
  String _operation = '';
  String _lastExpression = '';
  String _currentFunction = '';
  bool _waitingForOperand = false;
  CalculatorMode _currentMode = CalculatorMode.basic;
  double _memoryValue = 0.0;
  List<CalculationHistory> _history = [];
  List<SavedCalculation> _savedCalculations = [];
  CalculatorSettings _settings = const CalculatorSettings();
  bool _hasError = false;
  String _errorMessage = '';

  // Getters
  String get display => _display;
  String get expression {
    // Show last completed expression when in result state
    if (_lastExpression.isNotEmpty && _operation.isEmpty && _waitingForOperand) {
      return _lastExpression;
    }
    // Show current function being applied
    if (_currentFunction.isNotEmpty) {
      if (_operation.isNotEmpty) {
        return '$_previousNumber $_operation $_currentFunction($_display';
      } else {
        return '$_currentFunction($_display';
      }
    }
    // Show current expression being built
    if (_operation.isEmpty) {
      return ''; // No expression when no operation
    }
    if (_waitingForOperand) {
      return '$_previousNumber $_operation'; // Show operation waiting for input
    }
    return '$_previousNumber $_operation $_display'; // Show full expression
  }
  CalculatorMode get currentMode => _currentMode;
  double get memoryValue => _memoryValue;
  List<CalculationHistory> get history => List.unmodifiable(_history);
  List<SavedCalculation> get savedCalculations => List.unmodifiable(_savedCalculations);
  CalculatorSettings get settings => _settings;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasMemory => _memoryValue != 0.0;

  Future<void> initialize() async {
    try {
      await StorageService.init();
      _settings = StorageService.loadSettings();
      _history = StorageService.loadHistory();
      _savedCalculations = StorageService.loadSavedCalculations();
      _memoryValue = StorageService.loadMemoryValue();
      notifyListeners();
    } catch (e) {
      print('Error initializing calculator: $e');
    }
  }

  // ===== INPUT METHODS =====
  
  void inputNumber(String number) {
    if (_hasError) _clearError();
    
    // Clear last expression when starting new input
    if (_lastExpression.isNotEmpty && _waitingForOperand && _operation.isEmpty) {
      _lastExpression = '';
    }
    
    // If there's a pending scientific function, continue building the number inside it
    if (_currentFunction.isNotEmpty && !_waitingForOperand) {
      // Continue building the number inside the function
      if (_display == '0') {
        _display = number;
      } else {
        _display = _display + number;
      }
    } else if (_waitingForOperand) {
      _display = number;
      _waitingForOperand = false;
    } else {
      // Always append numbers, replacing only initial '0'
      if (_display == '0') {
        _display = number;
      } else {
        _display = _display + number;
      }
    }
    notifyListeners();
  }

  void inputDecimal() {
    if (_hasError) _clearError();
    
    if (_waitingForOperand) {
      _display = '0.';
      _waitingForOperand = false;
    } else if (!_display.contains('.')) {
      _display += '.';
    }
    notifyListeners();
  }

  void inputOperation(String operation) {
    // Clear last expression when starting new operation chain
    _lastExpression = '';
    
    // Calculate any pending scientific function first
    if (_currentFunction.isNotEmpty) {
      _calculateScientificFunction();
      _currentFunction = '';
    }
    
    if (_previousNumber.isEmpty) {
      _previousNumber = _display;  // Store the actual display value
    } else if (!_waitingForOperand) {
      final result = _performCalculation();
      if (result != null) {
        _display = _formatResult(result);
        _previousNumber = _display;  // Store the formatted result
      }
    }

    _waitingForOperand = true;
    _operation = operation;
    notifyListeners();
  }

  void calculate() {
    // Calculate any pending scientific function first
    if (_currentFunction.isNotEmpty) {
      _calculateScientificFunction();
      _currentFunction = '';
    }
    
    if (_operation.isNotEmpty && !_waitingForOperand) {
      final result = _performCalculation();
      if (result != null) {
        final expression = '$_previousNumber $_operation $_display';
        _addToHistory(expression, _formatResult(result));
        
        _lastExpression = '$expression = ${_formatResult(result)}';
        _display = _formatResult(result);
        _previousNumber = '';
        _operation = '';
        _waitingForOperand = true;
      }
    }
    notifyListeners();
  }

  double? _performCalculation() {
    final prev = double.tryParse(_previousNumber) ?? 0;
    final current = double.tryParse(_display) ?? 0;
    
    try {
      switch (_operation) {
        case '+':
          return prev + current;
        case '-':
        case '−':
          return prev - current;
        case '*':
        case '×':
          return prev * current;
        case '/':
        case '÷':
          if (current == 0) {
            _showError('Cannot divide by zero');
            return null;
          }
          return prev / current;
        default:
          return current;
      }
    } catch (e) {
      _showError('Error');
      return null;
    }
  }

  String _formatResult(double result) {
    if (result == result.roundToDouble()) {
      return result.round().toString();
    }
    return result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  // ===== BASIC OPERATIONS =====
  
  void clear() {
    _display = '0';
    _previousNumber = '';
    _operation = '';
    _waitingForOperand = false;
    _clearError();
    notifyListeners();
  }

  void clearEntry() {
    if (_hasError) {
      _clearError();
      _display = '0';
    } else if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
      // If we deleted all digits, show 0
      if (_display.isEmpty || _display == '-') {
        _display = '0';
      }
    } else {
      _display = '0';
    }
    notifyListeners();
  }

  void backspace() {
    if (_hasError) {
      _clearError();
      _display = '0';
      return;
    }
    
    if (_waitingForOperand) {
      // If waiting for operand, backspace should clear and start fresh
      _display = '0';
      _waitingForOperand = false;
    } else {
      // Remove last character from current display
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        // Handle edge cases
        if (_display.isEmpty || _display == '-') {
          _display = '0';
        }
      } else {
        _display = '0';
      }
    }
    notifyListeners();
  }

  void toggleSign() {
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else if (_display != '0') {
      _display = '-$_display';
    }
    notifyListeners();
  }

  void percentage() {
    final value = double.tryParse(_display) ?? 0;
    final result = value / 100;
    _display = _formatResult(result);
    _waitingForOperand = true;
    notifyListeners();
  }

  // ===== SCIENTIFIC FUNCTIONS =====
  
  void inputScientificFunction(String function) {
    if (_hasError) _clearError();
    
    // If we already have a function being applied, calculate it first
    if (_currentFunction.isNotEmpty) {
      _calculateScientificFunction();
    }
    
    // Set the current function to show in expression
    _currentFunction = function;
    
    // For constants, apply immediately
    if (function == 'π' || function == 'e') {
      _applyConstant(function);
      _currentFunction = '';
    }
    
    notifyListeners();
  }
  
  void _applyConstant(String constant) {
    switch (constant) {
      case 'π':
        _display = _formatResult(math.pi);
        break;
      case 'e':
        _display = _formatResult(math.e);
        break;
    }
    _waitingForOperand = true;
  }
  
  void _calculateScientificFunction() {
    if (_currentFunction.isEmpty) return;
    
    final currentValue = double.tryParse(_display) ?? 0;
    
    try {
      double result = 0;
      
      switch (_currentFunction) {
        case 'sin':
          result = math.sin(_settings.angleMode == AngleMode.degrees ? currentValue * math.pi / 180 : currentValue);
          break;
        case 'cos':
          result = math.cos(_settings.angleMode == AngleMode.degrees ? currentValue * math.pi / 180 : currentValue);
          break;
        case 'tan':
          result = math.tan(_settings.angleMode == AngleMode.degrees ? currentValue * math.pi / 180 : currentValue);
          break;
        case 'ln':
          if (currentValue <= 0) throw Exception('Invalid input for ln');
          result = math.log(currentValue);
          break;
        case 'log':
          if (currentValue <= 0) throw Exception('Invalid input for log');
          result = math.log(currentValue) / math.log(10);
          break;
        case 'x²':
          result = math.pow(currentValue, 2).toDouble();
          break;
        case '√':
          if (currentValue < 0) throw Exception('Invalid input for √');
          result = math.sqrt(currentValue);
          break;
        default:
          throw Exception('Unknown function');
      }
      
      _display = _formatResult(result);
      _waitingForOperand = true;
      
    } catch (e) {
      _showError('Math Error');
    }
  }

  // ===== MEMORY OPERATIONS =====
  
  void memoryAdd() {
    final value = double.tryParse(_display) ?? 0;
    _memoryValue += value;
    StorageService.saveMemoryValue(_memoryValue);
    notifyListeners();
  }

  void memorySubtract() {
    final value = double.tryParse(_display) ?? 0;
    _memoryValue -= value;
    StorageService.saveMemoryValue(_memoryValue);
    notifyListeners();
  }

  void memoryRecall() {
    _display = _formatResult(_memoryValue);
    _waitingForOperand = true;
    notifyListeners();
  }

  void memoryClear() {
    _memoryValue = 0.0;
    StorageService.clearMemory();
    notifyListeners();
  }

  // ===== MODE SWITCHING =====
  
  void changeMode(CalculatorMode mode) {
    _currentMode = mode;
    clear();
    notifyListeners();
  }

  void switchMode(CalculatorMode mode) => changeMode(mode);

  // ===== HISTORY MANAGEMENT =====
  
  void _addToHistory(String expression, String result) {
    final historyItem = CalculationHistory(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
      mode: _currentMode.name,
    );
    
    _history.insert(0, historyItem);
    
    if (_history.length > 50) {
      _history = _history.take(50).toList();
    }
    
    StorageService.saveHistory(_history);
  }

  void clearHistory() {
    _history.clear();
    StorageService.clearHistory();
    notifyListeners();
  }

  // ===== SETTINGS =====
  
  void updateSettings(CalculatorSettings newSettings) {
    _settings = newSettings;
    StorageService.saveSettings(_settings);
    notifyListeners();
  }

  // ===== ERROR HANDLING =====
  
  void _showError(String message) {
    _hasError = true;
    _errorMessage = message;
    _display = 'Error';
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = '';
  }

  void allClear() {
    _display = '0';
    _previousNumber = '';
    _operation = '';
    _lastExpression = '';
    _currentFunction = '';
    _waitingForOperand = false;
    _clearError();
    notifyListeners();
  }

  // ===== SAVED CALCULATIONS =====
  
  Future<void> saveCurrentCalculation(String name, {String? description, String? category}) async {
    if (_display == '0' || _display.isEmpty) return;
    
    // Create proper expression for saving
    String expressionToSave;
    if (_lastExpression.isNotEmpty) {
      // Remove the "= result" part from last expression
      expressionToSave = _lastExpression.split(' = ').first;
    } else if (_operation.isNotEmpty && _previousNumber.isNotEmpty) {
      // Current operation in progress
      expressionToSave = '$_previousNumber $_operation $_display';
    } else {
      // Just the current display value
      expressionToSave = _display;
    }
    
    final calculation = SavedCalculation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      expression: expressionToSave,
      result: _display,
      createdAt: DateTime.now(),
      lastUsed: DateTime.now(),
      description: description,
      category: category ?? 'General',
    );
    
    _savedCalculations.add(calculation);
    await StorageService.saveSavedCalculations(_savedCalculations);
    notifyListeners();
  }
  
  Future<void> saveCalculationFromHistory(CalculationHistory history, String name, {String? description}) async {
    final calculation = SavedCalculation.fromHistory(history, name, description: description);
    _savedCalculations.add(calculation);
    await StorageService.saveSavedCalculations(_savedCalculations);
    notifyListeners();
  }
  
  Future<void> loadSavedCalculation(SavedCalculation calculation) async {
    // Update last used time
    final updatedCalculation = calculation.copyWith(lastUsed: DateTime.now());
    final index = _savedCalculations.indexWhere((c) => c.id == calculation.id);
    if (index >= 0) {
      _savedCalculations[index] = updatedCalculation;
      await StorageService.saveSavedCalculations(_savedCalculations);
    }
    
    // Load the calculation into display
    _display = calculation.result;
    _lastExpression = calculation.expression;
    _previousNumber = '';
    _operation = '';
    _waitingForOperand = true;
    notifyListeners();
  }
  
  Future<void> deleteSavedCalculation(String id) async {
    _savedCalculations.removeWhere((c) => c.id == id);
    await StorageService.saveSavedCalculations(_savedCalculations);
    notifyListeners();
  }

  Future<void> updateSavedCalculation(SavedCalculation updatedCalculation) async {
    final index = _savedCalculations.indexWhere((c) => c.id == updatedCalculation.id);
    if (index >= 0) {
      _savedCalculations[index] = updatedCalculation;
      await StorageService.saveSavedCalculations(_savedCalculations);
      notifyListeners();
    }
  }
  
  Future<void> toggleCalculationFavorite(String id) async {
    final index = _savedCalculations.indexWhere((c) => c.id == id);
    if (index >= 0) {
      _savedCalculations[index] = _savedCalculations[index].copyWith(
        isFavorite: !_savedCalculations[index].isFavorite,
      );
      await StorageService.saveSavedCalculations(_savedCalculations);
      notifyListeners();
    }
  }
  
  List<SavedCalculation> getSavedCalculationsByCategory(String category) {
    return _savedCalculations.where((c) => c.category == category).toList();
  }
  
  List<SavedCalculation> getFavoriteCalculations() {
    return _savedCalculations.where((c) => c.isFavorite).toList();
  }

  // ===== GESTURE HANDLING =====
  
  void onSwipeRight() => backspace();
  void onSwipeUp() {} // Handled by UI
  void onLongPressC() => allClear();
}