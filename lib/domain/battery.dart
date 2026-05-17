import 'enums.dart';

class Battery {
  final String id; // Identifiant unique
  final String name; // <<< AJOUT ESSENTIEL
  final String brand; // Marque (Victron, Pylontech, Narada…)
  final String modelRef; // Référence constructeur

  final BatteryType type; // gel, agm, lithium, opzs, opzv, industrial2v

  final int capacity; // Ah
  final int voltage; // V
  final double efficiency; // %
  final int dod; // %
  final int cycles; // nombre de cycles

  final int maxChargeCurrent; // A
  final int maxDischargeCurrent; // A
  final double internalResistance; // ohm

  final String temperatureRange; // ex: "-10–50°C"

  final double price; // prix unitaire
  final String currency; // EUR, USD, CFA…

  final int lifetimeYears; // durée de vie
  final int warrantyYears; // garantie

  Battery({
    required this.id,
    required this.name, // <<< AJOUT DANS LE CONSTRUCTEUR
    required this.brand,
    required this.modelRef,
    required this.type,
    required this.capacity,
    required this.voltage,
    required this.efficiency,
    required this.dod,
    required this.cycles,
    required this.maxChargeCurrent,
    required this.maxDischargeCurrent,
    required this.internalResistance,
    required this.temperatureRange,
    required this.price,
    required this.currency,
    required this.lifetimeYears,
    required this.warrantyYears,
  });
}
