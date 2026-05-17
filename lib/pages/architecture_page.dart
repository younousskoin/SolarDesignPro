import 'package:flutter/material.dart';
import '../domain/project.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';



class ArchitecturePage extends StatelessWidget {
  final Map<String, dynamic> systemData;

  const ArchitecturePage({super.key, required this.systemData});

  @override
  Widget build(BuildContext context) {
    final Project project = systemData["project"];
    final String imagePath = systemData["image"];
    final String name = systemData["name"];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      // ---------------------------------------------------------
      // 🔷 APPBAR GLASS PREMIUM
      // ---------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text("Architecture du système", style: AppTypography.h2),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: ListView(
            children: [
              // ---------------------------------------------------------
              // 🔷 TITRE PRINCIPAL
              // ---------------------------------------------------------
              Text(name, style: AppTypography.h1),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 IMAGE PRINCIPALE DU SYSTÈME
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 COMPOSANTS UTILISÉS
              // ---------------------------------------------------------
              _sectionTitle("Composants du système"),

              _glassLine("Panneaux photovoltaïques", project.selectedPanel?.name ?? "—"),
              _glassLine("Batterie", project.selectedBattery?.name ?? "—"),
              _glassLine("Onduleur", project.selectedInverter?.name ?? "—"),
              _glassLine("Régulateur", project.selectedRegulator?.name ?? "—"),

              if (project.selectedPump != null)
                _glassLine("Pompe", project.selectedPump!.name),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 DONNÉES PV
              // ---------------------------------------------------------
              _sectionTitle("Données PV"),

              _glassLine("Puissance PV installée", "${project.resultPvPower.toStringAsFixed(2)} kWc"),
              _glassLine("Nombre de panneaux", "${project.resultPanelCount}"),
              _glassLine("Production annuelle", "${project.annualProduction.toStringAsFixed(0)} kWh/an"),
              _glassLine("Taux de couverture PV", "${(project.pvCoverage * 100).toStringAsFixed(1)} %"),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 DONNÉES BATTERIE
              // ---------------------------------------------------------
              if (project.selectedBattery != null) ...[
                _sectionTitle("Stockage (batterie)"),
                _glassLine("Capacité utile", "${project.resultBatteryCapacity.toStringAsFixed(0)} Ah"),
                _glassLine("Autonomie réelle", "${project.realAutonomyDays.toStringAsFixed(1)} jours"),
              ],

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 DONNÉES POMPAGE
              // ---------------------------------------------------------
              if (project.selectedPump != null) ...[
                _sectionTitle("Pompage solaire"),
                _glassLine("Puissance hydraulique", "${project.pumpHydraulicPower.toStringAsFixed(0)} W"),
                _glassLine("Puissance électrique", "${project.pumpElectricalPower.toStringAsFixed(0)} W"),
                _glassLine("Énergie journalière", "${project.pumpDailyEnergy.toStringAsFixed(0)} Wh/j"),
                _glassLine("Conso totale (avec pompe)", "${project.totalDailyConsumptionKwh.toStringAsFixed(2)} kWh/j"),
              ],

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 ÉLECTRONIQUE DE PUISSANCE
              // ---------------------------------------------------------
              _sectionTitle("Électronique de puissance"),

              _glassLine("Puissance onduleur", "${project.resultInverterPower.toStringAsFixed(0)} W"),
              _glassLine("Courant régulateur", "${project.resultRegulatorCurrent.toStringAsFixed(0)} A"),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 BOUTON RETOUR
              // ---------------------------------------------------------
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blueDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Retour", style: AppTypography.h3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 TITRE DE SECTION
  // ---------------------------------------------------------
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTypography.h2),
    );
  }

  // ---------------------------------------------------------
  // 🔧 LIGNE GLASS AVEC LABEL + VALEUR
  // ---------------------------------------------------------
  Widget _glassLine(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: AppTheme.glassCard,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: AppTypography.label, overflow: TextOverflow.ellipsis),
          ),
          Text(value, style: AppTypography.h3),
        ],
      ),
    );
  }
}
