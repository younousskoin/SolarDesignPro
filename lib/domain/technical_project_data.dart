import 'system_type.dart';

class TechnicalProjectData {
  final String name;
  final String city;
  final String country;

  final double latitude;
  final double longitude;

  final double tilt;
  final double orientation;
  final double autonomyDays;

  final List<double> hourlyConsumption; // 24 valeurs
  final List<double> ghiMonthly; // 12 valeurs
  final List<double> dhiMonthly; // 12 valeurs
  final List<double> dniMonthly; // 12 valeurs
  final List<double> temperatureMonthly; // 12 valeurs

  final PVSystemType systemType;

  TechnicalProjectData({
    required this.name,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.tilt,
    required this.orientation,
    required this.autonomyDays,
    required this.hourlyConsumption,
    required this.ghiMonthly,
    required this.dhiMonthly,
    required this.dniMonthly,
    required this.temperatureMonthly,
    required this.systemType,
  });
}
