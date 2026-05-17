import 'dart:math';
import '../domain/project.dart';
import '../domain/panel.dart';
import '../domain/battery.dart';

class HourlyState {
  final DateTime time;
  final double pvPower;      // W
  final double loadPower;    // W
  final double batterySoc;   // %
  final double batteryEnergy; // Wh
  final double pvEnergy;     // Wh
  final double loadEnergy;   // Wh
  final double surplus;      // Wh
  final double deficit;      // Wh

  HourlyState({
    required this.time,
    required this.pvPower,
    required this.loadPower,
    required this.batterySoc,
    required this.batteryEnergy,
    required this.pvEnergy,
    required this.loadEnergy,
    required this.surplus,
    required this.deficit,
  });
}

class Simulation8760Result {
  final List<HourlyState> states;
  final double totalPvEnergy;     // kWh
  final double totalLoadEnergy;   // kWh
  final double unmetLoadEnergy;   // kWh
  final double minSoc;
  final double maxSoc;

  Simulation8760Result({
    required this.states,
    required this.totalPvEnergy,
    required this.totalLoadEnergy,
    required this.unmetLoadEnergy,
    required this.minSoc,
    required this.maxSoc,
  });
}

class Simulation8760Service {
  static Simulation8760Result run(Project project) {
    if (project.selectedPanel == null ||
        project.resultPanelCount == 0 ||
        project.selectedBattery == null) {
      return Simulation8760Result(
        states: const [],
        totalPvEnergy: 0,
        totalLoadEnergy: 0,
        unmetLoadEnergy: 0,
        minSoc: 0,
        maxSoc: 0,
      );
    }

    final Panel panel = project.selectedPanel!;
    final Battery battery = project.selectedBattery!;
    final int year = DateTime.now().year;

    final List<HourlyState> states = [];

    // Capacité utile batterie
    final double V = battery.voltage.toDouble();
    final double dod = (battery.dod / 100).clamp(0.05, 0.95);
    final double usableWh =
        project.resultBatteryCapacity * V * dod * Project.BATTERY_EFFICIENCY;

    double socWh = usableWh * 0.8; // SOC initial 80%

    double totalPvWh = 0;
    double totalLoadWh = 0;
    double unmetLoadWh = 0;

    double minSoc = 100;
    double maxSoc = 0;

    // Profil journalier
    final dailyProfile = List<double>.from(project.hourlyConsumption);
    while (dailyProfile.length < 24) {
      dailyProfile.add(0);
    }

    for (int day = 0; day < 365; day++) {
      final date = DateTime(year, 1, 1).add(Duration(days: day));

      final monthIndex = date.month - 1;
      final ghiDaily = project.meteo.irradiationMonthly[monthIndex];
      final tempDaily = project.meteo.temperatureMonthly[monthIndex];

      final double dailyIrrWhm2 = ghiDaily * 1000;
      final double pNom = project.resultPvPower * 1000;

      for (int h = 0; h < 24; h++) {
        final time = DateTime(year, date.month, date.day, h);

        // Irradiation horaire
        final double solarShape = _solarShape(h);
        final double ghiHour = dailyIrrWhm2 * solarShape;

        // Température cellule
        final double tCell = _cellTemperature(
          ghi: ghiHour / 1000,
          tempAir: tempDaily,
          noct: (panel.noct ?? 45).toDouble(),
        );

        // Puissance PV corrigée
        double pvPower = _realPanelPower(
          pNom: pNom,
          tCell: tCell,
        );

        // Appliquer PR global
        pvPower *= project.pr;

        // Limiter à la puissance nominale
        pvPower = pvPower.clamp(0, pNom);

        final double loadWh = dailyProfile[h] * 1000;
        final double pvWh = pvPower;

        double surplus = 0;
        double deficit = 0;

        double netWh = pvWh - loadWh;

        if (netWh >= 0) {
          surplus = netWh;
          socWh += netWh * 0.92; // rendement charge
        } else {
          deficit = -netWh;
          final needed = -netWh / 0.88; // rendement décharge
          if (socWh >= needed) {
            socWh -= needed;
          } else {
            unmetLoadWh += (needed - socWh);
            socWh = 0;
          }
        }

        socWh = socWh.clamp(0.0, usableWh);

        final double socPercent =
            usableWh > 0 ? (socWh / usableWh) * 100 : 0;

        totalPvWh += pvWh;
        totalLoadWh += loadWh;

        minSoc = min(minSoc, socPercent);
        maxSoc = max(maxSoc, socPercent);

        states.add(
          HourlyState(
            time: time,
            pvPower: pvPower,
            loadPower: loadWh,
            batterySoc: socPercent,
            batteryEnergy: socWh,
            pvEnergy: pvWh,
            loadEnergy: loadWh,
            surplus: surplus,
            deficit: deficit,
          ),
        );
      }
    }

    return Simulation8760Result(
      states: states,
      totalPvEnergy: totalPvWh / 1000,
      totalLoadEnergy: totalLoadWh / 1000,
      unmetLoadEnergy: unmetLoadWh / 1000,
      minSoc: minSoc,
      maxSoc: maxSoc,
    );
  }

  static double _solarShape(int h) {
    if (h < 6 || h > 18) return 0.0;
    final x = (h - 6) / 12 * pi;
    return pow(sin(x), 1.6).clamp(0.0, 1.0).toDouble();
  }

  static double _cellTemperature({
    required double ghi,
    required double tempAir,
    required double noct,
  }) {
    final irradianceWm2 = ghi * 1000;
    final tCell = tempAir + (irradianceWm2 / 1000) * (noct - 20);
    return tCell.clamp(15, 85).toDouble();
  }

  static double _realPanelPower({
    required double pNom,
    required double tCell,
  }) {
    const gamma = -0.0035;
    final correction = 1 + gamma * (tCell - 25);
    return (pNom * correction).clamp(0.0, pNom).toDouble();
  }
}
