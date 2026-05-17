import 'package:hive/hive.dart';

import '../domain/project.dart';
import '../domain/system_type.dart';
import '../domain/location_data.dart';
import '../domain/meteo_data.dart';

part 'project_model.g.dart';

@HiveType(typeId: 1)
class ProjectModel extends HiveObject {
  // -----------------------------
  // 🔷 Informations générales
  // -----------------------------
  @HiveField(0)
  String name;

  @HiveField(1)
  String city;

  @HiveField(2)
  String country;

  @HiveField(3)
  double latitude;

  @HiveField(4)
  double longitude;

  @HiveField(5)
  double tilt;

  @HiveField(6)
  double orientation;

  @HiveField(7)
  double autonomyDays;

  @HiveField(8)
  List<double> hourlyConsumption;

  // -----------------------------
  // 🔷 Données météo
  // -----------------------------
  @HiveField(9)
  List<double> ghi;

  @HiveField(10)
  List<double> dhi;

  @HiveField(11)
  List<double> dni;

  @HiveField(12)
  List<double> temperature;

  // ⭐ Champs météo ajoutés (doivent être optionnels)
  @HiveField(37)
  List<double> wind;

  @HiveField(38)
  List<double> humidity;

  @HiveField(39)
  List<double> windDirection;

  @HiveField(13)
  String systemType;

  @HiveField(14)
  DateTime createdAt;

  // -----------------------------
  // 🔷 PV Strings
  // -----------------------------
  @HiveField(15)
  int pvSeriesCount;

  @HiveField(16)
  int pvParallelCount;

  @HiveField(17)
  double pvVocString;

  @HiveField(18)
  double pvVmpString;

  @HiveField(19)
  double pvImpString;

  @HiveField(20)
  double pvIscString;

  @HiveField(21)
  int resultPanelCount;

  // -----------------------------
  // 🔷 Compatibilités
  // -----------------------------
  @HiveField(22)
  bool panelRegulatorOK;

  @HiveField(23)
  bool panelInverterOK;

  @HiveField(24)
  bool batteryInverterOK;

  @HiveField(25)
  bool pumpInverterOK;

  // -----------------------------
  // 🔥 Courbes & bilans
  // -----------------------------
  @HiveField(26)
  List<double> socDaily;

  @HiveField(27)
  List<double> pvPowerDaily;

  @HiveField(28)
  List<double> monthlyProduction;

  @HiveField(29)
  List<double> monthlyConsumption;

  @HiveField(30)
  double annualProduction;

  @HiveField(31)
  double annualConsumption;

  @HiveField(32)
  double energyBalance;

  @HiveField(33)
  double pvCoverage;

  @HiveField(34)
  double realAutonomyDays;

  @HiveField(35)
  double pr;

  @HiveField(36)
  double totalLossPercent;

  ProjectModel({
    required this.name,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.tilt,
    required this.orientation,
    required this.autonomyDays,
    required this.hourlyConsumption,
    required this.ghi,
    required this.dhi,
    required this.dni,
    required this.temperature,

    // ⭐ Valeurs par défaut pour compatibilité Hive
    List<double>? wind,
    List<double>? humidity,
    List<double>? windDirection,

    required this.systemType,
    required this.pvSeriesCount,
    required this.pvParallelCount,
    required this.pvVocString,
    required this.pvVmpString,
    required this.pvImpString,
    required this.pvIscString,
    required this.resultPanelCount,
    required this.panelRegulatorOK,
    required this.panelInverterOK,
    required this.batteryInverterOK,
    required this.pumpInverterOK,
    List<double>? socDaily,
    List<double>? pvPowerDaily,
    List<double>? monthlyProduction,
    List<double>? monthlyConsumption,
    double? annualProduction,
    double? annualConsumption,
    double? energyBalance,
    double? pvCoverage,
    double? realAutonomyDays,
    double? pr,
    double? totalLossPercent,
    DateTime? createdAt,
  })  : wind = wind ?? List.filled(12, 2.0),
        humidity = humidity ?? List.filled(12, 60.0),
        windDirection = windDirection ?? List.filled(12, 180.0),
        socDaily = socDaily ?? List.filled(24, 0.0),
        pvPowerDaily = pvPowerDaily ?? List.filled(24, 0.0),
        monthlyProduction = monthlyProduction ?? List.filled(12, 0.0),
        monthlyConsumption = monthlyConsumption ?? List.filled(12, 0.0),
        annualProduction = annualProduction ?? 0.0,
        annualConsumption = annualConsumption ?? 0.0,
        energyBalance = energyBalance ?? 0.0,
        pvCoverage = pvCoverage ?? 0.0,
        realAutonomyDays = realAutonomyDays ?? 0.0,
        pr = pr ?? 0.0,
        totalLossPercent = totalLossPercent ?? 0.0,
        createdAt = createdAt ?? DateTime.now();

