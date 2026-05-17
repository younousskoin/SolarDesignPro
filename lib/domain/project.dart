import 'dart:math';

import 'package:simpv_system/domain/location_data.dart';
import 'package:simpv_system/domain/meteo_data.dart';
import 'package:simpv_system/domain/system_type.dart';
import 'package:simpv_system/domain/pump.dart';
import 'package:simpv_system/domain/panel.dart';
import 'package:simpv_system/domain/battery.dart';
import 'package:simpv_system/domain/inverter.dart';
import 'package:simpv_system/domain/regulator.dart';

import '../services/simulation_8760_service.dart';
import '../services/optimizer_service.dart';

class Project {
  // ---------------------------------------------------------
  // 🔷 INFORMATIONS GÉNÉRALES
  // ---------------------------------------------------------
  final String name;
  final LocationData location;
  final MeteoData meteo;
  final PVSystemType systemType;

  final List<double> hourlyConsumption;
  final double autonomyDays;

  double tilt;
  double orientation;

  Panel? selectedPanel;
  Battery? selectedBattery;
  Inverter? selectedInverter;
  Regulator? selectedRegulator;
  Pump? selectedPump;

  final bool autoSelected;

  // ---------------------------------------------------------
  // 🔷 RÉSULTATS PV
  // ---------------------------------------------------------
  double resultPvPower = 0;
  int resultPanelCount = 0;

  double resultBatteryCapacity = 0;
  double resultInverterPower = 0;
  double resultRegulatorCurrent = 0;

  double annualProduction = 0;
  double annualConsumption = 0;
  double energyBalance = 0;
  double pvCoverage = 0;

  double realAutonomyDays = 0;

  // ---------------------------------------------------------
  // 🔷 COURBES MENSUELLES
  // ---------------------------------------------------------
  List<double> monthlyProduction = List.filled(12, 0.0);
  List<double> monthlyConsumption = List.filled(12, 0.0);

  List<double> seasonalFactors = const [
    1.20, 1.10, 1.00, 0.95, 0.90, 0.85,
    0.85, 0.90, 0.95, 1.00, 1.10, 1.20,
  ];

  // ---------------------------------------------------------
  // 🔷 PERFORMANCE (PR GLOBAL)
  // ---------------------------------------------------------
  double pr = 0;
  double prThermal = 0;
  double prElectrical = 0;

  double hspAvg = 0;
  double systemEfficiency = 0;

  // 🔥 Pertes techniques
  double lossTemperature = 0.08;
  double lossMismatch = 0.02;
  double lossSoiling = 0.03;
  double lossMppt = 0.015;
  double lossDcCables = 0.02;
  double lossInverter = 0.06;
  double lossAcCables = 0.015;

  double totalLossFactor = 0;
  double totalLossPercent = 0;

  // ---------------------------------------------------------
  // 🔷 POMPAGE
  // ---------------------------------------------------------
  double pumpHydraulicPower = 0;
  double pumpElectricalPower = 0;
  double pumpDailyEnergy = 0;

  // ---------------------------------------------------------
  // 🔷 VALIDATION
  // ---------------------------------------------------------
  bool panelRegulatorOK = false;
  bool panelInverterOK = false;
  bool batteryInverterOK = false;
  bool pumpInverterOK = false;

  // ---------------------------------------------------------
  // 🔷 STRINGS PV
  // ---------------------------------------------------------
  int pvSeriesCount = 0;
  int pvParallelCount = 0;
  double pvVocString = 0;
  double pvVmpString = 0;
  double pvImpString = 0;
  double pvIscString = 0;

  // ---------------------------------------------------------
  // 🔷 CONSTANTES
  // ---------------------------------------------------------
  static const double SYSTEM_EFFICIENCY = 0.78;
  static const double BATTERY_EFFICIENCY = 0.90;

  // ---------------------------------------------------------
  // 🔷 PDF+ : SIMULATION 8760H
  // ---------------------------------------------------------
  Simulation8760Result? simulation8760;

  // ---------------------------------------------------------
  // 🔷 PDF+ : OPTIMISATION AUTOMATIQUE
  // ---------------------------------------------------------
  OptimizationResult? optimizationResult;

  // ---------------------------------------------------------
  // 🔷 COURBES 24H (PV + SOC)
  // ---------------------------------------------------------
  List<double> pvPowerDaily = List.filled(24, 0.0);
  List<double> socDaily = List.filled(24, 0.0);

