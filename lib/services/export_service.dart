// services/export_service.dart
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/calculation_history.dart';
import '../models/saved_calculation.dart';

class ExportService {
  static Future<String> exportHistoryToCSV(List<CalculationHistory> history) async {
    try {
      // Create CSV data
      List<List<dynamic>> csvData = [
        ['Expression', 'Result', 'Date', 'Time', 'Mode']
      ];

      for (final item in history) {
        final dateFormat = DateFormat('yyyy-MM-dd');
        final timeFormat = DateFormat('HH:mm:ss');
        
        csvData.add([
          item.expression,
          item.result,
          dateFormat.format(item.timestamp),
          timeFormat.format(item.timestamp),
          item.mode
        ]);
      }

      // Convert to CSV string
      String csvString = const ListToCsvConverter().convert(csvData);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/calculator_history_$timestamp.csv');
      await file.writeAsString(csvString);

      return file.path;
    } catch (e) {
      throw Exception('Failed to export history to CSV: $e');
    }
  }

  static Future<String> exportSavedCalculationsToCSV(List<SavedCalculation> calculations) async {
    try {
      // Create CSV data
      List<List<dynamic>> csvData = [
        ['Name', 'Expression', 'Result', 'Description', 'Category', 'Created', 'Modified', 'Favorite']
      ];

      for (final calc in calculations) {
        final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        
        csvData.add([
          calc.name,
          calc.expression,
          calc.result,
          calc.description ?? '',
          calc.category ?? '',
          dateFormat.format(calc.createdAt),
          dateFormat.format(calc.lastUsed),
          calc.isFavorite ? 'Yes' : 'No'
        ]);
      }

      // Convert to CSV string
      String csvString = const ListToCsvConverter().convert(csvData);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/saved_calculations_$timestamp.csv');
      await file.writeAsString(csvString);

      return file.path;
    } catch (e) {
      throw Exception('Failed to export saved calculations to CSV: $e');
    }
  }

  static Future<String> exportHistoryToPDF(List<CalculationHistory> history) async {
    try {
      final pdf = pw.Document();
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final now = DateTime.now();

      // Add pages to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // Header
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Calculator History Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              
              // Generated info
              pw.Paragraph(
                text: 'Generated on: ${dateFormat.format(now)}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),
              
              pw.Paragraph(
                text: 'Total calculations: ${history.length}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),
              
              pw.SizedBox(height: 20),

              // Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Expression', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Result', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Date & Time', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Mode', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  
                  // Data rows
                  ...history.map((item) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(item.expression),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(item.result),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(dateFormat.format(item.timestamp)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(item.mode),
                      ),
                    ],
                  )),
                ],
              ),
            ];
          },
        ),
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/calculator_history_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      throw Exception('Failed to export history to PDF: $e');
    }
  }

  static Future<String> exportSavedCalculationsToPDF(List<SavedCalculation> calculations) async {
    try {
      final pdf = pw.Document();
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final now = DateTime.now();

      // Add pages to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // Header
              pw.Header(
                level: 0,
                child: pw.Text(
                  'Saved Calculations Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              
              // Generated info
              pw.Paragraph(
                text: 'Generated on: ${dateFormat.format(now)}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),
              
              pw.Paragraph(
                text: 'Total saved calculations: ${calculations.length}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),
              
              pw.SizedBox(height: 20),

              // Calculations list
              ...calculations.map((calc) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 20),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Name and favorite status
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          calc.name,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (calc.isFavorite)
                          pw.Text(
                            '★',
                            style: const pw.TextStyle(
                              fontSize: 16,
                              color: PdfColors.amber,
                            ),
                          ),
                      ],
                    ),
                    
                    pw.SizedBox(height: 8),
                    
                    // Expression and result
                    pw.Text('Expression: ${calc.expression}'),
                    pw.Text('Result: ${calc.result}'),
                    
                    if (calc.description != null && calc.description!.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text('Description: ${calc.description}'),
                    ],
                    
                    if (calc.category != null && calc.category!.isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text('Category: ${calc.category}'),
                    ],
                    
                    pw.SizedBox(height: 8),
                    
                    // Dates
                    pw.Text(
                      'Created: ${dateFormat.format(calc.createdAt)}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                    ),
                    pw.Text(
                      'Last Used: ${dateFormat.format(calc.lastUsed)}',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                    ),
                  ],
                ),
              )),
            ];
          },
        ),
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/saved_calculations_$timestamp.pdf');
      await file.writeAsBytes(await pdf.save());

      return file.path;
    } catch (e) {
      throw Exception('Failed to export saved calculations to PDF: $e');
    }
  }

  static Future<List<String>> getExportedFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync()
          .where((file) => 
              file.path.contains('calculator_history_') || 
              file.path.contains('saved_calculations_'))
          .map((file) => file.path)
          .toList();
      
      return files;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> deleteExportedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}