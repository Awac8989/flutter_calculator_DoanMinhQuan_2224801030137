// models/saved_calculation.dart
import 'calculation_history.dart';

class SavedCalculation {
  final String id;
  final String name;
  final String expression;
  final String result;
  final DateTime createdAt;
  final DateTime lastUsed;
  final bool isFavorite;
  final String? description;
  final String category;

  const SavedCalculation({
    required this.id,
    required this.name,
    required this.expression,
    required this.result,
    required this.createdAt,
    required this.lastUsed,
    this.isFavorite = false,
    this.description,
    this.category = 'General',
  });

  // Convert from CalculationHistory
  factory SavedCalculation.fromHistory(
    CalculationHistory history,
    String name, {
    String? description,
    String category = 'General',
  }) {
    return SavedCalculation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      expression: history.expression,
      result: history.result,
      createdAt: DateTime.now(),
      lastUsed: DateTime.now(),
      description: description,
      category: category,
    );
  }

  // Create copy with modifications
  SavedCalculation copyWith({
    String? id,
    String? name,
    String? expression,
    String? result,
    DateTime? createdAt,
    DateTime? lastUsed,
    bool? isFavorite,
    String? description,
    String? category,
  }) {
    return SavedCalculation(
      id: id ?? this.id,
      name: name ?? this.name,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'expression': expression,
      'result': result,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed.toIso8601String(),
      'isFavorite': isFavorite,
      'description': description,
      'category': category,
    };
  }

  factory SavedCalculation.fromJson(Map<String, dynamic> json) {
    return SavedCalculation(
      id: json['id'] as String,
      name: json['name'] as String,
      expression: json['expression'] as String,
      result: json['result'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsed: DateTime.parse(json['lastUsed'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'General',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedCalculation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SavedCalculation{id: $id, name: $name, expression: $expression, result: $result}';
  }
}