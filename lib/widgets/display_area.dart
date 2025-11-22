// widgets/display_area.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../models/calculator_mode.dart';
import '../models/calculator_settings.dart' as calc_settings;

class DisplayArea extends StatefulWidget {
  const DisplayArea({super.key});

  @override
  State<DisplayArea> createState() => _DisplayAreaState();
}

class _DisplayAreaState extends State<DisplayArea>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Shake animation for errors
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    // Fade animation for result display
    _fadeController = AnimationController(
      duration: AppDurations.fadeIn,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _triggerErrorShake() {
    _shakeController.forward().then((_) {
      _shakeController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalculatorProvider, ThemeProvider>(
      builder: (context, calculator, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;
        
        // Trigger error animation when error occurs
        if (calculator.hasError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _triggerErrorShake();
          });
        }

        // Reset fade animation for new results
        if (calculator.display != '0000') {
          _fadeController.reset();
          _fadeController.forward();
        }

        return AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimation.value, 0),
              child: AnimatedContainer(
                duration: AppDurations.themeSwitch,
                curve: AppAnimations.defaultCurve,
                width: double.infinity,
                margin: const EdgeInsets.all(AppSizes.screenPadding),
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppSizes.displayRadius),
                  border: isDark 
                      ? Border.all(color: AppColors.darkSecondary.withOpacity(0.3), width: 0.5)
                      : null,
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Top bar with mode and theme toggle
                    _buildTopBar(isDark, calculator),
                    
                    const SizedBox(height: 16),
                    
                    // Expression display (if any)
                    _buildExpressionDisplay(isDark, calculator),
                    
                    // Main result display
                    _buildMainDisplay(isDark, calculator),

                    // Status indicators
                    _buildStatusIndicators(isDark, calculator),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopBar(bool isDark, CalculatorProvider calculator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Mode indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getModeColor(calculator.currentMode, isDark),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                calculator.currentMode.iconName,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 4),
              Text(
                calculator.currentMode.displayName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // Theme toggle and memory indicator
        Row(
          children: [
            // Memory indicator
            if (calculator.hasMemory)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.basicModeAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  AppIcons.memory,
                  size: 16,
                  color: AppColors.basicModeAccent,
                ),
              ),
            
            if (calculator.hasMemory) const SizedBox(width: 8),
            
            // Theme toggle button
            GestureDetector(
              onTap: () {
                final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                final newMode = themeProvider.isDarkMode 
                    ? calc_settings.ThemeMode.light 
                    : calc_settings.ThemeMode.dark;
                themeProvider.updateThemeMode(newMode);
              },
              child: AnimatedContainer(
                duration: AppDurations.themeSwitch,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSecondary : AppColors.lightSecondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedSwitcher(
                  duration: AppDurations.themeSwitch,
                  child: Icon(
                    isDark ? AppIcons.lightMode : AppIcons.darkMode,
                    key: ValueKey(isDark),
                    size: 16,
                    color: isDark ? Colors.white : AppColors.lightSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpressionDisplay(bool isDark, CalculatorProvider calculator) {
    final expr = calculator.expression.trim();
    if (expr.isEmpty) {
      return const SizedBox(height: 8);
    }
    
    return AnimatedOpacity(
      duration: AppDurations.fadeIn,
      opacity: 1.0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(minHeight: 24),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Text(
            expr,
            style: TextStyle(
              fontSize: AppSizes.secondaryDisplayFontSize,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }

  Widget _buildMainDisplay(bool isDark, CalculatorProvider calculator) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 60),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            calculator.display,
            style: TextStyle(
              fontSize: _getDisplayFontSize(calculator.display),
              fontWeight: FontWeight.w300,
              color: calculator.hasError 
                  ? (isDark ? AppColors.darkError : AppColors.lightError)
                  : (isDark ? Colors.white : AppColors.lightPrimary),
              letterSpacing: -1.0,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicators(bool isDark, CalculatorProvider calculator) {
    // Error message display
    if (calculator.hasError && calculator.errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          calculator.errorMessage,
          style: TextStyle(
            fontSize: AppSizes.smallFontSize,
            color: isDark ? AppColors.darkError : AppColors.lightError,
          ),
          textAlign: TextAlign.right,
        ),
      );
    }
    
    // Status indicators row
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Angle mode for scientific mode
          if (calculator.currentMode == CalculatorMode.scientific)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.scientificModeAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                calculator.settings.angleMode.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.scientificModeAccent,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          
          const Spacer(),
          
          // History indicator
          if (calculator.history.isNotEmpty)
            GestureDetector(
              onTap: () {
                // Show history - implement later
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkSecondary : AppColors.lightSecondary).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppIcons.history,
                      size: 12,
                      color: isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${calculator.history.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getModeColor(CalculatorMode mode, bool isDark) {
    switch (mode) {
      case CalculatorMode.basic:
        return AppColors.basicModeAccent;
      case CalculatorMode.scientific:
        return AppColors.scientificModeAccent;
    }
  }

  double _getDisplayFontSize(String display) {
    // Adjust font size based on display length for better fit
    final length = display.length;
    if (length <= 8) return AppSizes.displayFontSize;
    if (length <= 12) return AppSizes.displayFontSize * 0.8;
    if (length <= 16) return AppSizes.displayFontSize * 0.6;
    return AppSizes.displayFontSize * 0.5;
  }
}

// Gesture detector wrapper for swipe gestures
class GestureDisplayArea extends StatelessWidget {
  final Widget child;
  
  const GestureDisplayArea({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final calculator = Provider.of<CalculatorProvider>(context, listen: false);
    
    return GestureDetector(
      onPanEnd: (details) {
        // Swipe right to delete last character
        if (details.velocity.pixelsPerSecond.dx > 100) {
          calculator.onSwipeRight();
        }
        // Swipe up to open history
        else if (details.velocity.pixelsPerSecond.dy < -100) {
          calculator.onSwipeUp();
        }
      },
      child: child,
    );
  }
}