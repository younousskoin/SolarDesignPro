import '../domain/project.dart';
import '../domain/panel.dart';
import '../domain/battery.dart';
import '../domain/inverter.dart';
import '../domain/regulator.dart';
import '../domain/pump.dart';
import '../domain/system_type.dart';
import '../domain/location_data.dart';
import '../domain/meteo_data.dart';

import '../data/catalogs.dart';

class AutoSelectionResult {
  final Panel panel;
  final Battery? battery;
  final Inverter? inverter;
  final Regulator? regulator;
  final Pump? pump;

  AutoSelectionResult({
    required this.panel,
    this.battery,
    this.inverter,
    this.regulator,
    this.pump,
  });
}

class AutoSelector {
  final List<double> irradiation;
  final List<double> temperature;
  final List<double> hourlyConsumption;
  final PVSystemType systemType;
  final double autonomyDays;

  AutoSelector({
    required this.irradiation,
    required this.temperature,
    required this.hourlyConsumption,
    required this.systemType,
    required this.autonomyDays,
  });

  AutoSelectionResult select() {
    // ---------------------------------------------------------
    // 0) Projet temporaire minimal
    // ---------------------------------------------------------
    final dummyProject = Project(
      name: "Auto",
      location: const LocationData(
        latitude: 0,
        longitude: 0,
        country: "",
        city: "",
      ),
      meteo: MeteoData(
        irradiationMonthly: irradiation,
        temperatureMonthly: temperature,
      ),
      systemType: systemType,
      hourlyConsumption: hourlyConsumption,
      autonomyDays: autonomyDays,
    );

    // ---------------------------------------------------------
    // 1) Sélection du panneau (le plus puissant)
    // ---------------------------------------------------------
    final Panel bestPanel = panelList.reduce(
      (a, b) => a.power >= b.power ? a : b,
    );
    dummyProject.selectedPanel = bestPanel;

    // ---------------------------------------------------------
    // 2) Sélection de la batterie (sauf directUse et onGrid)
    // ---------------------------------------------------------
    Battery? bestBattery;
    if (systemType != PVSystemType.directUse &&
        systemType != PVSystemType.onGrid) {
      if (batteryList.isNotEmpty) {
        bestBattery = batteryList.reduce(
          (a, b) => a.capacity >= b.capacity ? a : b,
        );
      }
    }
    dummyProject.selectedBattery = bestBattery;

    // ---------------------------------------------------------
    // 3) Sélection de la pompe
    // ---------------------------------------------------------
    Pump? bestPump;
    if (systemType == PVSystemType.directUse ||
        systemType == PVSystemType.pumpingWithStorage) {
      if (pumpList.isNotEmpty) {
        bestPump = pumpList.reduce((a, b) => a.power >= b.power ? a : b);
      }
    }
    dummyProject.selectedPump = bestPump;

    // Détection AC/DC
    final bool isAC =
        bestPump?.supplyVoltage.toUpperCase().contains("AC") ?? false;
    final bool isDC =
        bestPump?.supplyVoltage.toUpperCase().contains("DC") ?? false;

    // ---------------------------------------------------------
    // 4) Sélection de l’onduleur
    // ---------------------------------------------------------
    Inverter? bestInverter;

    if (bestPump != null && isAC) {
      // Pompe AC → dimensionnement sur la pompe
      final pumpRatedW = bestPump.power; // déjà en W
      final surgeFactor = bestPump.startingCurrent > 1
          ? bestPump.startingCurrent
          : 1.3;

      final requiredPowerW = pumpRatedW * surgeFactor;

      bestInverter = _pickBestInverter(
        minContinuousW: requiredPowerW,
        preferredBatteryVoltage: bestBattery?.voltage,
        requireSurgeW: requiredPowerW,
      );
    } else if (bestPump != null && isDC) {
      // Pompe DC → pas besoin d’onduleur
      bestInverter = null;
    } else {
      // Pas de pompe → dimensionnement sur le pic de charge
      final peakKw = hourlyConsumption.isNotEmpty
          ? hourlyConsumption.reduce((a, b) => a > b ? a : b)
          : 0.0;

      final requiredPowerW = peakKw * 1000.0 * 1.25;

      bestInverter = _pickBestInverter(
        minContinuousW: requiredPowerW,
        preferredBatteryVoltage: bestBattery?.voltage,
      );
    }

    dummyProject.selectedInverter = bestInverter;

    // ---------------------------------------------------------
    // 5) Sélection du régulateur (sauf onGrid)
    // ---------------------------------------------------------
    Regulator? bestReg;
    if (systemType != PVSystemType.onGrid) {
      if (regulatorList.isNotEmpty) {
        final pvCurrent = bestPanel.power / bestPanel.vmp;

        // On prend le premier régulateur compatible
        for (final r in regulatorList) {
          final okCurrent = r.current >= pvCurrent;
          final okVoc = bestPanel.voc <= r.pvMaxVoltage;

          if (okCurrent && okVoc) {
            bestReg = r;
            break;
          }
        }

        bestReg ??= regulatorList.last;
      }
    }
    dummyProject.selectedRegulator = bestReg;

    // ---------------------------------------------------------
    // 6) Revalidation pompe ↔ onduleur (AC)
    // ---------------------------------------------------------
    if (bestPump != null && isAC && bestInverter != null) {
      final pumpRatedW = bestPump.power;
      final surgeFactor = bestPump.startingCurrent > 1
          ? bestPump.startingCurrent
          : 1.3;

      final requiredPowerW = pumpRatedW * surgeFactor;

      if (bestInverter.power < requiredPowerW ||
          bestInverter.surgePower < requiredPowerW) {
        bestInverter = _pickBestInverter(
          minContinuousW: requiredPowerW,
          preferredBatteryVoltage: bestBattery?.voltage,
          requireSurgeW: requiredPowerW,
        );
      }
    }

    return AutoSelectionResult(
      panel: bestPanel,
      battery: bestBattery,
      inverter: bestInverter,
      regulator: bestReg,
      pump: bestPump,
    );
  }

  // ---------------------------------------------------------
  // Sélection intelligente de l’onduleur
  // ---------------------------------------------------------
  Inverter? _pickBestInverter({
    required double minContinuousW,
    int? preferredBatteryVoltage,
    double? requireSurgeW,
  }) {
    if (inverterList.isEmpty) return null;

    var candidates = inverterList
        .where((i) => i.power >= minContinuousW)
        .toList();

    if (requireSurgeW != null) {
      candidates = candidates
          .where((i) => i.surgePower >= requireSurgeW)
          .toList();
    }

    if (preferredBatteryVoltage != null) {
      final preferred = candidates
          .where((i) => i.voltage == preferredBatteryVoltage)
          .toList();
      if (preferred.isNotEmpty) {
        candidates = preferred;
      }
    }

    candidates.sort((a, b) => a.power.compareTo(b.power));
    return candidates.isNotEmpty ? candidates.first : inverterList.last;
  }
}
