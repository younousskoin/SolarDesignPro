// ---------------------------------------------------------
// PdfService — Version PRO commentée (B2‑LITE)
// ---------------------------------------------------------
// Ce fichier génère un rapport PDF professionnel complet
// pour un projet photovoltaïque :
// - Page de garde
// - Sommaire
// - Bilan énergétique
// - Configuration système
// - Analyse automatique
// - Graphiques mensuels
// - Courbes PV & SOC
// - Simulation 8760h
// - Optimisation automatique
// - Architecture électrique
// - Annexes techniques PRO
// - Signature
// ---------------------------------------------------------

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/project.dart';
import '../domain/system_type.dart';

// ---------------------------------------------------------
// Fonction utilitaire : conversion enum → texte lisible
// ---------------------------------------------------------
String systemTypeLabel(PVSystemType type) {
  switch (type) {
    case PVSystemType.offGrid:
      return "Système isolé";
    case PVSystemType.onGrid:
      return "Raccordé réseau";
    case PVSystemType.hybrid:
      return "Système hybride";
    case PVSystemType.directUse:
      return "Pompage direct";
    case PVSystemType.pumpingWithStorage:
      return "Pompage + stockage";
  }
}

// ---------------------------------------------------------
// Classe principale : PdfService
// ---------------------------------------------------------
class PdfService {
  static Future<Uint8List> buildProjectReport(Project project) async {
    // Le document PDF
    final pdf = pw.Document();

    // Chargement du logo
    final logoBytes = await rootBundle.load('assets/logo/solardesignpro.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    // -----------------------------------------------------
    // PAGE DE GARDE
    // -----------------------------------------------------
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => _buildCoverPage(project, logoImage),
      ),
    );

    // -----------------------------------------------------
    // CONTENU MULTIPAGE
    // -----------------------------------------------------
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (_) => [
          // En‑tête
          _buildHeader(project, logoImage),
          pw.SizedBox(height: 16),
          pw.Divider(),

          // Sommaire
          _buildTableOfContents(),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Bilan énergétique
          _buildEnergySection(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Configuration système
          _buildConfigSection(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Analyse automatique
          _buildAnalysisSection(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Graphique mensuel
          _buildMonthlyChart(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Courbe PV
          _buildPvCurve(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Courbe SOC
          _buildSocCurve(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Simulation 8760h
          _build8760Section(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Optimisation automatique
          _buildOptimizationSection(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Architecture électrique
          _buildElectricalArchitecture(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Annexes techniques PRO
          _buildTechnicalAnnexes(project),
          pw.SizedBox(height: 20),
          pw.Divider(),

          // Signature
          _buildSignature(project),
        ],
      ),
    );

    return pdf.save();
  }

  // ---------------------------------------------------------
  // TITRE DE SECTION (bandeau bleu)
  // ---------------------------------------------------------
  static pw.Widget _sectionTitle(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [PdfColors.blue100, PdfColors.white],
        ),
      ),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }
  // ---------------------------------------------------------
  // PAGE DE GARDE
  // ---------------------------------------------------------
  static pw.Widget _buildCoverPage(Project project, pw.MemoryImage logo) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(32),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Image(logo, width: 120),
          pw.SizedBox(height: 30),

          pw.Text(
            "Rapport de dimensionnement photovoltaïque",
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),

          pw.SizedBox(height: 40),

          // Encadré gris contenant les infos du projet
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey200,
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Projet : ${project.name}",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),

                pw.Text("Lieu : ${project.location.city}, ${project.location.country}",
                    style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 8),

                pw.Text("Type de système : ${systemTypeLabel(project.systemType)}",
                    style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 8),

                pw.Text("Date : ${DateTime.now().toLocal().toString().split(' ')[0]}",
                    style: const pw.TextStyle(fontSize: 16)),
              ],
            ),
          ),

          pw.Spacer(),

          // Bande bleue en bas
          pw.Container(height: 6, width: double.infinity, color: PdfColors.blue),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SOMMAIRE
  // ---------------------------------------------------------
  static pw.Widget _buildTableOfContents() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Sommaire",
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),

