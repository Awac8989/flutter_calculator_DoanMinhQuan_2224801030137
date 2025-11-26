// utils/expression_parser.dart
import 'dart:math' as math;
import '../models/calculator_settings.dart';

class ExpressionParser {
  static const Map<String, int> _operatorPrecedence = {
    '||': 1,  // logical OR
    '&&': 2,  // logical AND
    '|': 3,   // bitwise OR
    '&': 5,   // bitwise AND
    '==': 6, '!=': 6,  // equality
    '<': 7, '>': 7, '<=': 7, '>=': 7,  // relational
    '<<': 8, '>>': 8,  // shift
    '+': 9, '-': 9,    // addition/subtraction
    '*': 10, '/': 10, '%': 10,  // multiplication/division/modulo
    '**': 11, 'pow': 11,  // power
    '!': 12,  // factorial (postfix)
  };

  static final Map<String, double Function(double, double)> _binaryOperators = {
    '+': (a, b) => a + b,
    '-': (a, b) => a - b,
    '*': (a, b) => a * b,
    '/': (a, b) => b != 0 ? a / b : double.infinity,
    '%': (a, b) => b != 0 ? a % b : double.nan,
    '**': (a, b) => math.pow(a, b).toDouble(),
    '^': (a, b) => math.pow(a, b).toDouble(),
  };

  static final Map<String, int Function(int, int)> _binaryBitwiseOperators = {
    '&': (a, b) => a & b,
    '|': (a, b) => a | b,
    '^': (a, b) => a ^ b,
    '<<': (a, b) => a << b,
    '>>': (a, b) => a >> b,
  };

  static final Map<String, double Function(double)> _functions = {
    'sin': (x) => math.sin(x),
    'cos': (x) => math.cos(x),
    'tan': (x) => math.tan(x),
    'asin': (x) => math.asin(x),
    'acos': (x) => math.acos(x),
    'atan': (x) => math.atan(x),
    'sinh': (x) => (math.exp(x) - math.exp(-x)) / 2,
    'cosh': (x) => (math.exp(x) + math.exp(-x)) / 2,
    'tanh': (x) => (math.exp(2 * x) - 1) / (math.exp(2 * x) + 1),
    'ln': (x) => x > 0 ? math.log(x) : double.nan,
    'log': (x) => x > 0 ? math.log(x) / math.ln10 : double.nan,
    'log2': (x) => x > 0 ? math.log(x) / math.ln2 : double.nan,
    'sqrt': (x) => x >= 0 ? math.sqrt(x) : double.nan,
    'cbrt': (x) => math.pow(x.abs(), 1 / 3) * (x >= 0 ? 1 : -1),
    'abs': (x) => x.abs(),
    'ceil': (x) => x.ceil().toDouble(),
    'floor': (x) => x.floor().toDouble(),
    'round': (x) => x.round().toDouble(),
    'exp': (x) => math.exp(x),
    'factorial': (x) => _factorial(x),
  };

  static const Map<String, double> _constants = {
    'pi': math.pi,
    'e': math.e,
    'π': math.pi,
  };

  static double _factorial(double x) {
    if (x < 0 || x != x.floor()) return double.nan;
    if (x > 170) return double.infinity; // Prevent overflow
    
    double result = 1;
    for (int i = 2; i <= x; i++) {
      result *= i;
    }
    return result;
  }

  /// Parse and evaluate a mathematical expression
  /// Supports:
  /// - Basic arithmetic: +, -, *, /, %, **
  /// - Functions: sin, cos, tan, ln, log, sqrt, etc.
  /// - Constants: pi, e, π
  /// - Parentheses for grouping
  /// - Scientific notation: 1.23e-4
  /// - Factorial: 5!
  /// - Bitwise operations: &, |, ^, <<, >>
  static double evaluate(String expression, {AngleMode angleMode = AngleMode.radians}) {
    if (expression.trim().isEmpty) return 0;

    try {
      // Tokenize the expression
      List<String> tokens = _tokenize(expression);
      
      // Convert to postfix notation (Reverse Polish Notation)
      List<String> postfix = _convertToPostfix(tokens);
      
      // Evaluate the postfix expression
      return _evaluatePostfix(postfix, angleMode);
    } catch (e) {
      throw FormatException('Invalid expression: ${e.toString()}');
    }
  }

  static List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String currentToken = '';
    bool inNumber = false;
    
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      
      if (char == ' ') {
        if (inNumber && currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
          inNumber = false;
        }
        continue;
      }
      
