// widgets/mode_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../models/calculator_mode.dart';
import '../utils/constants.dart';

class ModeSelector extends StatefulWidget {
  const ModeSelector({super.key});

  @override
  State<ModeSelector> createState() => _ModeSelectorState();
}

class _ModeSelectorState extends State<ModeSelector>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: AppDurations.modeSwitch,
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onModeChanged(CalculatorMode mode) {
    _slideController.reset();
    context.read<CalculatorProvider>().switchMode(mode);
    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalculatorProvider, ThemeProvider>(
      builder: (context, calculator, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;
        
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.screenPadding,
            vertical: AppSizes.buttonSpacing,
          ),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(24),
            border: isDark 
                ? Border.all(color: AppColors.darkSecondary.withOpacity(0.3), width: 0.5)
                : null,
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(_slideAnimation),
            child: Row(
              children: CalculatorMode.values.map((mode) {
                final isSelected = calculator.currentMode == mode;
                final modeColor = _getModeColor(mode);
                
                return Expanded(
                  child: AnimatedContainer(
                    duration: AppDurations.buttonPress,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected ? modeColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: modeColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => _onModeChanged(mode),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Mode icon
                              AnimatedContainer(
                                duration: AppDurations.buttonPress,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? Colors.white.withOpacity(0.2)
                                      : (isDark ? AppColors.darkSecondary : AppColors.lightSecondary).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  mode.iconName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected 
                                        ? Colors.white
                                        : isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 4),
                              
                              // Mode name
                              Text(
                                mode.displayName,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : isDark ? AppColors.darkSecondary : AppColors.lightSecondary,
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Color _getModeColor(CalculatorMode mode) {
    switch (mode) {
      case CalculatorMode.basic:
        return AppColors.basicModeAccent;
      case CalculatorMode.scientific:
        return AppColors.scientificModeAccent;
      case CalculatorMode.programmer:
        return AppColors.lightAccent;
    }
  }
}

// Mode transition animation widget
class ModeTransition extends StatelessWidget {
  final Widget child;
  final CalculatorMode previousMode;
  final CalculatorMode currentMode;
  
  const ModeTransition({
    super.key,
    required this.child,
    required this.previousMode,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.modeSwitch,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(currentMode),
        child: child,
      ),
    );
  }
}