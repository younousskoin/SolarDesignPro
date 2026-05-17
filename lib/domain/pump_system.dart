import 'dart:math';

import 'pump.dart';
import 'panel.dart';
import 'regulator.dart';
import 'inverter.dart';

/// ------------------------------------------------------------
/// 🔷 PumpSystem Ultra Fusion — SolarDesignPro
/// ------------------------------------------------------------
/// Combine :
///  - Calcul hydraulique
///  - Calcul électrique
///  - Compatibilités AC/DC
///  - Analyse professionnelle
/// ------------------------------------------------------------
class PumpSystem {
  final Pump pump;
  final Panel? panel;
  final Regulator? regulator;
  final Inverter? inverter;

  PumpSystem({required this.pump, this.panel, this.regulator, this.inverter});

  // ------------------------------------------------------------
  // 🔥 CALCUL HYDRAULIQUE
  // ------------------------------------------------------------

  /// Puissance hydraulique (W)
  double get hydraulicPower {
    final q = pump.flow / 3600; // m3/h → m3/s
    return 1000 * 9.81 * q * pump.head;
  }

  /// Puissance électrique (W)
  double get electricalPower {
    return hydraulicPower / max(pump.efficiency, 0.01);
  }

  /// Énergie journalière (Wh/j)
  double get dailyEnergyWh {
    return electricalPower * pump.hoursPerDay;
  }

  /// Débit journalier pompé (m3/j)
  double get dailyFlow {
    return pump.flow * pump.hoursPerDay;
  }

  // ------------------------------------------------------------
  // 🔥 COMPATIBILITÉS PROFESSIONNELLES
  // ------------------------------------------------------------

  /// Compatibilité panneau → pompe (DC)
  bool get isPanelCompatible {
    if (panel == null) return false;

    // Puissance panneau ≥ puissance pompe
    if (panel!.power < electricalPower) return false;

    // Tension panneau ≥ tension pompe (si DC)
    if (pump.supplyVoltage == "DC") {
      if (panel!.vmp < pump.supplyVoltageValue) return false;
    }

    return true;
  }

  /// Compatibilité régulateur → panneau (DC)
  bool get isRegulatorCompatible {
    if (regulator == null || panel == null) return false;

    // Courant panneau → régulateur
    if (regulator!.current < panel!.isc) return false;

    // Tension panneau → régulateur
    if (panel!.voc > regulator!.pvMaxVoltage) return false;

    return true;
  }

  /// Compatibilité onduleur → pompe (AC)
  bool get isInverterCompatible {
    if (inverter == null) return false;

    // Puissance nominale
    if (inverter!.power < electricalPower) return false;

    // Courant de démarrage (AC)
    final startingPower = pump.startingCurrent * pump.supplyVoltageValue;
    if (inverter!.surgePower < startingPower) return false;

    return true;
  }

  /// Système global valide
  bool get isSystemValid {
    if (pump.supplyVoltage == "DC") {
      return isPanelCompatible && isRegulatorCompatible;
    }
    if (pump.supplyVoltage == "AC") {
      return isInverterCompatible;
    }
    return false;
  }

  // ------------------------------------------------------------
  // 🔥 Résumé lisible
  // ------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      "hydraulic_power_W": hydraulicPower,
      "electrical_power_W": electricalPower,
      "daily_energy_Wh": dailyEnergyWh,
      "daily_flow_m3": dailyFlow,
      "panel_compatible": isPanelCompatible,
      "regulator_compatible": isRegulatorCompatible,
      "inverter_compatible": isInverterCompatible,
      "system_valid": isSystemValid,
    };
  }

  @override
  String toString() =>
      "PumpSystem Ultra: ${pump.name}, ${dailyFlow.toStringAsFixed(1)} m³/j";
}