  // ---------------------------------------------------------
  // 🔷 COURBES 24H — MÉTÉO (NOUVEAU)
  // ---------------------------------------------------------
  List<double> ghi24h = List.filled(24, 0.0);
  List<double> temperature24h = List.filled(24, 0.0);

  // ---------------------------------------------------------
  // 🔷 COURBES 24H — AJOUT COMPLET
  // ---------------------------------------------------------
  List<double> surplusDaily = List.filled(24, 0.0);
  List<double> deficitDaily = List.filled(24, 0.0);

  List<double> batteryChargeDaily = List.filled(24, 0.0);
  List<double> batteryDischargeDaily = List.filled(24, 0.0);

  List<double> inverterLoadDaily = List.filled(24, 0.0);

  // ---------------------------------------------------------
  // 🔷 COURBES 8760H — ANNÉE COMPLÈTE
  // ---------------------------------------------------------
  List<double> pvHourly = List.filled(8760, 0.0);
  List<double> loadHourly = List.filled(8760, 0.0);
  List<double> socHourly = List.filled(8760, 0.0);
  List<double> surplusHourly = List.filled(8760, 0.0);
  List<double> deficitHourly = List.filled(8760, 0.0);

  // ---------------------------------------------------------
  // 🔷 CONSTRUCTEUR
  // ---------------------------------------------------------
  Project({
    required this.name,
    required this.location,
    required this.meteo,
    required this.systemType,
    required this.hourlyConsumption,
    required this.autonomyDays,
    this.selectedPanel,
    this.selectedBattery,
    this.selectedInverter,
    this.selectedRegulator,
    this.selectedPump,
    this.autoSelected = false,
    this.tilt = 30,
    this.orientation = 0,
  });

  // ---------------------------------------------------------
  // 🔷 CONSOMMATION
  // ---------------------------------------------------------
  double get dailyConsumption {
    if (hourlyConsumption.isEmpty) return 0;
    return hourlyConsumption.reduce((a, b) => a + b);
  }

  double get totalDailyConsumptionKwh {
    return dailyConsumption + (pumpDailyEnergy / 1000);
  }

  double get annualConsumptionInput {
    return dailyConsumption * 365;
  }

  // ---------------------------------------------------------
  // 🔷 PERFORMANCE
  // ---------------------------------------------------------
  void computePerformance() {
    prThermal = (1 - lossTemperature);

    prElectrical =
        (1 - lossMismatch) *
        (1 - lossSoiling) *
        (1 - lossMppt) *
        (1 - lossDcCables) *
        (1 - lossInverter) *
        (1 - lossAcCables);

    pr = (prThermal * prElectrical).clamp(0.55, 0.90);
    systemEfficiency = pr;
  }

  // ---------------------------------------------------------
  // 🔷 PERTES GLOBALES
  // ---------------------------------------------------------
  void computeLosses() {
    totalLossFactor = 1 - pr;
    totalLossPercent = totalLossFactor * 100;
  }

  // ---------------------------------------------------------
  // 🔷 COURBE PV (24h)
  // ---------------------------------------------------------
  void computePvPowerDaily() {
    if (selectedPanel == null || resultPanelCount == 0) {
      pvPowerDaily = List.filled(24, 0.0);
      return;
    }

    final pNom = resultPvPower * 1000;
    const cloudIndex = 0.2;

    for (int h = 0; h < 24; h++) {
      pvPowerDaily[h] = pNom * _solarCurve(h, cloud: cloudIndex);
    }
  }

  double _solarCurve(int h, {double cloud = 0.0}) {
    if (h < 6 || h > 18) return 0.0;

    final x = (h - 6) / 12 * pi;
    double base = pow(sin(x), 1.4).toDouble();

    base *= (1 - cloud * 0.6);

    return base.clamp(0.0, 1.0);
  }

  // ---------------------------------------------------------
  // 🔷 COURBE SOC (24h)
  // ---------------------------------------------------------
  void computeSocDaily() {
    if (selectedBattery == null || resultBatteryCapacity <= 0) {
      socDaily = List.filled(24, 0.0);
      return;
    }

    final V = selectedBattery!.voltage.toDouble();
    final dod = (selectedBattery!.dod / 100).clamp(0.05, 0.95);

    final usableWh = resultBatteryCapacity * V * dod * BATTERY_EFFICIENCY;

    double socWh = usableWh * 0.85;
    socDaily[0] = 85;

    const chargeEff = 0.92;
    const dischargeEff = 0.88;

    for (int h = 1; h < 24; h++) {
      final pvWh = pvPowerDaily[h];
      final loadWh = hourlyConsumption[h] * 1000;

      if (pvWh > loadWh) {
        socWh += (pvWh - loadWh) * chargeEff;
      } else {
        socWh -= (loadWh - pvWh) / dischargeEff;
      }

      socWh = socWh.clamp(usableWh * 0.05, usableWh);

      socDaily[h] = (socWh / usableWh) * 100;
    }
  }

