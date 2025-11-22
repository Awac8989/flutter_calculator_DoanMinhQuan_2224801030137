// widgets/button_grid_simple.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalculatorProvider, ThemeProvider>(
      builder: (context, calculator, themeProvider, child) {
        final mode = calculator.currentMode;
        
        return Container(
          padding: const EdgeInsets.all(AppSizes.screenPadding),
          child: AnimatedSwitcher(
            duration: AppDurations.slideIn,
            switchInCurve: AppAnimations.defaultCurve,
            switchOutCurve: AppAnimations.defaultCurve,
            child: Container(
              key: ValueKey(mode),
              child: _buildGridForMode(context, calculator, mode),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridForMode(BuildContext context, CalculatorProvider calculator, CalculatorMode mode) {
    switch (mode) {
      case CalculatorMode.basic:
        return _buildBasicGrid(context, calculator);
      case CalculatorMode.scientific:
        return _buildScientificGrid(context, calculator);
    }
  }

  Widget _buildBasicGrid(BuildContext context, CalculatorProvider calculator) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Row 1
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton('C', () => calculator.clear(), ButtonType.clear)),
              Expanded(child: _buildButton('⌫', () => calculator.backspace(), ButtonType.clear)),
              Expanded(child: _buildButton('%', () => calculator.percentage(), ButtonType.operator)),
              Expanded(child: _buildButton('÷', () => calculator.inputOperation('÷'), ButtonType.operator)),
            ],
          ),
        ),
        // Row 2
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton('7', () => calculator.inputNumber('7'), ButtonType.number)),
              Expanded(child: _buildButton('8', () => calculator.inputNumber('8'), ButtonType.number)),
              Expanded(child: _buildButton('9', () => calculator.inputNumber('9'), ButtonType.number)),
              Expanded(child: _buildButton('×', () => calculator.inputOperation('×'), ButtonType.operator)),
            ],
          ),
        ),
        // Row 3
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton('4', () => calculator.inputNumber('4'), ButtonType.number)),
              Expanded(child: _buildButton('5', () => calculator.inputNumber('5'), ButtonType.number)),
              Expanded(child: _buildButton('6', () => calculator.inputNumber('6'), ButtonType.number)),
              Expanded(child: _buildButton('-', () => calculator.inputOperation('-'), ButtonType.operator)),
            ],
          ),
        ),
        // Row 4
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton('1', () => calculator.inputNumber('1'), ButtonType.number)),
              Expanded(child: _buildButton('2', () => calculator.inputNumber('2'), ButtonType.number)),
              Expanded(child: _buildButton('3', () => calculator.inputNumber('3'), ButtonType.number)),
              Expanded(child: _buildButton('+', () => calculator.inputOperation('+'), ButtonType.operator)),
            ],
          ),
        ),
        // Row 5
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildButton('0', () => calculator.inputNumber('0'), ButtonType.number),
              ),
              Expanded(child: _buildButton('.', () => calculator.inputDecimal(), ButtonType.number)),
              Expanded(child: _buildButton('=', () => calculator.calculate(), ButtonType.operator)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScientificGrid(BuildContext context, CalculatorProvider calculator) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Scientific functions row
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton('sin', () => calculator.inputScientificFunction('sin'), ButtonType.function)),
              Expanded(child: _buildButton('cos', () => calculator.inputScientificFunction('cos'), ButtonType.function)),
              Expanded(child: _buildButton('tan', () => calculator.inputScientificFunction('tan'), ButtonType.function)),
              Expanded(child: _buildButton('ln', () => calculator.inputScientificFunction('ln'), ButtonType.function)),
            ],
          ),
        ),
        // Second row of scientific functions
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildButton('√', () => calculator.inputScientificFunction('√'), ButtonType.function)),
              Expanded(child: _buildButton('x²', () => calculator.inputScientificFunction('x²'), ButtonType.function)),
              Expanded(child: _buildButton('π', () => calculator.inputScientificFunction('π'), ButtonType.function)),
              Expanded(child: _buildButton('e', () => calculator.inputScientificFunction('e'), ButtonType.function)),
            ],
          ),
        ),
        // Basic buttons
        ..._getBasicButtonRows(calculator),
      ],
    );
  }

  List<Widget> _getBasicButtonRows(CalculatorProvider calculator) {
    return [
      // Row with clear and operations
      Expanded(
        child: Row(
          children: [
            Expanded(child: _buildButton('C', () => calculator.clear(), ButtonType.clear)),
            Expanded(child: _buildButton('⌫', () => calculator.backspace(), ButtonType.clear)),
            Expanded(child: _buildButton('%', () => calculator.percentage(), ButtonType.operator)),
            Expanded(child: _buildButton('÷', () => calculator.inputOperation('÷'), ButtonType.operator)),
          ],
        ),
      ),
      // Numbers 7-9
      Expanded(
        child: Row(
          children: [
            Expanded(child: _buildButton('7', () => calculator.inputNumber('7'), ButtonType.number)),
            Expanded(child: _buildButton('8', () => calculator.inputNumber('8'), ButtonType.number)),
            Expanded(child: _buildButton('9', () => calculator.inputNumber('9'), ButtonType.number)),
            Expanded(child: _buildButton('×', () => calculator.inputOperation('×'), ButtonType.operator)),
          ],
        ),
      ),
      // Numbers 4-6
      Expanded(
        child: Row(
          children: [
            Expanded(child: _buildButton('4', () => calculator.inputNumber('4'), ButtonType.number)),
            Expanded(child: _buildButton('5', () => calculator.inputNumber('5'), ButtonType.number)),
            Expanded(child: _buildButton('6', () => calculator.inputNumber('6'), ButtonType.number)),
            Expanded(child: _buildButton('-', () => calculator.inputOperation('-'), ButtonType.operator)),
          ],
        ),
      ),
      // Numbers 1-3
      Expanded(
        child: Row(
          children: [
            Expanded(child: _buildButton('1', () => calculator.inputNumber('1'), ButtonType.number)),
            Expanded(child: _buildButton('2', () => calculator.inputNumber('2'), ButtonType.number)),
            Expanded(child: _buildButton('3', () => calculator.inputNumber('3'), ButtonType.number)),
            Expanded(child: _buildButton('+', () => calculator.inputOperation('+'), ButtonType.operator)),
          ],
        ),
      ),
      // 0 and equals
      Expanded(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildButton('0', () => calculator.inputNumber('0'), ButtonType.number),
            ),
            Expanded(child: _buildButton('.', () => calculator.inputDecimal(), ButtonType.number)),
            Expanded(child: _buildButton('=', () => calculator.calculate(), ButtonType.operator)),
          ],
        ),
      ),
    ];
  }

  Widget _buildButton(String text, VoidCallback onPressed, ButtonType type) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: CalculatorButton(
        text: text,
        onPressed: onPressed,
        type: type,
      ),
    );
  }
}