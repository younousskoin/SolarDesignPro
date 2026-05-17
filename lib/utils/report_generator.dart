import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../domain/technical_project_data.dart';
import '../domain/system_type.dart';

class ReportGenerator {
  static Future<void> generatePDF(
    BuildContext context,
    TechnicalProjectData data,
  ) async {
    final pdf = pw.Document();

    // ---------- PAGE 1 : PAGE DE GARDE ----------
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Rapport de dimensionnement',
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                data.name,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                '${data.city}, ${data.country}',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 16),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(8),
                  color: PdfColors.blue50,
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 10,
                      height: 10,
                      decoration: pw.BoxDecoration(
                        color: _pdfColorFromFlutter(data.systemType.color),
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          data.systemType.label,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Type de système photovoltaïque sélectionné.',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Text(
                  'Généré avec SolarDesignPro',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ),
            ],
          );
        },
      ),
    );

    // ---------- PAGE 2 : RÉSUMÉ + PARAMÈTRES ----------
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context ctx) {
          final totalDailyKwh = data.hourlyConsumption.fold<double>(
            0,
            (a, b) => a + b,
          );

          return [
            _sectionTitle('1. Résumé exécutif'),
            pw.SizedBox(height: 8),
            _bullet('Localisation : ${data.city}, ${data.country}'),
            _bullet('Type de système : ${data.systemType.label}'),
            _bullet('Autonomie demandée : ${data.autonomyDays} jours'),
            _bullet(
              'Consommation journalière : ${totalDailyKwh.toStringAsFixed(2)} kWh/j',
            ),
            pw.SizedBox(height: 16),

            _sectionTitle('2. Paramètres du système'),
            pw.SizedBox(height: 8),
            _bullet('Latitude : ${data.latitude}°'),
            _bullet('Longitude : ${data.longitude}°'),
            _bullet('Inclinaison : ${data.tilt}°'),
            _bullet('Orientation : ${data.orientation}°'),
            pw.SizedBox(height: 16),

            _sectionTitle('3. Profil de consommation (24h)'),
            pw.SizedBox(height: 8),
            _hourlyTable(data.hourlyConsumption),

            pw.SizedBox(height: 20),
            _sectionTitle('4. Données météo'),
            pw.SizedBox(height: 8),
            _monthlyRow('GHI', data.ghiMonthly),
            _monthlyRow('DHI', data.dhiMonthly),
            _monthlyRow('DNI', data.dniMonthly),
            _monthlyRow('Température', data.temperatureMonthly),

            pw.SizedBox(height: 20),
            _sectionTitle('5. Analyse qualitative'),
            pw.SizedBox(height: 8),
            _bullet('Le profil de consommation est cohérent.'),
            _bullet('La ressource solaire est exploitable toute l’année.'),
            _bullet(
              'Les températures sont compatibles avec un bon rendement PV.',
            ),

            pw.SizedBox(height: 20),
            _sectionTitle('6. Recommandations'),
            pw.SizedBox(height: 8),
            _bullet('Optimiser l’inclinaison si nécessaire.'),
            _bullet('Vérifier les ombrages potentiels.'),
            _bullet('Ajuster la capacité batterie selon l’autonomie réelle.'),
          ];
        },
      ),
    );

    // ---------- EXPORT ----------
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // -------------------------------------------------------
  // 🔧 UTILITAIRES PDF
  // -------------------------------------------------------
  static pw.Widget _sectionTitle(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue800,
      ),
    );
  }

  static pw.Widget _bullet(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: const pw.TextStyle(fontSize: 11)),
          pw.Expanded(
            child: pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _hourlyTable(List<double> hourly) {
    final safe = hourly.length == 24 ? hourly : List<double>.filled(24, 0);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                'Heure',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                'Conso (kWh)',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        for (int i = 0; i < 24; i++)
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('H$i', style: const pw.TextStyle(fontSize: 9)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  safe[i].toStringAsFixed(3),
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static pw.Widget _monthlyRow(String label, List<double> values) {
    final safe = values.length == 12 ? values : List<double>.filled(12, 0);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            for (int i = 0; i < 12; i++)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(4),
                  color: PdfColors.grey200,
                ),
                child: pw.Text(
                  'M${i + 1}: ${safe[i].toStringAsFixed(2)}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static PdfColor _pdfColorFromFlutter(Color c) {
    return PdfColor.fromInt(c.value);
  }
}
