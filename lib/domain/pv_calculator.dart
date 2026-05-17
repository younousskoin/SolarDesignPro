import '../domain/project.dart';
import '../domain/panel.dart';
import '../domain/battery.dart';
import '../domain/inverter.dart';
import '../domain/regulator.dart';
import '../domain/pump.dart';

/// ---------------------------------------------------------------------------
/// PVCalculator (version legacy corrigée et propre)
/// ---------------------------------------------------------------------------
/// ⚠️ Cette classe est conservée uniquement pour compatibilité avec les anciens
/// fichiers. Elle NE DOIT PAS être utilisée dans la nouvelle architecture.
/// Utiliser PVCalculatorNew basé sur TechnicalProjectData.
/// ---------------------------------------------------------------------------

class PVCalculator {
  final Project project;

  PVCalculator(this.project);

  // ---------------------------------------------------------------------------
  // VALIDATIONS
  // ---------------------------------------------------------------------------

  bool panelRegulatorOK(Panel panel, Regulator reg) {
    // Vérifie tension + courant
    return panel.voc <= reg.pvMaxVoltage &&
        (panel.power / panel.vmp) <= reg.current;
  }

  bool panelInverterOK(Panel panel, Inverter inv) {
    // Vérifie tension d'entrée PV
    return panel.voc <= inv.pvMaxVoltage;
  }

  bool batteryInverterOK(Battery batt, Inverter inv) {
    // Vérifie tension nominale
    return batt.voltage == inv.voltage;
  }

  bool pumpInverterOK(Pump pump, Inverter inv) {
    // Vérifie puissance
    return inv.power >= pump.power;
  }

  bool isSystemValid() {
    final p = project.selectedPanel;
    final r = project.selectedRegulator;
    final i = project.selectedInverter;
    final b = project.selectedBattery;
    final pump = project.selectedPump;

    return (p != null && r != null && panelRegulatorOK(p, r)) &&
        (p != null && i != null && panelInverterOK(p, i)) &&
        (b != null && i != null && batteryInverterOK(b, i)) &&
        (pump == null || (i != null && pumpInverterOK(pump, i)));
  }

  // ---------------------------------------------------------------------------
  // PRODUCTION PV MENSUELLE (ancienne méthode simplifiée)
  // ---------------------------------------------------------------------------

  List<double> monthlyPVProduction(Panel? panel) {
    if (panel == null) return List<double>.filled(12, 0);

    final irr = project.meteo.irradiationMonthly;
    final List<double> result = [];

    for (int i = 0; i < 12; i++) {
      final hsp = irr[i]; // kWh/m²/j
      final daily = (panel.power / 1000) * hsp * 0.75; // rendement simplifié
      result.add(daily * 30); // kWh/mois
    }

    return result;
  }

  // ---------------------------------------------------------------------------
  // CONSOMMATION MENSUELLE (ancienne méthode simplifiée)
  // ---------------------------------------------------------------------------

  List<double> monthlyLoad(double dailyKwh) {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days.map((d) => dailyKwh * d).toList();
  }
}
