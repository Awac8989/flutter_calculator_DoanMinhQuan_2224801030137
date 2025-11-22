// widgets/calculator_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';

enum ButtonType {
  number,
  operator,
  function,
  clear,
  equals,
  memory,
  scientific,
}

class CalculatorButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isWide;
  final bool isEnabled;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.number,
    this.isWide = false,
    this.isEnabled = true,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppDurations.buttonPress,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.buttonPressScale,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    _onTapCancel();
  }

  void _onTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  Color _getButtonColor(bool isDark) {
    switch (widget.type) {
      case ButtonType.number:
        return isDark ? AppColors.darkNumberColor : AppColors.lightNumberColor;
      case ButtonType.operator:
        return isDark ? AppColors.darkOperatorColor : AppColors.lightOperatorColor;
      case ButtonType.function:
        return isDark ? AppColors.darkFunctionColor : AppColors.lightFunctionColor;
      case ButtonType.clear:
        return isDark ? AppColors.darkClearColor : AppColors.lightClearColor;
      case ButtonType.equals:
        return isDark ? AppColors.darkEqualsColor : AppColors.lightEqualsColor;
      case ButtonType.memory:
        return isDark ? AppColors.darkOperatorColor.withOpacity(0.8) : AppColors.lightOperatorColor.withOpacity(0.8);
      case ButtonType.scientific:
        return isDark ? AppColors.scientificModeAccent : AppColors.scientificModeAccent;
    }
  }

  Color _getTextColor(bool isDark) {
    switch (widget.type) {
      case ButtonType.number:
        return isDark ? AppColors.darkNumberTextColor : AppColors.lightNumberTextColor;
      case ButtonType.operator:
      case ButtonType.equals:
      case ButtonType.memory:
      case ButtonType.scientific:
        return Colors.white;
      case ButtonType.function:
        return isDark ? Colors.white : Colors.black;
      case ButtonType.clear:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: AppDurations.themeSwitch,
              curve: AppAnimations.defaultCurve,
              width: widget.isWide ? AppSizes.largeButtonWidth : AppSizes.buttonWidth,
              height: AppSizes.buttonHeight,
              margin: EdgeInsets.all(AppSizes.buttonSpacing / 2),
              decoration: BoxDecoration(
                color: _getButtonColor(isDark),
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
                border: isDark && widget.type == ButtonType.function
                    ? Border.all(
                        color: AppColors.darkSecondary,
                        width: 0.5,
                      )
                    : null,
              ),
              child: Center(
                child: _buildTextOrIcon(isDark),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextOrIcon(bool isDark) {
    switch (widget.text) {
      case '⌫':
        return Icon(
          AppIcons.backspace,
          color: _getTextColor(isDark),
          size: 20,
        );
      case '±':
        return Icon(
          Icons.swap_horiz_rounded,
          color: _getTextColor(isDark),
          size: 20,
        );
      default:
        return Text(
          widget.text,
          style: TextStyle(
            fontSize: _getFontSize(),
            fontWeight: _getFontWeight(),
            color: _getTextColor(isDark),
            letterSpacing: 0.5,
          ),
        );
    }
  }

  double _getFontSize() {
    if (widget.isWide) return AppSizes.largeFontSize;
    if (widget.text.length > 3) return AppSizes.smallFontSize;
    return AppSizes.buttonFontSize;
  }

  FontWeight _getFontWeight() {
    switch (widget.type) {
      case ButtonType.operator:
      case ButtonType.equals:
        return FontWeight.w600;
      case ButtonType.clear:
        return FontWeight.w700;
      default:
        return FontWeight.w500;
    }
  }
}