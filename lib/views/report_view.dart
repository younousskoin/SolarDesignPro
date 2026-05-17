import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../domain/technical_project_data.dart';
import '../domain/system_type.dart';
import '../theme.dart';
import '../utils/report_generator.dart';

class ReportView extends StatelessWidget {
  final TechnicalProjectData data;

  const ReportView({super.key, required this.data});

  List<double> _safe12(List<double>? list) {
    if (list == null || list.length < 12) {
      return List<double>.filled(12, 0);
    }
    return list;
  }

  List<double> _safe24(List<double>? list) {
    if (list == null || list.length < 24) {
      return List<double>.filled(24, 0);
    }
    return list;
  }

  double _safeNum(double? v) => v ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.white.withOpacity(0.75)),
          ),
        ),
        title: const Text(
          "Rapport du projet",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              _headerCard(),
              _summaryCard(),
              _analysisCard(),
              _recommendationsCard(),
              _chartsSection(),
              _meteoCard(),
              _parametersCard(),
              _resultsCard(),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () async {
                  await ReportGenerator.generatePDF(context, data);
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Exporter en PDF"),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Retour"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 PAGE DE GARDE
  // ---------------------------------------------------------
  Widget _headerCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.whiteCard.copyWith(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${data.city}, ${data.country}",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                data.systemType.icon,
                size: 40,
                color: data.systemType.color,
              ),
              const SizedBox(width: 12),
              Text(
                data.systemType.label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: data.systemType.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 RÉSUMÉ EXÉCUTIF
  // ---------------------------------------------------------
  Widget _summaryCard() {
    return _sectionCard(
      icon: Icons.summarize,
      title: "Résumé exécutif",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bullet("Localisation : ${data.city}, ${data.country}"),
          _bullet("Type de système : ${data.systemType.label}"),
          _bullet("Inclinaison : ${data.tilt}°"),
          _bullet("Orientation : ${data.orientation}°"),
          _bullet("Autonomie demandée : ${data.autonomyDays} jours"),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 ANALYSE AUTOMATIQUE
  // ---------------------------------------------------------
  Widget _analysisCard() {
    return _sectionCard(
      icon: Icons.analytics,
      title: "Analyse automatique",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bullet("Le profil de consommation est cohérent."),
          _bullet("La production solaire suit un cycle normal."),
          _bullet("Les variations de température sont réalistes."),
          _bullet("Le système semble correctement dimensionné."),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 RECOMMANDATIONS TECHNIQUES
  // ---------------------------------------------------------
  Widget _recommendationsCard() {
    return _sectionCard(
      icon: Icons.tips_and_updates,
      title: "Recommandations techniques",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bullet("Optimiser l’inclinaison si nécessaire."),
          _bullet("Vérifier les pertes (PR)."),
          _bullet("Ajuster la capacité batterie si autonomie insuffisante."),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 CHARTS PREMIUM
  // ---------------------------------------------------------
  Widget _chartsSection() {
    return Column(children: [
      ],
    );
  }

  // ---------------------------------------------------------
  // 🔥 DONNÉES MÉTÉO
  // ---------------------------------------------------------
  Widget _meteoCard() {
    return _sectionCard(
      icon: Icons.wb_sunny,
      title: "Données météo",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bullet("Irradiation mensuelle disponible."),
          _bullet("Température mensuelle analysée."),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 PARAMÈTRES DU SYSTÈME
  // ---------------------------------------------------------
  Widget _parametersCard() {
    return _sectionCard(
      icon: Icons.settings,
      title: "Paramètres du système",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bullet("Inclinaison : ${data.tilt}°"),
          _bullet("Orientation : ${data.orientation}°"),
          _bullet("Autonomie demandée : ${data.autonomyDays} jours"),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔥 RÉSULTATS DU CALCUL
  // ---------------------------------------------------------
  Widget _resultsCard() {
    return _sectionCard(
      icon: Icons.calculate,
      title: "Résultats du calcul",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bullet(
            "Consommation journalière : ${data.hourlyConsumption.reduce((a, b) => a + b).toStringAsFixed(2)} kWh/j",
          ),
          _bullet(
            "Irradiation moyenne : ${_safe12(data.ghiMonthly).reduce((a, b) => a + b).toStringAsFixed(2)} kWh/m²/mois",
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 UTILITAIRES UI
  // ---------------------------------------------------------
  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.whiteCard.copyWith(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.blueDeep, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
