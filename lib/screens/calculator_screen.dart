// screens/calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../models/calculator_settings.dart' as calc_settings;
import '../widgets/display_area.dart';
import '../widgets/button_grid.dart';
import '../widgets/mode_selector.dart';
import '../utils/constants.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize calculator when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalculatorProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        
        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                    ? [
                        AppColors.darkBackground,
                        AppColors.darkBackground.withBlue(15),
                      ]
                    : [
                        AppColors.lightBackground,
                        AppColors.lightBackground.withOpacity(0.95),
                      ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Simplified app bar (remove for cleaner Samsung look)
                  // _buildAppBar(),
                  
                  // Calculator display
                  const Expanded(
                    flex: 2,
                    child: DisplayArea(),
                  ),
                  
                  // Mode selector
                  const ModeSelector(),
                  
                  // Button grid
                  const Expanded(
                    flex: 3,
                    child: ButtonGrid(),
                  ),
                  
                  // Bottom spacing for Samsung style
                  const SizedBox(height: AppSizes.screenPadding),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Calculator',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              // History button
              Consumer<CalculatorProvider>(
                builder: (context, calculator, child) {
                  final hasHistory = calculator.history.isNotEmpty;
                  return IconButton(
                    icon: Badge(
                      isLabelVisible: hasHistory,
                      child: const Icon(Icons.history),
                    ),
                    onPressed: () => _showHistoryDialog(context),
                    tooltip: 'History',
                  );
                },
              ),
              
              // Memory indicator
              Consumer<CalculatorProvider>(
                builder: (context, calculator, child) {
                  return IconButton(
                    icon: Badge(
                      isLabelVisible: calculator.hasMemory,
                      child: const Icon(Icons.memory),
                    ),
                    onPressed: () => calculator.memoryRecall(),
                    tooltip: 'Memory Recall',
                  );
                },
              ),
              
              // Settings button
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettingsDialog(context),
                tooltip: 'Settings',
              ),
              
              // Theme toggle
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode 
                          ? Icons.light_mode 
                          : Icons.dark_mode,
                    ),
                    onPressed: () {
                      final newMode = themeProvider.isDarkMode 
                          ? calc_settings.ThemeMode.light 
                          : calc_settings.ThemeMode.dark;
                      themeProvider.updateThemeMode(newMode);
                    },
                    tooltip: 'Toggle Theme',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calculation History'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Consumer<CalculatorProvider>(
            builder: (context, calculator, child) {
              final history = calculator.history;
              
              if (history.isEmpty) {
                return const Center(
                  child: Text('No calculations yet'),
                );
              }
              
              return ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[history.length - 1 - index];
                  return ListTile(
                    title: Text(item.expression),
                    subtitle: Text(
                      '= ${item.result}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      _formatTime(item.timestamp),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () {
                      // Use the result in current calculation
                      Navigator.of(context).pop();
                      calculator.inputNumber(item.result);
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<CalculatorProvider>().clearHistory();
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Theme setting
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: themeProvider.isDarkMode,
                  onChanged: (_) {
                    final newMode = themeProvider.isDarkMode 
                        ? calc_settings.ThemeMode.light 
                        : calc_settings.ThemeMode.dark;
                    themeProvider.updateThemeMode(newMode);
                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
           '${time.minute.toString().padLeft(2, '0')}';
  }
}