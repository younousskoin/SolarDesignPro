import 'dart:math';

import '../domain/project.dart';
import '../domain/panel.dart';
import '../domain/battery.dart';
import '../domain/inverter.dart';
import '../domain/regulator.dart';
import '../domain/pump.dart';
import '../domain/system_type.dart';

class OptimizationResult {
  final Panel panel;
  final Battery battery;
  final Inverter inverter;
  final Regulator regulator;
  final Pump? pump;

  final double score;
  final double coverage;
  final double autonomy;
  final double losses;
  final double energyBalance;

  OptimizationResult({
    required this.panel,
    required this.battery,
    required this.inverter,
    required this.regulator,
    required this.pump,
    required this.score,
    required this.coverage,
    required this.autonomy,
    required this.losses,
    required this.energyBalance,
  });
}

class OptimizerService {
  static OptimizationResult optimize(
    Project baseProject,
    List<Panel> panels,
    List<Battery> batteries,
    List<Inverter> inverters,
    List<Regulator> regulators,
    List<Pump> pumps,
  ) {
    OptimizationResult? best;
    double bestScore = -999999;

    for (final panel in panels) {
      for (final battery in batteries) {
        // Filtrer les onduleurs compatibles en tension
        final compatibleInverters =
            inverters.where((inv) => inv.voltage == battery.voltage);

        for (final inverter in compatibleInverters) {
          // Filtrer les régulateurs compatibles en tension PV
          final compatibleRegulators = regulators.where(
            (reg) => reg.pvMaxVoltage >= panel.voc,
          );

          for (final regulator in compatibleRegulators) {
            // Gestion pompe selon type de système
            final Iterable<Pump?> pumpCandidates =
                baseProject.systemType.requiresPump
                    ? pumps.cast<Pump?>()
                    : <Pump?>[null];

            for (final Pump? pump in pumpCandidates) {
              // Construire un projet temporaire
              final project = Project(
                name: baseProject.name,
                location: baseProject.location,
                meteo: baseProject.meteo,
                systemType: baseProject.systemType,
                hourlyConsumption: baseProject.hourlyConsumption,
                autonomyDays: baseProject.autonomyDays,
                selectedPanel: panel,
                selectedBattery: battery,
                selectedInverter: inverter,
                selectedRegulator: regulator,
                selectedPump: pump,
              );

              // Lancer tous les calculs
              project.computeAll(
                panels: panels,
                batteries: batteries,
                inverters: inverters,
                regulators: regulators,
                pumps: pumps,
              );

              // Récupérer les indicateurs
              final coverage = project.pvCoverage;
              final autonomy = project.realAutonomyDays;
              final losses = project.totalLossPercent;
              final balance = project.energyBalance;

              // Score identique à ton ancienne version
              double score = 0;

              score += coverage * 50;
              score += min(autonomy / baseProject.autonomyDays, 1.0) * 30;
              score -= losses * 0.5;
              score += (balance > 0 ? 5 : -5);

              // Sélection du meilleur
              if (score > bestScore) {
                bestScore = score;
                best = OptimizationResult(
                  panel: panel,
                  battery: battery,
                  inverter: inverter,
                  regulator: regulator,
                  pump: pump,
                  score: score,
                  coverage: coverage,
                  autonomy: autonomy,
                  losses: losses,
                  energyBalance: balance,
                );
              }
            }
          }
        }
      }
    }

    if (best == null) {
      throw StateError("Aucune combinaison valide trouvée pour l’optimisation.");
    }

    return best;
  }
}