  // ---------------------------------------------------------
  // 🔷 PRODUCTION PV MENSUELLE — VERSION NASA CORRIGÉE
  // ---------------------------------------------------------
  void computePVProduction() {
    if (selectedPanel == null) {
      monthlyProduction = List.filled(12, 0.0);
      hspAvg = 0;
      return;
    }

    for (int i = 0; i < 12; i++) {
      final ghi = meteo.irradiationMonthly[i];
      final dhi = meteo.diffuseMonthly[i];
      final dni = meteo.directMonthly[i];
      final temp = meteo.temperatureMonthly[i];

      final poa = computePOA(
        ghi: ghi,
        dhi: dhi,
        dni: dni,
        tiltDeg: tilt,
        azimuthDeg: orientation,
      );

      final tCell = computeCellTemperature(
        poa: poa,
        tempAir: temp,
        noct: (selectedPanel!.noct ?? 45).toDouble(),
      );

      final pReal = computeRealPanelPower(
        pNom: selectedPanel!.power.toDouble(),
        tCell: tCell,
      );

      final dailyProd = computeDailyPV(
        poa: poa,
        pReal: pReal,
      );

      monthlyProduction[i] = dailyProd * 30;
    }

    hspAvg = meteo.irradiationMonthly.reduce((a, b) => a + b) / 12.0;
  }

  double computePOA({
    required double ghi,
    required double dhi,
    required double dni,
    required double tiltDeg,
    required double azimuthDeg,
  }) {
    final tiltRad = tiltDeg * pi / 180.0;
    final cosIncidence = max(0.0, cos(tiltRad));

    final beam = dni * cosIncidence;
    final diffuse = dhi * (1 + cos(tiltRad)) / 2;

    const albedo = 0.20;
    final ground = ghi * albedo * (1 - cos(tiltRad)) / 2;

    return beam + diffuse + ground;
  }

  double computeCellTemperature({
    required double poa,
    required double tempAir,
    required double noct,
  }) {
    final irradianceWm2 = (poa * 1000) / 6;

    final tCell = tempAir + (irradianceWm2 / 800) * (noct - 20);
    return tCell.clamp(15, 85);
  }

  double computeRealPanelPower({required double pNom, required double tCell}) {
    const gamma = -0.0035;
    final correction = 1 + gamma * (tCell - 25);
    return (pNom * correction).clamp(pNom * 0.5, pNom);
  }

  double computeDailyPV({
    required double poa,
    required double pReal,
  }) {
    final retained =
        (1 - lossTemperature) *
        (1 - lossMismatch) *
        (1 - lossSoiling) *
        (1 - lossMppt) *
        (1 - lossDcCables) *
        (1 - lossInverter) *
        (1 - lossAcCables);

    final eff = retained.clamp(0.55, 0.85);

    final pRealKw = pReal / 1000;

    return poa * pRealKw * eff;
  }

  // ---------------------------------------------------------
  // 🔷 CONSOMMATION MENSUELLE
  // ---------------------------------------------------------
  void computeMonthlyConsumption() {
    final daily = totalDailyConsumptionKwh;

    monthlyConsumption = List.generate(
      12,
      (i) => daily * 30 * seasonalFactors[i],
    );
  }

  // ---------------------------------------------------------
  // 🔷 DIMENSIONNEMENT PV
  // ---------------------------------------------------------
  void computePVSize() {
    if (selectedPanel == null) {
      resultPvPower = 0;
      resultPanelCount = 0;
      return;
    }

    final avgDailyProd = monthlyProduction.reduce((a, b) => a + b) / 12 / 30;

    if (avgDailyProd <= 0.01) {
      resultPvPower = 0;
      resultPanelCount = 0;
      return;
    }

    double requiredPv = totalDailyConsumptionKwh / avgDailyProd;

    requiredPv *= 1.15;

    resultPanelCount =
        (requiredPv * 1000 / selectedPanel!.power).ceil().clamp(1, 9999);

    resultPvPower = resultPanelCount * selectedPanel!.power / 1000.0;
  }

