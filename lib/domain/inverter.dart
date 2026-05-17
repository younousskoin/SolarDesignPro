import 'enums.dart';

class Inverter {
  final String id; // Identifiant unique
  final String name; // <<< AJOUT ESSENTIEL
  final String brand; // Marque (Victron, Growatt, Huawei…)
  final String modelRef; // Référence constructeur

  final InverterType type; // offgrid, hybrid, ongrid

  final int power; // W (AC nominal)
  final int surgePower; // W (puissance crête)
  final int voltage; // V (batterie)
  final double efficiency; // %

  final int pvMaxVoltage; // V
  final int pvMaxPower; // W
  final int mpptMin; // V
  final int mpptMax; // V

  final String outputVoltage; // "230V" ou "120V"

  final double price; // prix unitaire
  final String currency; // EUR, USD, CFA…

  final int lifetimeYears; // durée de vie
  final int warrantyYears; // garantie

  Inverter({
    required this.id,
    required this.name, // <<< AJOUT DANS LE CONSTRUCTEUR
    required this.brand,
    required this.modelRef,
    required this.type,
    required this.power,
    required this.surgePower,
    required this.voltage,
    required this.efficiency,
    required this.pvMaxVoltage,
    required this.pvMaxPower,
    required this.mpptMin,
    required this.mpptMax,
    required this.outputVoltage,
    required this.price,
    required this.currency,
    required this.lifetimeYears,
    required this.warrantyYears,
  });
}
