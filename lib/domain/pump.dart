import 'enums.dart';

class Pump {
  final String id; // Identifiant unique
  final String name; // Nom de la pompe
  final String brand; // Marque (Lorentz, Grundfos, Pedrollo…)
  final String modelRef; // Référence constructeur

  final PumpType type; // surfaceAC, immergeeAC, dcSolar

  final int power; // Puissance en W (pas kW)
  final double flow; // Débit en m³/h
  final double head; // Hauteur manométrique en m  🔥 corrigé
  final double hoursPerDay; // Fonctionnement quotidien en heures 🔥 corrigé

  final double efficiency; // Rendement (0–1)
  final int startingCurrent; // Courant de démarrage en A

  final String supplyVoltage; // "AC" ou "DC"
  final int supplyVoltageValue; // Tension d’alimentation (230, 48, 24…)

  final double price; // Prix unitaire
  final String currency; // EUR, USD, CFA…

  final int lifetimeYears; // Durée de vie
  final int warrantyYears; // Garantie

  Pump({
    required this.id,
    required this.name,
    required this.brand,
    required this.modelRef,
    required this.type,
    required this.power,
    required this.flow,
    required this.head, // double
    required this.hoursPerDay, // double
    required this.efficiency,
    required this.startingCurrent,
    required this.supplyVoltage,
    required this.supplyVoltageValue,
    required this.price,
    required this.currency,
    required this.lifetimeYears,
    required this.warrantyYears,
  });
}
