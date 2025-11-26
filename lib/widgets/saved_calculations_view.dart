import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../models/saved_calculation.dart';
import '../utils/constants.dart';

class SavedCalculationsView extends StatefulWidget {
  const SavedCalculationsView({super.key});

  @override
  State<SavedCalculationsView> createState() => _SavedCalculationsViewState();
}

class _SavedCalculationsViewState extends State<SavedCalculationsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalculatorProvider, ThemeProvider>(
      builder: (context, calculator, themeProvider, child) {
        final isDark = themeProvider.isDarkMode;
        final calculations = calculator.savedCalculations
            .where((calc) => 
                calc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                calc.expression.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                (calc.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
            .toList();
        
        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: AppBar(
            title: const Text('Saved Calculations'),
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            foregroundColor: isDark ? Colors.white : Colors.black,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search calculations...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.darkSurface : Colors.white,
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),
            ),
          ),
          body: calculations.isEmpty 
              ? _buildEmptyState(isDark)
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: calculations.length,
                  itemBuilder: (context, index) {
                    return _buildCalculationCard(
                      context, 
                      calculations[index], 
                      calculator, 
                      isDark
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showSaveDialog(context, calculator),
            backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            child: const Icon(Icons.bookmark_add, color: Colors.white),
            tooltip: 'Save Current Calculation',
          ),
        );
      },
    );
  }

  Widget _buildCalculationCard(
    BuildContext context,
    SavedCalculation calculation, 
    CalculatorProvider calculator, 
    bool isDark
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          calculator.loadSavedCalculation(calculation);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loaded "${calculation.name}"'),
              duration: const Duration(seconds: 2),
              backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Leading icon
              CircleAvatar(
                backgroundColor: calculation.isFavorite 
                    ? Colors.red 
                    : (isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                child: Icon(
                  calculation.isFavorite ? Icons.favorite : Icons.calculate,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              
              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calculation.name,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${calculation.expression} = ${calculation.result}',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                    if (calculation.description?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        calculation.description!,
                        style: TextStyle(
                          color: isDark ? Colors.white60 : Colors.black45,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      'Saved ${_formatRelativeTime(calculation.createdAt)}',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                onSelected: (value) => _handleAction(context, value, calculation, calculator),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'load',
                    child: Row(
                      children: [
                        Icon(Icons.play_arrow, color: Colors.green), 
                        SizedBox(width: 8), 
                        Text('Load'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'favorite',
                    child: Row(
                      children: [
                        Icon(
                          calculation.isFavorite 
                              ? Icons.favorite_border 
                              : Icons.favorite,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(calculation.isFavorite ? 'Unfavorite' : 'Favorite'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue), 
                        SizedBox(width: 8), 
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red), 
                        SizedBox(width: 8), 
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: isDark ? Colors.white30 : Colors.black26,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved calculations yet',
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the bookmark icon to save calculations',
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black45,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    String action, 
    SavedCalculation calculation, 
    CalculatorProvider calculator
  ) {
    switch (action) {
      case 'load':
        calculator.loadSavedCalculation(calculation);
        Navigator.of(context).pop();
        break;
      case 'favorite':
        calculator.toggleCalculationFavorite(calculation.id);
        break;
      case 'edit':
        _showEditDialog(context, calculation, calculator);
        break;
      case 'delete':
        _showDeleteDialog(context, calculation, calculator);
        break;
    }
  }

  void _showSaveDialog(BuildContext context, CalculatorProvider calculator) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Calculation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter calculation name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add description',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                calculator.saveCurrentCalculation(
                  nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty 
                      ? null 
                      : descriptionController.text.trim(),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calculation saved!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    SavedCalculation calculation, 
    CalculatorProvider calculator
  ) {
    final nameController = TextEditingController(text: calculation.name);
    final descriptionController = TextEditingController(text: calculation.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Calculation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter calculation name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add description',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final updatedCalc = calculation.copyWith(
                  name: nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty 
                      ? null 
                      : descriptionController.text.trim(),
                );
                calculator.updateSavedCalculation(updatedCalc);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calculation updated!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    SavedCalculation calculation, 
    CalculatorProvider calculator
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Calculation'),
        content: Text('Delete "${calculation.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              calculator.deleteSavedCalculation(calculation.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calculation deleted!')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}