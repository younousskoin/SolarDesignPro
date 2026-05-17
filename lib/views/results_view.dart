import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../domain/project.dart';
import '../theme.dart';
import '../widgets/ultra_premium_charts.dart';
import '../pages/architecture_page.dart';
import '../domain/system_type.dart';

class ResultsView extends StatelessWidget {
  final Project project;

  const ResultsView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final double dailyConsumption = project.totalDailyConsumptionKwh;
    final double annualProd = project.annualProduction;
    final double annualCons = project.annualConsumption;
    final double coverage = project.pvCoverage * 100;

    // 🔥 systemType est déjà un PVSystemType
    final PVSystemType system = project.systemType;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text("Résultats de la simulation"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.white.withOpacity(0.75)),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ---------------------------------------------------------
          // 🔷 RÉSUMÉ DU PROJET
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.whiteCard.copyWith(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.info, color: AppTheme.blueDeep),
                    SizedBox(width: 8),
                    Text(
                      "Résumé du projet",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  project.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "${project.location.city}, ${project.location.country}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.timelapse, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "Autonomie : ${project.realAutonomyDays.toStringAsFixed(1)} jours",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),

                Row(
                  children: [
                    const Icon(Icons.flash_on, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "Conso journalière : ${dailyConsumption.toStringAsFixed(2)} kWh/j",
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // 🔷 BILAN ÉNERGÉTIQUE
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.whiteCard.copyWith(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.bolt, color: AppTheme.blueDeep),
                    SizedBox(width: 8),
                    Text(
                      "Bilan énergétique",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _energyRow(
                  label: "Production annuelle",
                  value: "${annualProd.toStringAsFixed(0)} kWh/an",
                ),

                _energyRow(
                  label: "Consommation annuelle",
                  value: "${annualCons.toStringAsFixed(0)} kWh/an",
                ),

                _energyRow(
                  label: "Couverture PV",
                  value: "${coverage.toStringAsFixed(1)} %",
                ),

                _energyRow(
                  label: "Balance énergétique",
                  value: "${project.energyBalance.toStringAsFixed(0)} kWh/an",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // 🔥 ULTRA PREMIUM CHARTS
          // ---------------------------------------------------------
UltraPremiumCharts(
  monthlyProduction: project.monthlyProduction,
  monthlyConsumption: project.monthlyConsumption,
  pvPowerDaily: project.pvPowerDaily,
  socDaily: project.socDaily,
  surplusDaily: project.surplusDaily,
  deficitDaily: project.deficitDaily,
  batteryChargeDaily: project.batteryChargeDaily,
  batteryDischargeDaily: project.batteryDischargeDaily,
  inverterLoadDaily: project.inverterLoadDaily,
  pvHourly8760: project.pvHourly,
  socHourly8760: project.socHourly,

  // 🔥 NOUVEAU — OBLIGATOIRE
  hourlyConsumption: project.hourlyConsumption,
  ghi24h: project.ghi24h,
  temperature24h: project.temperature24h,
),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // 🔷 ANALYSE AUTOMATIQUE
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.whiteCard.copyWith(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.analytics, color: AppTheme.blueDeep),
                    SizedBox(width: 8),
                    Text(
                      "Analyse automatique",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _analysisLine(
                  icon: Icons.solar_power,
                  text:
                      "La production PV couvre ${(project.pvCoverage * 100).clamp(0, 100).toStringAsFixed(1)}% des besoins.",
                ),

                _analysisLine(
                  icon: Icons.battery_full,
                  text:
                      "Autonomie réelle : ${project.realAutonomyDays.toStringAsFixed(1)} jours.",
                ),

                _analysisLine(
                  icon: Icons.bolt,
                  text:
                      "Pertes globales du système : ${project.totalLossPercent.toStringAsFixed(1)}%.",
                ),

                if (project.energyBalance < 0)
                  _analysisLine(
                    icon: Icons.warning,
                    color: Colors.red,
                    text:
                        "Le système est sous-dimensionné de ${project.energyBalance.abs().toStringAsFixed(0)} kWh/an.",
                  ),

                if (project.energyBalance > 0)
                  _analysisLine(
                    icon: Icons.check_circle,
                    color: Colors.green,
                    text:
                        "Le système produit un surplus de ${project.energyBalance.toStringAsFixed(0)} kWh/an.",
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // 🔷 RECOMMANDATIONS
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.whiteCard.copyWith(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.tips_and_updates, color: AppTheme.blueDeep),
                    SizedBox(width: 8),
                    Text(
                      "Recommandations",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (project.pvCoverage < 0.9)
                  _recommendation(
                    "Augmenter la puissance PV de 10 à 20% pour améliorer la couverture.",
                  ),

                if (project.realAutonomyDays < project.autonomyDays)
                  _recommendation(
                    "Ajouter de la capacité batterie pour atteindre l’autonomie souhaitée.",
                  ),

                if (project.totalLossPercent > 25)
                  _recommendation(
                    "Optimiser l’orientation ou réduire les pertes (câbles, poussière, mismatch).",
                  ),

                if (project.energyBalance > 0)
                  _recommendation(
                    "Le système est surdimensionné : possibilité de réduire la puissance PV.",
                  ),

                _recommendation(
                  "Vérifier régulièrement l’état des batteries et du régulateur.",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // 🔷 ARCHITECTURE ÉLECTRIQUE
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.whiteCard.copyWith(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.account_tree, color: AppTheme.blueDeep),
                    SizedBox(width: 8),
                    Text(
                      "Architecture électrique",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _archLine("PV → Régulateur → Batterie → Onduleur → Charges"),

                if (system.requiresPump)
                  _archLine("PV → Régulateur → Batterie → Onduleur → Pompe"),

                if (!system.requiresBattery)
                  _archLine("PV → Onduleur → Charges (sans batterie)"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // 🔷 ACTIONS PRO
          // ---------------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.whiteCard.copyWith(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.workspace_premium, color: AppTheme.blueDeep),
                    SizedBox(width: 8),
                    Text(
                      "Actions PRO",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 🔹 Export PDF
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("Exporter en PDF (Premium)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.blueDeep,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("📄 Export PDF lancé (module premium)"),
                          backgroundColor: AppTheme.blueDeep,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // 🔹 Optimisation automatique
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text("Optimisation automatique"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.blueLight,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("⚙️ Optimisation automatique en cours..."),
                          backgroundColor: AppTheme.blueLight,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // 🔹 Simulation 8760h (PRO)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.timeline),
                    label: const Text("Simulation 8760h (PRO)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("📊 Simulation 8760h lancée (PRO)"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // 🔹 Voir l’architecture du système
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.account_tree),
                    label: const Text("Voir l’architecture du système"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.blueDeep,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArchitecturePage(
                            systemData: {
                              "project": project,
                              "image": system.imagePath,
                              "name": system.label,
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 WIDGETS UTILITAIRES
  // ---------------------------------------------------------

  Widget _energyRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _analysisLine({
    required IconData icon,
    required String text,
    Color color = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendation(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, color: AppTheme.blueDeep),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _archLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 10, color: AppTheme.blueDeep),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