        // Liste des sections
        pw.Bullet(text: "1. Page de garde"),
        pw.Bullet(text: "2. Sommaire"),
        pw.Bullet(text: "3. Bilan énergétique"),
        pw.Bullet(text: "4. Configuration du système"),
        pw.Bullet(text: "5. Analyse automatique"),
        pw.Bullet(text: "6. Graphique mensuel"),
        pw.Bullet(text: "7. Courbes PV (24h)"),
        pw.Bullet(text: "8. Courbe SOC (24h)"),
        pw.Bullet(text: "9. Simulation 8760h"),
        pw.Bullet(text: "10. Optimisation automatique"),
        pw.Bullet(text: "11. Architecture électrique"),
        pw.Bullet(text: "12. Annexes techniques"),
        pw.Bullet(text: "13. Signature"),
      ],
    );
  }

  // ---------------------------------------------------------
  // HEADER (titre + localisation + logo)
  // ---------------------------------------------------------
  static pw.Widget _buildHeader(Project project, pw.MemoryImage logo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('SolarDesignPro',
                style: pw.TextStyle(
                    fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),

            pw.Text(project.name, style: const pw.TextStyle(fontSize: 12)),
            pw.Text("${project.location.city}, ${project.location.country}",
                style: const pw.TextStyle(fontSize: 11)),
          ],
        ),

        pw.SizedBox(height: 40, width: 40, child: pw.Image(logo)),
      ],
    );
  }

  // ---------------------------------------------------------
  // BILAN ÉNERGÉTIQUE
  // ---------------------------------------------------------
  static pw.Widget _buildEnergySection(Project project) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Bilan énergétique"),
        pw.SizedBox(height: 10),

        pw.Bullet(text: "Production annuelle : ${project.annualProduction.toStringAsFixed(0)} kWh/an"),
        pw.Bullet(text: "Consommation annuelle : ${project.annualConsumption.toStringAsFixed(0)} kWh/an"),
        pw.Bullet(text: "Bilan énergétique : ${project.energyBalance.toStringAsFixed(0)} kWh/an"),
        pw.Bullet(text: "Taux de couverture PV : ${(project.pvCoverage * 100).toStringAsFixed(1)} %"),
        pw.Bullet(text: "Autonomie réelle : ${project.realAutonomyDays.toStringAsFixed(1)} jours"),
        pw.Bullet(text: "Performance Ratio (PR) : ${(project.pr * 100).toStringAsFixed(1)} %"),
      ],
    );
  }

  // ---------------------------------------------------------
  // CONFIGURATION DU SYSTÈME
  // ---------------------------------------------------------
  static pw.Widget _buildConfigSection(Project project) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Configuration du système"),
        pw.SizedBox(height: 10),

        pw.Bullet(text: "Puissance PV : ${project.resultPvPower.toStringAsFixed(2)} kWc (${project.resultPanelCount} panneaux)"),
        pw.Bullet(text: "Capacité batterie : ${project.resultBatteryCapacity.toStringAsFixed(0)} Ah"),
        pw.Bullet(text: "Puissance onduleur : ${project.resultInverterPower.toStringAsFixed(0)} W"),
        pw.Bullet(text: "Courant régulateur : ${project.resultRegulatorCurrent.toStringAsFixed(0)} A"),
      ],
    );
  }

  // ---------------------------------------------------------
  // ANALYSE AUTOMATIQUE
  // ---------------------------------------------------------
  static pw.Widget _buildAnalysisSection(Project project) {
    final comments = <String>[];

    // Analyse couverture PV
    if (project.pvCoverage < 0.6) {
      comments.add("La couverture PV est insuffisante (${(project.pvCoverage * 100).toStringAsFixed(1)} %).");
    } else if (project.pvCoverage > 1.0) {
      comments.add("La production PV dépasse largement la consommation.");
    } else {
      comments.add("La couverture PV est équilibrée.");
    }

    // Analyse bilan énergétique
    if (project.energyBalance < 0) {
      comments.add("Le bilan énergétique est déficitaire (${project.energyBalance.toStringAsFixed(0)} kWh/an).");
    } else {
      comments.add("Le bilan énergétique est excédentaire (${project.energyBalance.toStringAsFixed(0)} kWh/an).");
    }

    // Analyse PR
    if (project.pr < 0.7) {
      comments.add("Le PR est faible (${(project.pr * 100).toStringAsFixed(1)} %).");
    } else if (project.pr > 0.85) {
      comments.add("Le PR est excellent (${(project.pr * 100).toStringAsFixed(1)} %).");
    } else {
      comments.add("Le PR est correct (${(project.pr * 100).toStringAsFixed(1)} %).");
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Analyse automatique"),
        pw.SizedBox(height: 10),

        ...comments.map((c) => pw.Bullet(text: c)).toList(),
      ],
    );
  }
  
  // ---------------------------------------------------------
  // GRAPHIQUE MENSUEL (Production vs Consommation)
  // ---------------------------------------------------------
  static pw.Widget _buildMonthlyChart(Project project) {
    final prod = project.monthlyProduction;
    final cons = project.monthlyConsumption;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Production vs Consommation (Mensuel)"),
        pw.SizedBox(height: 12),

        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Container(
            height: 220,
            child: pw.Chart(
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                  ["Jan","Fév","Mar","Avr","Mai","Jun","Jul","Aoû","Sep","Oct","Nov","Déc"],
                  marginStart: 30,
                  marginEnd: 30,
                ),
                yAxis: pw.FixedAxis(
                  [0,100,200,300,400,500,600],
                  format: (v) => "$v kWh",
                ),
              ),

              datasets: [
                // Production PV
                pw.LineDataSet(
                  drawPoints: true,
                  isCurved: true,
                  color: PdfColors.blue,
                  data: List.generate(
                    12,
                    (i) => pw.PointChartValue(i.toDouble(), prod[i]),
                  ),
                ),

                // Consommation
                pw.LineDataSet(
                  drawPoints: true,
                  isCurved: true,
                  color: PdfColors.orange,
                  data: List.generate(
                    12,
                    (i) => pw.PointChartValue(i.toDouble(), cons[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // COURBE PV (24h)
  // ---------------------------------------------------------
  static pw.Widget _buildPvCurve(Project project) {
    final data = project.pvPowerDaily;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Courbe de production PV (24h)"),
        pw.SizedBox(height: 12),

        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Container(
            height: 180,
            child: pw.Chart(
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                  List.generate(24, (i) => "$i h"),
                ),
                yAxis: pw.FixedAxis([0,200,400,600,800,1000]),
              ),

              datasets: [
                pw.LineDataSet(
                  drawPoints: true,
                  isCurved: true,
                  color: PdfColors.blue,
                  data: List.generate(
                    data.length,
                    (i) => pw.PointChartValue(i.toDouble(), data[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // COURBE SOC (24h)
  // ---------------------------------------------------------
  static pw.Widget _buildSocCurve(Project project) {
    final soc = project.socDaily;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Courbe SOC batterie (24h)"),
        pw.SizedBox(height: 12),

        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Container(
            height: 180,
            child: pw.Chart(
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                  List.generate(24, (i) => "$i h"),
                ),
                yAxis: pw.FixedAxis([0,20,40,60,80,100]),
              ),

              datasets: [
                pw.LineDataSet(
                  drawPoints: true,
                  isCurved: true,
                  color: PdfColors.green,
                  data: List.generate(
                    soc.length,
                    (i) => pw.PointChartValue(i.toDouble(), soc[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // ---------------------------------------------------------
  // SIMULATION 8760h (PRO)
  // ---------------------------------------------------------
  static pw.Widget _build8760Section(Project project) {
    final sim = project.simulation8760;

    // Si aucune simulation n'a été exécutée
    if (sim == null || sim.states.isEmpty) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle("Simulation 8760h"),
          pw.SizedBox(height: 12),
          pw.Text("Aucune simulation 8760h n’a été exécutée."),
        ],
      );
    }

       // Extraction des données horaires
    final pv = sim.states.map((e) => e.pvPower / 1000).toList(); // kW
    final soc = sim.states.map((e) => e.batterySoc).toList();    // %

    // ---------------------------------------------------------
    // Calcul des moyennes journalières (8760h → 365 points)
    // ---------------------------------------------------------
    final pvDaily = <double>[];
    final socDaily = <double>[];

    for (int d = 0; d < 365; d++) {
      final start = d * 24;
      final end = start + 24;

      pvDaily.add(
        pv.sublist(start, end).reduce((a, b) => a + b) / 24,
      );

      socDaily.add(
        soc.sublist(start, end).reduce((a, b) => a + b) / 24,
      );
    }

    // ---------------------------------------------------------
    // Construction de la section PDF
    // ---------------------------------------------------------
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Simulation 8760h — Analyse annuelle"),
        pw.SizedBox(height: 16),

        // ---------------- STATISTIQUES ----------------
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.blue),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Statistiques principales",
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Bullet(text: "Production PV totale : ${sim.totalPvEnergy.toStringAsFixed(0)} kWh/an"),
              pw.Bullet(text: "Consommation totale : ${sim.totalLoadEnergy.toStringAsFixed(0)} kWh/an"),
              pw.Bullet(text: "Énergie non servie : ${sim.unmetLoadEnergy.toStringAsFixed(1)} kWh/an"),
              pw.Bullet(text: "SOC minimum : ${sim.minSoc.toStringAsFixed(1)} %"),
              pw.Bullet(text: "SOC maximum : ${sim.maxSoc.toStringAsFixed(1)} %"),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ---------------- COURBE PV ANNUELLE ----------------
        pw.Text(
          "Production PV — Profil annuel (8760h compressé)",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),

        pw.Container(
          height: 180,
          child: pw.Chart(
            grid: pw.CartesianGrid(
              xAxis: pw.FixedAxis(
                List.generate(12, (i) => i * 30),
                format: (v) => "${(v / 30).round()}",
              ),
              yAxis: pw.FixedAxis(
                [0, 0.2, 0.4, 0.6, 0.8, 1.0],
                format: (v) => "${(v * 1000).round()} W",
              ),
            ),
            datasets: [
              pw.LineDataSet(
                drawPoints: false,
                isCurved: true,
                color: PdfColors.blue,
                data: List.generate(
                  pvDaily.length,
                  (i) => pw.PointChartValue(i.toDouble(), pvDaily[i]),
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ---------------- COURBE SOC ANNUELLE ----------------
        pw.Text(
          "État de charge batterie — Profil annuel (8760h compressé)",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.green900,
          ),
        ),
        pw.SizedBox(height: 10),

        pw.Container(
          height: 180,
          child: pw.Chart(
            grid: pw.CartesianGrid(
              xAxis: pw.FixedAxis(
                List.generate(12, (i) => i * 30),
                format: (v) => "${(v / 30).round()}",
              ),
              yAxis: pw.FixedAxis(
                [0, 20, 40, 60, 80, 100],
                format: (v) => "$v%",
              ),
            ),
            datasets: [
              pw.LineDataSet(
                drawPoints: false,
                isCurved: true,
                color: PdfColors.green,
                data: List.generate(
                  socDaily.length,
                  (i) => pw.PointChartValue(i.toDouble(), socDaily[i]),
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ---------------- ANALYSE AUTOMATIQUE ----------------
        pw.Text(
          "Analyse automatique 8760h",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),

        ..._build8760Analysis(sim),
      ],
    );
  }

  // ---------------------------------------------------------
  // ANALYSE AUTOMATIQUE 8760h (commentée)
  // ---------------------------------------------------------
  static List<pw.Widget> _build8760Analysis(dynamic sim) {
    final comments = <String>[];

    // Charge non servie
    if (sim.unmetLoadEnergy > 0) {
      comments.add(
        "⚠ Le système n’a pas pu couvrir toute la charge : ${sim.unmetLoadEnergy.toStringAsFixed(1)} kWh non servis.",
      );
    } else {
      comments.add("✔ Toute la charge a été couverte sur l’année.");
    }

    // SOC trop bas
    if (sim.minSoc < 20) {
      comments.add(
        "⚠ Le SOC descend très bas (${sim.minSoc.toStringAsFixed(1)} %). Risque de décharge profonde.",
      );
    } else {
      comments.add("✔ Le SOC reste dans une zone acceptable.");
    }

    // Production insuffisante
    if (sim.totalPvEnergy < sim.totalLoadEnergy) {
      comments.add(
        "⚠ La production PV annuelle est insuffisante pour couvrir la consommation.",
      );
    } else {
      comments.add("✔ La production PV annuelle couvre la consommation.");
    }

    return comments.map((c) => pw.Bullet(text: c)).toList();
  }

  // ---------------------------------------------------------
  // OPTIMISATION AUTOMATIQUE (VERSION PRO)
  // ---------------------------------------------------------
  // Cette section compare la configuration actuelle du projet
  // avec une configuration optimisée (si l'utilisateur a lancé
  // l'optimisation). Elle affiche :
  // - les améliorations (couverture PV, autonomie, pertes…)
  // - les composants optimaux sélectionnés
  // - un score global d’optimisation
  // ---------------------------------------------------------
  static pw.Widget _buildOptimizationSection(Project project) {
    final opt = project.optimizationResult;

    // Si aucune optimisation n'a été exécutée
    if (opt == null) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _sectionTitle("Optimisation automatique"),
          pw.SizedBox(height: 12),
          pw.Text("Aucune optimisation n’a été exécutée."),
        ],
      );
    }

    // Si optimisation disponible → affichage complet
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Optimisation automatique — Résultats PRO"),
        pw.SizedBox(height: 16),

        // ---------------- COMPARAISON AVANT / APRÈS ----------------
        pw.Text(
          "Comparaison avant / après optimisation",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),

        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.blue),
          ),
          child: pw.Column(
            children: [
              _optRow(
                "Couverture PV",
                "${(project.pvCoverage * 100).toStringAsFixed(1)} %",
                "${(opt.coverage * 100).toStringAsFixed(1)} %",
              ),
              _optRow(
                "Autonomie réelle",
                "${project.realAutonomyDays.toStringAsFixed(1)} j",
                "${opt.autonomy.toStringAsFixed(1)} j",
              ),
              _optRow(
                "Pertes globales",
                "${project.totalLossPercent.toStringAsFixed(1)} %",
                "${opt.losses.toStringAsFixed(1)} %",
              ),
              _optRow(
                "Bilan énergétique",
                "${project.energyBalance.toStringAsFixed(0)} kWh/an",
                "${opt.energyBalance.toStringAsFixed(0)} kWh/an",
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ---------------- COMPOSANTS OPTIMAUX ----------------
        pw.Text(
          "Composants optimaux sélectionnés",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),

        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Bullet(text: "Panneau : ${opt.panel.name} (${opt.panel.power} W)"),
              pw.Bullet(text: "Batterie : ${opt.battery.name} (${opt.battery.capacity} Ah)"),
              pw.Bullet(text: "Onduleur : ${opt.inverter.name} (${opt.inverter.power} W)"),
              pw.Bullet(text: "Régulateur : ${opt.regulator.name} (${opt.regulator.current} A)"),
              if (opt.pump != null)
                pw.Bullet(text: "Pompe : ${opt.pump!.name} (${opt.pump!.power} W)"),
            ],
          ),
        ),

        pw.SizedBox(height: 20),

        // ---------------- ANALYSE AUTOMATIQUE ----------------
        pw.Text(
          "Analyse automatique",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),

        ..._buildOptimizationAnalysis(project, opt),
      ],
    );
  }

  // ---------------------------------------------------------
  // Ligne de comparaison avant/après optimisation
  // ---------------------------------------------------------
  static pw.Widget _optRow(String label, String before, String after) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(child: pw.Text(label)),
          pw.Text(before, style: pw.TextStyle(color: PdfColors.grey700)),
          pw.Text(" → "),
          pw.Text(after, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Analyse automatique de l’optimisation
  // ---------------------------------------------------------
  static List<pw.Widget> _buildOptimizationAnalysis(Project project, dynamic opt) {
    final comments = <String>[];

    if (opt.coverage > project.pvCoverage) {
      comments.add("✔ La couverture PV a été améliorée.");
    } else {
      comments.add("ℹ La couverture PV reste similaire.");
    }

    if (opt.autonomy > project.realAutonomyDays) {
      comments.add("✔ L’autonomie batterie a été augmentée.");
    }

    if (opt.losses < project.totalLossPercent) {
      comments.add("✔ Les pertes globales ont été réduites.");
    }

    if (opt.energyBalance > project.energyBalance) {
      comments.add("✔ Le bilan énergétique est meilleur.");
    }

    comments.add("Score global optimisation : ${opt.score.toStringAsFixed(1)}");

    return comments.map((c) => pw.Bullet(text: c)).toList();
  }

  // ---------------------------------------------------------
  // ARCHITECTURE ÉLECTRIQUE (SCHÉMA FONCTIONNEL)
  // ---------------------------------------------------------
  // Cette section affiche un schéma simple et lisible du système :
  // PV → Régulateur → Batteries → Onduleur → Charges
  // Et un schéma additionnel si le système inclut une pompe.
  // ---------------------------------------------------------
  static pw.Widget _buildElectricalArchitecture(Project project) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Architecture électrique — Schéma fonctionnel"),
        pw.SizedBox(height: 16),

        pw.Text(
          "Schéma simplifié du système",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 12),

        // ---------------- SCHÉMA PRINCIPAL ----------------
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.grey400),
          ),
          child: pw.Column(
            children: [
              _schemaBox("Panneaux PV"),
              _schemaArrow(),
              _schemaBox("Régulateur de charge"),
              _schemaArrow(),
              _schemaBox("Batteries"),
              _schemaArrow(),
              _schemaBox("Onduleur"),
              _schemaArrow(),
              _schemaBox("Charges AC"),
            ],
          ),
        ),

        // ---------------- SCHÉMA POMPAGE ----------------
        if (project.systemType.requiresPump) ...[
          pw.SizedBox(height: 20),

          pw.Text(
            "Schéma additionnel — Pompage",
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 12),

          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.grey400),
            ),
            child: pw.Column(
              children: [
                _schemaBox("Panneaux PV"),
                _schemaArrow(),
                _schemaBox("Régulateur MPPT"),
                _schemaArrow(),
                _schemaBox("Pompe DC"),
              ],
            ),
          ),
        ],
      ],
    );
  }
  // ---------------------------------------------------------
  // ANNEXES TECHNIQUES (VERSION PRO)
  // ---------------------------------------------------------
  // Cette section regroupe toutes les données techniques
  // nécessaires pour un rapport professionnel :
  // - Paramètres du panneau PV
  // - Pertes détaillées
  // - Performance Ratio (PR)
  // - Formules utilisées
  // ---------------------------------------------------------
  static pw.Widget _buildTechnicalAnnexes(Project project) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle("Annexes techniques"),
        pw.SizedBox(height: 16),

        // ---------------- PARAMÈTRES PV ----------------
        pw.Text(
          "Paramètres PV",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(text: "Puissance nominale : ${project.selectedPanel?.power} W"),
        pw.Bullet(text: "Voc : ${project.selectedPanel?.voc} V"),
        pw.Bullet(text: "Vmp : ${project.selectedPanel?.vmp} V"),
        pw.Bullet(text: "Isc : ${project.selectedPanel?.isc} A"),
        pw.Bullet(text: "Imp : ${project.selectedPanel?.imp} A"),
        pw.Bullet(text: "NOCT : ${project.selectedPanel?.noct} °C"),

        pw.SizedBox(height: 20),

        // ---------------- PERTES ----------------
        pw.Text(
          "Pertes du système",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(text: "Pertes câbles : ${project.lossCable.toStringAsFixed(1)} %"),
        pw.Bullet(text: "Pertes température : ${project.lossTemp.toStringAsFixed(1)} %"),
        pw.Bullet(text: "Pertes mismatch : ${project.lossMismatch.toStringAsFixed(1)} %"),
        pw.Bullet(text: "Pertes poussière : ${project.lossDirt.toStringAsFixed(1)} %"),
        pw.Bullet(text: "Pertes régulateur : ${project.lossRegulator.toStringAsFixed(1)} %"),
        pw.Bullet(text: "Pertes onduleur : ${project.lossInverter.toStringAsFixed(1)} %"),

        pw.SizedBox(height: 20),

        // ---------------- PR ----------------
        pw.Text(
          "Performance Ratio (PR) — Détail",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(text: "PR global : ${(project.pr * 100).toStringAsFixed(1)} %"),
        pw.Bullet(text: "PR thermique : ${(project.prThermal * 100).toStringAsFixed(1)} %"),
        pw.Bullet(text: "PR électrique : ${(project.prElectrical * 100).toStringAsFixed(1)} %"),

        pw.SizedBox(height: 20),

        // ---------------- FORMULES ----------------
        pw.Text(
          "Méthodologie et formules utilisées",
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(text: "Production PV : P = G × Pnom × PR"),
        pw.Bullet(text: "Température cellule : Tcell = Tair + (G/800) × (NOCT − 20)"),
        pw.Bullet(text: "SOC batterie : SOC = (Énergie / Capacité utile) × 100"),
        pw.Bullet(text: "Bilan énergétique : Production − Consommation"),
        pw.Bullet(text: "Autonomie : Capacité batterie / Consommation journalière"),
      ],
    );
  }

  // ---------------------------------------------------------
  // SIGNATURE
  // ---------------------------------------------------------
  // Section finale du rapport : signature de l’ingénieur.
  // ---------------------------------------------------------
  static pw.Widget _buildSignature(Project project) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Signature de l’ingénieur",
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),

        pw.Text("Ingénieur responsable : .............................",
            style: const pw.TextStyle(fontSize: 14)),
        pw.SizedBox(height: 8),

        pw.Text("SolarDesignPro – Département R&D",
            style: const pw.TextStyle(fontSize: 14)),
        pw.SizedBox(height: 30),

        pw.Text("Signature :", style: const pw.TextStyle(fontSize: 14)),
        pw.SizedBox(height: 40),

        pw.Container(height: 1, width: 200, color: PdfColors.black),
      ],
    );
  }

  // ---------------------------------------------------------
  // UTILITAIRES SCHÉMA (boîtes + flèches)
  // ---------------------------------------------------------
  // Ces fonctions servent à dessiner les blocs du schéma
  // électrique (PV → régulateur → batteries → onduleur → charges)
  // ---------------------------------------------------------
  static pw.Widget _schemaBox(String label) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      margin: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.blue),
      ),
      child: pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  static pw.Widget _schemaArrow() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        "↓",
        style: pw.TextStyle(fontSize: 18),
      ),
    );
  }

} // ← FIN DE LA CLASSE PdfService