  // ---------------------------------------------------------
  // 🔷 STRINGS PV
  // ---------------------------------------------------------
  void computePVStrings() {
    if (selectedPanel == null || resultPanelCount == 0) {
      pvSeriesCount = 0;
      pvParallelCount = 0;
      return;
    }

    final panel = selectedPanel!;

    final maxVoc =
        selectedInverter?.pvMaxVoltage ??
        selectedRegulator?.pvMaxVoltage ??
        150;

    final tMin = meteo.temperatureMonthly.reduce(min);

    final vocCold = panel.voc * (1 + 0.0035 * (25 - tMin));

    final maxSeries = (maxVoc / vocCold).floor().clamp(1, resultPanelCount);

    int bestSeries = 1;
    int bestParallel = resultPanelCount;
    double bestScore = -1;

    for (int s = 1; s <= maxSeries; s++) {
      int p = (resultPanelCount / s).ceil();

      double vocString = s * vocCold;
      double vmpString = s * panel.vmp;

      double iscTotal = p * panel.isc;
      double impTotal = p * panel.imp;

      if (vocString > maxVoc) continue;

      if (selectedRegulator != null && iscTotal > selectedRegulator!.current) {
        continue;
      }

      double score = vmpString;

      if (score > bestScore) {
        bestScore = score;
        bestSeries = s;
        bestParallel = p;
      }
    }

    pvSeriesCount = bestSeries;
    pvParallelCount = bestParallel;

    pvVocString = bestSeries * panel.voc;
    pvVmpString = bestSeries * panel.vmp;

    pvImpString = bestParallel * panel.imp;
    pvIscString = bestParallel * panel.isc;
  }

  // ---------------------------------------------------------
  // 🔷 DIMENSIONNEMENT BATTERIE
  // ---------------------------------------------------------
  void computeBatterySize() {
    if (selectedBattery == null) {
      resultBatteryCapacity = 0;
      return;
    }

    final V = selectedBattery!.voltage.toDouble();
    final dod = (selectedBattery!.dod / 100).clamp(0.05, 0.95);

    final dailyWh = totalDailyConsumptionKwh * 1000;

    resultBatteryCapacity =
        (dailyWh * autonomyDays) / (V * dod * BATTERY_EFFICIENCY);
  }

  // ---------------------------------------------------------
  // 🔷 DIMENSIONNEMENT ONDULEUR
  // ---------------------------------------------------------
  void computeInverterSize() {
    if (selectedInverter == null) {
      resultInverterPower = 0;
      return;
    }

    final peakKwh =
        hourlyConsumption.isEmpty ? 0.0 : hourlyConsumption.reduce(max);

    final peakKw = peakKwh * 1.3;

    resultInverterPower = peakKw * 1000 * 1.2;

    if (resultPvPower * 1000 > selectedInverter!.pvMaxPower) {
      resultInverterPower = selectedInverter!.power.toDouble();
    }
  }

  // ---------------------------------------------------------
  // 🔷 DIMENSIONNEMENT RÉGULATEUR
  // ---------------------------------------------------------
  void computeRegulatorSize() {
    if (selectedRegulator == null || selectedPanel == null) {
      resultRegulatorCurrent = 0;
      return;
    }

    final totalWp = resultPanelCount * selectedPanel!.power.toDouble();

    final vmp = selectedPanel!.vmp.toDouble().clamp(12, 1000);
    double imp = totalWp / vmp;

    imp *= 1.25;

    resultRegulatorCurrent = imp;
  }

  // ---------------------------------------------------------
  // 🔷 POMPAGE
  // ---------------------------------------------------------
  void computePump() {
    if (selectedPump == null) {
      pumpHydraulicPower = 0;
      pumpElectricalPower = 0;
      pumpDailyEnergy = 0;
      return;
    }

    final pump = selectedPump!;

    final q = pump.flow / 3600;
    final h = pump.head;

    pumpHydraulicPower = 1000 * 9.81 * q * h;

    pumpElectricalPower = pumpHydraulicPower / pump.efficiency;

    pumpDailyEnergy = pumpElectricalPower * pump.hoursPerDay;
  }