  // ---------------------------------------------------------------------------
  // 🔥 Factory : Project → ProjectModel
  // ---------------------------------------------------------------------------
  factory ProjectModel.fromProject(Project p) {
    return ProjectModel(
      name: p.name,
      city: p.location.city,
      country: p.location.country,
      latitude: p.location.latitude,
      longitude: p.location.longitude,
      tilt: p.tilt,
      orientation: p.orientation,
      autonomyDays: p.autonomyDays,
      hourlyConsumption: p.hourlyConsumption,
      ghi: p.meteo.irradiationMonthly,
      dhi: p.meteo.diffuseMonthly,
      dni: p.meteo.directMonthly,
      temperature: p.meteo.temperatureMonthly,

      // ⭐ Sécurisé
      wind: p.meteo.windMonthly,
      humidity: p.meteo.humidityMonthly,
      windDirection: p.meteo.windDirectionMonthly,

      systemType: p.systemType.key,
      pvSeriesCount: p.pvSeriesCount,
      pvParallelCount: p.pvParallelCount,
      pvVocString: p.pvVocString,
      pvVmpString: p.pvVmpString,
      pvImpString: p.pvImpString,
      pvIscString: p.pvIscString,
      resultPanelCount: p.resultPanelCount,
      panelRegulatorOK: p.panelRegulatorOK,
      panelInverterOK: p.panelInverterOK,
      batteryInverterOK: p.batteryInverterOK,
      pumpInverterOK: p.pumpInverterOK,
      socDaily: p.socDaily,
      pvPowerDaily: p.pvPowerDaily,
      monthlyProduction: p.monthlyProduction,
      monthlyConsumption: p.monthlyConsumption,
      annualProduction: p.annualProduction,
      annualConsumption: p.annualConsumption,
      energyBalance: p.energyBalance,
      pvCoverage: p.pvCoverage,
      realAutonomyDays: p.realAutonomyDays,
      pr: p.pr,
      totalLossPercent: p.totalLossPercent,
    );
  }
}

// ---------------------------------------------------------------------------
// 🔥 MAPPER COMPLET : ProjectModel → Project
// ---------------------------------------------------------------------------
extension ProjectModelMapper on ProjectModel {
  Project toDomain() {
    final project = Project(
      name: name,
      location: LocationData(
        city: city,
        country: country,
        latitude: latitude,
        longitude: longitude,
      ),
      meteo: MeteoData(
        irradiationMonthly: ghi,
        diffuseMonthly: dhi,
        directMonthly: dni,
        temperatureMonthly: temperature,

        // ⭐ Sécurisé
        windMonthly: wind,
        humidityMonthly: humidity,
        windDirectionMonthly: windDirection,
      ),
      systemType: PVSystemTypeFeatures.fromKey(systemType),
      hourlyConsumption: hourlyConsumption,
      autonomyDays: autonomyDays,
      tilt: tilt,
      orientation: orientation,
    );

    project.pvSeriesCount = pvSeriesCount;
    project.pvParallelCount = pvParallelCount;
    project.pvVocString = pvVocString;
    project.pvVmpString = pvVmpString;
    project.pvImpString = pvImpString;
    project.pvIscString = pvIscString;
    project.resultPanelCount = resultPanelCount;

    project.panelRegulatorOK = panelRegulatorOK;
    project.panelInverterOK = panelInverterOK;
    project.batteryInverterOK = batteryInverterOK;
    project.pumpInverterOK = pumpInverterOK;

    project.socDaily = List.from(socDaily);
    project.pvPowerDaily = List.from(pvPowerDaily);
    project.monthlyProduction = List.from(monthlyProduction);
    project.monthlyConsumption = List.from(monthlyConsumption);

    project.annualProduction = annualProduction;
    project.annualConsumption = annualConsumption;
    project.energyBalance = energyBalance;
    project.pvCoverage = pvCoverage;
    project.realAutonomyDays = realAutonomyDays;
    project.pr = pr;
    project.totalLossPercent = totalLossPercent;

    return project;
  }
}