      // Handle numbers (including decimals and scientific notation)
      if (_isDigit(char) || char == '.' || 
          (char == 'e' || char == 'E') && inNumber) {
        currentToken += char;
        inNumber = true;
      }
      // Handle negative numbers
      else if (char == '-' && (i == 0 || 
               expression[i - 1] == '(' || 
               _isOperator(expression[i - 1]))) {
        currentToken += char;
        inNumber = true;
      }
      // Handle operators and functions
      else {
        if (inNumber && currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
          inNumber = false;
        }
        
        // Handle multi-character operators
        if (i < expression.length - 1) {
          String twoChar = expression.substring(i, i + 2);
          if (_operatorPrecedence.containsKey(twoChar)) {
            tokens.add(twoChar);
            i++; // Skip next character
            continue;
          }
        }
        
        // Handle functions and constants
        if (_isLetter(char)) {
          String identifier = '';
          int j = i;
          while (j < expression.length && _isLetter(expression[j])) {
            identifier += expression[j];
            j++;
          }
          
          // Check if it's a known function or constant
          if (_functions.containsKey(identifier) || _constants.containsKey(identifier)) {
            tokens.add(identifier);
            i = j - 1;
          } else {
            // Unknown identifier - treat as multiplication with variable
            throw FormatException('Unknown identifier: $identifier');
          }
        }
        // Handle single character tokens
        else if (char == '(' || char == ')' || _isOperator(char) || char == '!') {
          tokens.add(char);
        }
        else {
          throw FormatException('Invalid character: $char');
        }
      }
    }
    
    // Add the last token if there is one
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }
    
    return tokens;
  }

  static List<String> _convertToPostfix(List<String> tokens) {
    List<String> output = [];
    List<String> operatorStack = [];
    
    for (String token in tokens) {
      // Numbers and constants
      if (_isNumber(token) || _constants.containsKey(token)) {
        output.add(token);
      }
      // Functions
      else if (_functions.containsKey(token)) {
        operatorStack.add(token);
      }
      // Left parenthesis
      else if (token == '(') {
        operatorStack.add(token);
      }
      // Right parenthesis
      else if (token == ')') {
        while (operatorStack.isNotEmpty && operatorStack.last != '(') {
          output.add(operatorStack.removeLast());
        }
        if (operatorStack.isEmpty) {
          throw FormatException('Mismatched parentheses');
        }
        operatorStack.removeLast(); // Remove '('
        
        // If there's a function on top of stack, pop it
        if (operatorStack.isNotEmpty && _functions.containsKey(operatorStack.last)) {
          output.add(operatorStack.removeLast());
        }
      }
      // Factorial (postfix)
      else if (token == '!') {
        output.add(token);
      }
      // Operators
      else if (_operatorPrecedence.containsKey(token)) {
        while (operatorStack.isNotEmpty &&
               operatorStack.last != '(' &&
               _operatorPrecedence.containsKey(operatorStack.last) &&
               _operatorPrecedence[operatorStack.last]! >= _operatorPrecedence[token]!) {
          output.add(operatorStack.removeLast());
        }
        operatorStack.add(token);
      }
      else {
        throw FormatException('Invalid token: $token');
      }
    }
    
    // Pop remaining operators
    while (operatorStack.isNotEmpty) {
      String op = operatorStack.removeLast();
      if (op == '(' || op == ')') {
        throw FormatException('Mismatched parentheses');
      }
      output.add(op);
    }
    
    return output;
  }

  static double _evaluatePostfix(List<String> tokens, AngleMode angleMode) {
    List<double> stack = [];
    
    for (String token in tokens) {
      // Numbers
      if (_isNumber(token)) {
        stack.add(double.parse(token));
      }
      // Constants
      else if (_constants.containsKey(token)) {
        stack.add(_constants[token]!);
      }
      // Functions
      else if (_functions.containsKey(token)) {
        if (stack.isEmpty) {
          throw FormatException('Invalid expression: missing operand for $token');
        }
        double operand = stack.removeLast();
        
        // Handle angle conversion for trigonometric functions
        if (['sin', 'cos', 'tan'].contains(token) && angleMode == AngleMode.degrees) {
          operand = operand * math.pi / 180;
        }
        
        double result = _functions[token]!(operand);
        
        // Handle inverse trigonometric functions angle conversion
        if (['asin', 'acos', 'atan'].contains(token) && angleMode == AngleMode.degrees) {
          result = result * 180 / math.pi;
        }
        
        stack.add(result);
      }
      // Factorial (postfix)
      else if (token == '!') {
        if (stack.isEmpty) {
          throw FormatException('Invalid expression: missing operand for factorial');
        }
        double operand = stack.removeLast();
        stack.add(_factorial(operand));
      }
      // Binary operators
      else if (_binaryOperators.containsKey(token)) {
        if (stack.length < 2) {
          throw FormatException('Invalid expression: missing operand for $token');
        }
        double b = stack.removeLast();
        double a = stack.removeLast();
        stack.add(_binaryOperators[token]!(a, b));
      }
      else {
        throw FormatException('Unknown token: $token');
      }
    }
    
    if (stack.length != 1) {
      throw FormatException('Invalid expression');
    }
    
    return stack.first;
  }

  static bool _isNumber(String token) {
    return double.tryParse(token) != null;
  }

  static bool _isDigit(String char) {
    return '0123456789'.contains(char);
  }

  static bool _isLetter(String char) {
    return RegExp(r'[a-zA-Z]').hasMatch(char);
  }

  static bool _isOperator(String char) {
    return '+-*/%^'.contains(char);
  }

  /// Validate if an expression is syntactically correct
  static bool isValidExpression(String expression) {
    try {
      _tokenize(expression);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get list of available functions
  static List<String> get availableFunctions => _functions.keys.toList();

  /// Get list of available constants
  static List<String> get availableConstants => _constants.keys.toList();
}