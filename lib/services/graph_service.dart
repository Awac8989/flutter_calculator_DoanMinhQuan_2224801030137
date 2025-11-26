// services/graph_service.dart
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import '../utils/expression_parser.dart';
import '../models/calculator_settings.dart';

class GraphPoint {
  final double x;
  final double y;

  const GraphPoint(this.x, this.y);
}

class GraphFunction {
  final String expression;
  final String variable;
  final double minX;
  final double maxX;
  final int samples;
  final AngleMode angleMode;

  const GraphFunction({
    required this.expression,
    this.variable = 'x',
    this.minX = -10.0,
    this.maxX = 10.0,
    this.samples = 1000,
    this.angleMode = AngleMode.radians,
  });
}

class GraphService {
  static List<GraphPoint> generateFunctionPoints(GraphFunction function) {
    final points = <GraphPoint>[];
    final step = (function.maxX - function.minX) / function.samples;

    for (int i = 0; i <= function.samples; i++) {
      final x = function.minX + (i * step);
      
      try {
        // Replace variable with actual value
        final expression = function.expression.replaceAll(function.variable, x.toString());
        final y = ExpressionParser.evaluate(expression, angleMode: function.angleMode);
        
        // Only add valid points
        if (y.isFinite) {
          points.add(GraphPoint(x, y));
        }
      } catch (e) {
        // Skip invalid points
      }
    }

    return points;
  }

  static List<FlSpot> convertToFlSpots(List<GraphPoint> points) {
    return points.map((point) => FlSpot(point.x, point.y)).toList();
  }

  static LineChartData createLineChartData(
    List<GraphPoint> points, {
    String title = 'Function Graph',
    bool showGrid = true,
    bool showAxis = true,
  }) {
    final spots = convertToFlSpots(points);
    
    if (spots.isEmpty) {
      return LineChartData(
        titlesData: FlTitlesData(show: false),
        lineBarsData: [],
        gridData: FlGridData(show: false),
      );
    }

    // Find min/max for scaling
    double minY = spots.first.y;
    double maxY = spots.first.y;
    double minX = spots.first.x;
    double maxX = spots.first.x;

    for (final spot in spots) {
      minY = math.min(minY, spot.y);
      maxY = math.max(maxY, spot.y);
      minX = math.min(minX, spot.x);
      maxX = math.max(maxX, spot.x);
    }

    // Add padding
    final yPadding = (maxY - minY) * 0.1;
    final xPadding = (maxX - minX) * 0.05;

    return LineChartData(
      minX: minX - xPadding,
      maxX: maxX + xPadding,
      minY: minY - yPadding,
      maxY: maxY + yPadding,
      
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: const Color(0xFF4285F4),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF4285F4).withOpacity(0.1),
          ),
        ),
      ],
      
      titlesData: FlTitlesData(
        show: showAxis,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: (maxX - minX) / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: (maxY - minY) / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
      ),
      
      gridData: FlGridData(
        show: showGrid,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xFFE0E0E0),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xFFE0E0E0),
            strokeWidth: 1,
          );
        },
      ),
      
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xFF424242), width: 2),
          left: BorderSide(color: Color(0xFF424242), width: 2),
        ),
      ),
    );
  }

  // Predefined common functions for quick plotting
  static Map<String, GraphFunction> get commonFunctions => {
    'Sine': const GraphFunction(
      expression: 'sin(x)',
      minX: -2 * math.pi,
      maxX: 2 * math.pi,
    ),
    'Cosine': const GraphFunction(
      expression: 'cos(x)',
      minX: -2 * math.pi,
      maxX: 2 * math.pi,
    ),
    'Tangent': const GraphFunction(
      expression: 'tan(x)',
      minX: -math.pi,
      maxX: math.pi,
    ),
    'Parabola': const GraphFunction(
      expression: 'x^2',
      minX: -5.0,
      maxX: 5.0,
    ),
    'Cubic': const GraphFunction(
      expression: 'x^3',
      minX: -3.0,
      maxX: 3.0,
    ),
    'Square Root': const GraphFunction(
      expression: 'sqrt(x)',
      minX: 0.0,
      maxX: 10.0,
    ),
    'Natural Log': const GraphFunction(
      expression: 'ln(x)',
      minX: 0.1,
      maxX: 10.0,
    ),
    'Exponential': const GraphFunction(
      expression: 'exp(x)',
      minX: -3.0,
      maxX: 3.0,
    ),
    'Reciprocal': const GraphFunction(
      expression: '1/x',
      minX: -10.0,
      maxX: 10.0,
    ),
  };

  static bool isValidFunction(String expression, {String variable = 'x'}) {
    try {
      // Test with a few sample values
      final testValues = [0.0, 1.0, -1.0, 2.5];
      
      for (final value in testValues) {
        final testExpression = expression.replaceAll(variable, value.toString());
        ExpressionParser.evaluate(testExpression);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  static String? validateFunctionExpression(String expression, {String variable = 'x'}) {
    if (expression.trim().isEmpty) {
      return 'Expression cannot be empty';
    }

    if (!expression.contains(variable)) {
      return 'Expression must contain the variable "$variable"';
    }

    if (!isValidFunction(expression, variable: variable)) {
      return 'Invalid mathematical expression';
    }

    return null; // No error
  }

  static List<GraphPoint> findCriticalPoints(GraphFunction function, {double tolerance = 1e-6}) {
    final points = generateFunctionPoints(function);
    final criticalPoints = <GraphPoint>[];

    for (int i = 1; i < points.length - 1; i++) {
      final prev = points[i - 1];
      final current = points[i];
      final next = points[i + 1];

      // Check for local maxima/minima
      final slope1 = (current.y - prev.y) / (current.x - prev.x);
      final slope2 = (next.y - current.y) / (next.x - current.x);

      if ((slope1 > 0 && slope2 < 0) || (slope1 < 0 && slope2 > 0)) {
        criticalPoints.add(current);
      }
    }

    return criticalPoints;
  }
}