  // ---------------------------------------------------------
  // 🔷 BILAN ANNUEL
  // ---------------------------------------------------------
  void computeAnnualBalance() {
    annualProduction = monthlyProduction.reduce((a, b) => a + b);
    annualConsumption = annualConsumptionInput;
    energyBalance = annualProduction - annualConsumption;
    pvCoverage = annualProduction / annualConsumption;
  }

  // ---------------------------------------------------------
  // 🔷 AUTONOMIE RÉELLE
  // ---------------------------------------------------------
  void computeRealAutonomy() {
    if (selectedBattery == null) {
      realAutonomyDays = 0;
      return;
    }

    final V = selectedBattery!.voltage.toDouble();
    final dod = (selectedBattery!.dod / 100).clamp(0.05, 0.95);

    final usableWh = resultBatteryCapacity * V * dod * BATTERY_EFFICIENCY;

    realAutonomyDays = usableWh / (totalDailyConsumptionKwh * 1000);
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 24H — SURPLUS / DÉFICIT
  // ---------------------------------------------------------
  void computeSurplusDeficitDaily() {
    for (int h = 0; h < 24; h++) {
      final pv = pvPowerDaily[h];
      final load = hourlyConsumption[h] * 1000;

      if (pv >= load) {
        surplusDaily[h] = pv - load;
        deficitDaily[h] = 0;
      } else {
        surplusDaily[h] = 0;
        deficitDaily[h] = load - pv;
      }
    }
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 24H — CHARGE / DÉCHARGE BATTERIE
  // ---------------------------------------------------------
  void computeBatteryFlowDaily() {
    for (int h = 0; h < 24; h++) {
      final pv = pvPowerDaily[h];
      final load = hourlyConsumption[h] * 1000;

      if (pv > load) {
        batteryChargeDaily[h] = pv - load;
        batteryDischargeDaily[h] = 0;
      } else {
        batteryChargeDaily[h] = 0;
        batteryDischargeDaily[h] = load - pv;
      }
    }
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 24H — CHARGE ONDULEUR
  // ---------------------------------------------------------
  void computeInverterLoadDaily() {
    if (selectedInverter == null) return;

    final maxPower = selectedInverter!.power.toDouble();

    for (int h = 0; h < 24; h++) {
      inverterLoadDaily[h] =
          (hourlyConsumption[h] * 1000).clamp(0, maxPower);
    }
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 8760H — CONSOMMATION
  // ---------------------------------------------------------
  void computeHourlyLoad8760() {
    loadHourly = List.generate(
      8760,
      (i) => hourlyConsumption[i % 24],
    );
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 8760H — PV
  // ---------------------------------------------------------
  void computeHourlyPV8760() {
    pvHourly = List.generate(
      8760,
      (i) => pvPowerDaily[i % 24],
    );
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 8760H — SOC
  // ---------------------------------------------------------
  void computeHourlySOC8760() {
    socHourly = List.generate(
      8760,
      (i) => socDaily[i % 24],
    );
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 8760H — SURPLUS / DÉFICIT
  // ---------------------------------------------------------
  void computeSurplusDeficit8760() {
    surplusHourly = List.generate(
      8760,
      (i) => (pvHourly[i] > loadHourly[i])
          ? pvHourly[i] - loadHourly[i]
          : 0,
    );

    deficitHourly = List.generate(
      8760,
      (i) => (loadHourly[i] > pvHourly[i])
          ? loadHourly[i] - pvHourly[i]
          : 0,
    );
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 24H — GHI (profil solaire réaliste)
  // ---------------------------------------------------------
  List<double> computeGhi24h(List<double> ghiMonthly) {
    final avg = ghiMonthly.reduce((a, b) => a + b) / 12;

    const sunrise = 6;
    const sunset = 18;

    return List.generate(24, (h) {
      if (h < sunrise || h > sunset) return 0.0;

      final x = (h - sunrise) / (sunset - sunrise) * pi;

      final base = pow(sin(x), 1.5).toDouble();
      const clarity = 0.85;

      return avg * base * clarity;
    });
  }

  // ---------------------------------------------------------
  // 🔷 COURBES 24H — TEMPÉRATURE (profil thermique réaliste)
  // ---------------------------------------------------------
  List<double> computeTemperature24h(List<double> tempMonthly) {
    final avg = tempMonthly.reduce((a, b) => a + b) / 12;

    final amplitude = (avg < 15) ? 4.0 : (avg < 25 ? 6.0 : 8.0);

    return List.generate(24, (h) {
      final x = ((h - 6) / 24) * 2 * pi;
      return avg + amplitude * sin(x);
    });
  }

  // ---------------------------------------------------------
  // 🔷 AUTO-SÉLECTION INTELLIGENTE (implémentation simple)
  // ---------------------------------------------------------
  void autoSelectComponents({
    List<Panel> panels = const [],
    List<Battery> batteries = const [],
    List<Inverter> inverters = const [],
    List<Regulator> regulators = const [],
    List<Pump> pumps = const [],
  }) {
    if (panels.isNotEmpty && selectedPanel == null) {
      selectedPanel = panels.first;
    }
    if (batteries.isNotEmpty && selectedBattery == null) {
      selectedBattery = batteries.first;
    }
    if (inverters.isNotEmpty && selectedInverter == null) {
      selectedInverter = inverters.first;
    }
    if (regulators.isNotEmpty && selectedRegulator == null) {
      selectedRegulator = regulators.first;
    }
    if (pumps.isNotEmpty && selectedPump == null) {
      selectedPump = pumps.first;
    }
  }

  // ---------------------------------------------------------
  // 🔷 CORRECTION D’INCOMPATIBILITÉS (version neutre)
  // ---------------------------------------------------------
  void fixIncompatibilities({
    required List<Inverter> inverters,
    required List<Regulator> regulators,
  }) {
    // Version minimale : ne fait rien pour l’instant.
  }

  // ---------------------------------------------------------
  // 🔷 COMPUTE ALL — VERSION PREMIUM ULTRA (COMPLET)
  // ---------------------------------------------------------
  void computeAll({
    List<Panel>? panels,
    List<Battery>? batteries,
    List<Inverter>? inverters,
    List<Regulator>? regulators,
    List<Pump>? pumps,
  }) {
    // ---------------------------------------------------------
    // 🔹 AUTO-SÉLECTION INTELLIGENTE
    // ---------------------------------------------------------
    if (autoSelected) {
      autoSelectComponents(
        panels: panels ?? [],
        batteries: batteries ?? [],
        inverters: inverters ?? [],
        regulators: regulators ?? [],
        pumps: pumps ?? [],
      );
    }

    // ---------------------------------------------------------
    // 🔹 CALCULS DE BASE
    // ---------------------------------------------------------
    computePump();
    computePVProduction();
    computePVSize();

    if (inverters != null && regulators != null) {
      fixIncompatibilities(inverters: inverters, regulators: regulators);
    }

    computeBatterySize();
    computeInverterSize();
    computeRegulatorSize();
    computePVStrings();
    computePerformance();
    computeLosses();

    computeMonthlyConsumption();
    computeAnnualBalance();
    computeRealAutonomy();

    // ---------------------------------------------------------
    // 🔹 COURBES 24H (PV + SOC)
    // ---------------------------------------------------------
    computePvPowerDaily();
    computeSocDaily();

    // ---------------------------------------------------------
    // 🔹 COURBES 24H — GHI & TEMPÉRATURE
    // ---------------------------------------------------------
    ghi24h = computeGhi24h(meteo.irradiationMonthly);
    temperature24h = computeTemperature24h(meteo.temperatureMonthly);

    // ---------------------------------------------------------
    // 🔹 COURBES 24H — NOUVELLES COURBES
    // ---------------------------------------------------------
    computeSurplusDeficitDaily();
    computeBatteryFlowDaily();
    computeInverterLoadDaily();

    // ---------------------------------------------------------
    // 🔹 COURBES 8760H — ANNÉE COMPLÈTE
    // ---------------------------------------------------------
    computeHourlyLoad8760();
    computeHourlyPV8760();
    computeHourlySOC8760();
    computeSurplusDeficit8760();

    // ---------------------------------------------------------
    // 🔹 SIMULATION 8760H (PRO)
    // ---------------------------------------------------------
    simulation8760 = Simulation8760Service.run(this);

    if (simulation8760 != null && simulation8760!.states.isNotEmpty) {
      for (int i = 0; i < 8760; i++) {
        pvHourly[i] = simulation8760!.states[i].pvPower;
        loadHourly[i] = simulation8760!.states[i].loadPower;
        socHourly[i] = simulation8760!.states[i].batterySoc;
        surplusHourly[i] = simulation8760!.states[i].surplus;
        deficitHourly[i] = simulation8760!.states[i].deficit;
      }
    }

    // ---------------------------------------------------------
    // 🔹 VALIDATION SYSTÈME
    // ---------------------------------------------------------
    validateSystem();
  }

  // ---------------------------------------------------------
  // 🔷 VALIDATION SYSTÈME — VERSION PRO
  // ---------------------------------------------------------
  void validateSystem() {
    final type = systemType;

    panelRegulatorOK =
        !type.requiresRegulator ||
        (selectedPanel != null &&
            selectedRegulator != null &&
            selectedPanel!.voc <= selectedRegulator!.pvMaxVoltage &&
            (selectedPanel!.power / selectedPanel!.vmp) <=
                selectedRegulator!.current);

    panelInverterOK =
        !type.requiresInverter ||
        (selectedPanel != null &&
            selectedInverter != null &&
            selectedPanel!.voc <= selectedInverter!.pvMaxVoltage);

    batteryInverterOK =
        !type.requiresBattery ||
        (selectedBattery != null &&
            selectedInverter != null &&
            selectedBattery!.voltage == selectedInverter!.voltage);

    pumpInverterOK =
        !type.requiresPump ||
        (selectedPump != null &&
            selectedInverter != null &&
            selectedInverter!.power >= pumpElectricalPower);
  }

  // ---------------------------------------------------------
  // 🔷 DIAGNOSTIC INTELLIGENT — VERSION PRO
  // ---------------------------------------------------------
  Map<String, String> diagnostic() {
    final diag = <String, String>{};
    final type = systemType;

    // --- Régulateur ---
    if (!type.requiresRegulator) {
      diag["Régulateur"] = "✔ Non requis";
    } else if (selectedRegulator == null) {
      diag["Régulateur"] = "❌ Aucun régulateur sélectionné";
    } else if (pvVocString > selectedRegulator!.pvMaxVoltage) {
      diag["Régulateur"] =
          "❌ Voc string (${pvVocString.toStringAsFixed(1)} V) > tension max régulateur (${selectedRegulator!.pvMaxVoltage} V)";
    } else if (pvIscString > selectedRegulator!.current) {
      diag["Régulateur"] =
          "❌ Isc total (${pvIscString.toStringAsFixed(1)} A) > courant max régulateur (${selectedRegulator!.current} A)";
    } else {
      diag["Régulateur"] = "✔ Compatible";
    }

    // --- Onduleur ---
    if (!type.requiresInverter) {
      diag["Onduleur"] = "✔ Non requis";
    } else if (selectedInverter == null) {
      diag["Onduleur"] = "❌ Aucun onduleur sélectionné";
    } else if (pvVocString > selectedInverter!.pvMaxVoltage) {
      diag["Onduleur"] =
          "❌ Voc string (${pvVocString.toStringAsFixed(1)} V) > tension max onduleur (${selectedInverter!.pvMaxVoltage} V)";
    } else {
      diag["Onduleur"] = "✔ Compatible";
    }

    // --- Batterie ---
    if (!type.requiresBattery) {
      diag["Batterie"] = "✔ Non requis";
    } else if (selectedBattery == null) {
      diag["Batterie"] = "❌ Aucune batterie sélectionnée";
    } else if (selectedInverter != null &&
        selectedBattery!.voltage != selectedInverter!.voltage) {
      diag["Batterie"] =
          "❌ Tension batterie (${selectedBattery!.voltage} V) ≠ tension onduleur (${selectedInverter!.voltage} V)";
    } else {
      diag["Batterie"] = "✔ Compatible";
    }

    // --- Pompe ---
    if (!type.requiresPump) {
      diag["Pompe"] = "✔ Non requis";
    } else if (selectedPump == null) {
      diag["Pompe"] = "❌ Aucune pompe sélectionnée";
    } else if (selectedInverter != null &&
        selectedInverter!.power < pumpElectricalPower) {
      diag["Pompe"] =
          "❌ Puissance pompe (${pumpElectricalPower.toStringAsFixed(0)} W) > puissance onduleur (${selectedInverter!.power} W)";
    } else {
      diag["Pompe"] = "✔ Compatible";
    }

    return diag;
  }

  // ---------------------------------------------------------
  // 🔧 RÉTRO‑COMPATIBILITÉ POUR PDF_SERVICE
  // ---------------------------------------------------------
  double get lossCable => lossDcCables + lossAcCables;
  double get lossTemp => lossTemperature;
  double get lossDirt => lossSoiling;
  double get lossRegulator => lossMppt;
}
