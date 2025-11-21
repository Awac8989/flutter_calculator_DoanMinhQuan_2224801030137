import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF000000), // Đen hoàn toàn như hình
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0000'; // Hiển thị "0000" như trong hình
  double num1 = 0;
  double num2 = 0;
  String operation = '';
  bool shouldCalculate = false;

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '0000';
        num1 = 0;
        num2 = 0;
        operation = '';
        shouldCalculate = false;
      } else if (value == '+/-') {
        if (display.startsWith('-')) {
          display = display.substring(1);
        } else if (display != '0000') {
          display = '-$display';
        }
      } else if (value == '%') {
        double num = double.tryParse(display) ?? 0;
        display = (num / 100).toString();
        if (display.endsWith('.0')) {
          display = display.substring(0, display.length - 2);
        }
        shouldCalculate = true;
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        num1 = double.tryParse(display) ?? 0;
        operation = value;
        shouldCalculate = true;
      } else if (value == '=') {
        if (operation.isNotEmpty) {
          num2 = double.tryParse(display) ?? 0;
          double result = 0;

          if (operation == '+') result = num1 + num2;
          else if (operation == '-') result = num1 - num2;
          else if (operation == '×') result = num1 * num2;
          else if (operation == '÷') {
            if (num2 == 0) {
              display = 'Error';
              return;
            }
            result = num1 / num2;
          }

          display = _formatResult(result);
          num1 = result;
          operation = '';
          shouldCalculate = true;
        }
      } else if (value == '.') {
        if (!display.contains('.')) {
          display += '.';
        }
      } else if (value != '(' && value != ')') { // Ignore parentheses for now
        if (display == '0000' || shouldCalculate || display == 'Error') {
          display = value;
          shouldCalculate = false;
        } else {
          display += value;
        }
      }
    });
  }

  String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) return 'Error';
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(8).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  Widget _buildButton(String text, {Color? bgColor, Color? textColor, bool isWide = false}) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 70,
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? const Color(0xFF333333),
            foregroundColor: textColor ?? Colors.white,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                alignment: Alignment.bottomRight,
                child: Text(
                  display,
                  style: const TextStyle(
                    fontSize: 64,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),

            // Button area
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Row 1: C ( ) % ÷
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('C', bgColor: const Color(0xFFD32F2F)), // Đỏ như hình
                          _buildButton('(', bgColor: const Color(0xFF333333)),
                          _buildButton('%', bgColor: const Color(0xFF333333)),
                          _buildButton('÷', bgColor: const Color(0xFF4CAF50)), // Xanh lá như hình
                        ],
                      ),
                    ),
                    // Row 2: 7 8 9 ×
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7'),
                          _buildButton('8'),
                          _buildButton('9'),
                          _buildButton('×', bgColor: const Color(0xFF4CAF50)),
                        ],
                      ),
                    ),
                    // Row 3: 4 5 6 -
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4'),
                          _buildButton('5'),
                          _buildButton('6'),
                          _buildButton('-', bgColor: const Color(0xFF4CAF50)),
                        ],
                      ),
                    ),
                    // Row 4: 1 2 3 +
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1'),
                          _buildButton('2'),
                          _buildButton('3'),
                          _buildButton('+', bgColor: const Color(0xFF4CAF50)),
                        ],
                      ),
                    ),
                    // Row 5: +/- 0 . =
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('+/-'),
                          _buildButton('0'),
                          _buildButton('.'),
                          _buildButton('=', bgColor: const Color(0xFF4CAF50)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}