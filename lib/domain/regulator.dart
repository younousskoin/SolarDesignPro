import 'enums.dart';

class Regulator {
  final String id; // Identifiant unique
  final String name; // Nom du régulateur
  final String brand; // Marque (Victron, Epever, SRNE…)
  final String modelRef; // Référence constructeur

  final RegulatorType type; // pwm, mppt

  final int current; // Courant nominal (A)
  final int voltage; // Tension batterie (12/24/48 V)
  final double efficiency; // Rendement (0–1)

  final int pvMaxVoltage; // Tension PV max admissible (Voc max)
  final int pvMaxPower; // Puissance PV max admissible (W)

  final int? mpptMin; // Plage MPPT min (V) — null si PWM
  final int? mpptMax; // Plage MPPT max (V) — null si PWM

  final List<BatteryType> batteryTypes; // Types de batteries compatibles

  final bool temperatureCompensation; // Compensation thermique

  final double price; // Prix unitaire
  final String currency; // EUR, USD, CFA…

  final int lifetimeYears; // Durée de vie
  final int warrantyYears; // Garantie

  Regulator({
    required this.id,
    required this.name,
    required this.brand,
    required this.modelRef,
    required this.type,
    required this.current,
    required this.voltage,
    required this.efficiency,
    required this.pvMaxVoltage,
    required this.pvMaxPower,
    required this.mpptMin,
    required this.mpptMax,
    required this.batteryTypes,
    required this.temperatureCompensation,
    required this.price,
    required this.currency,
    required this.lifetimeYears,
    required this.warrantyYears,
  });
}
