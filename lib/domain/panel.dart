import 'enums.dart';

class Panel {
  final String id; // Identifiant unique
  final String name; // <<< AJOUT ESSENTIEL
  final String brand; // Marque (Jinko, Longi, JA Solar…)
  final String modelRef; // Référence constructeur

  final PanelType type; // mono, poly, bifacial, thinfilm…
  final PanelSubtype subtype; // perc, topcon, hjt, ibc…

  final int power; // W
  final double efficiency; // %
  final double voc; // V
  final double isc; // A
  final double vmp; // V
  final double imp; // A
  final double tempCoeff; // %/°C
  final int noct; // °C

  final double carbon; // kg CO2 eq

  final double price; // prix unitaire
  final String currency; // EUR, USD, CFA…

  final int lifetimeYears; // durée de vie
  final int warrantyYears; // garantie

  Panel({
    required this.id,
    required this.name, // <<< AJOUT DANS LE CONSTRUCTEUR
    required this.brand,
    required this.modelRef,
    required this.type,
    required this.subtype,
    required this.power,
    required this.efficiency,
    required this.voc,
    required this.isc,
    required this.vmp,
    required this.imp,
    required this.tempCoeff,
    required this.noct,
    required this.carbon,
    required this.price,
    required this.currency,
    required this.lifetimeYears,
    required this.warrantyYears,
  });
}
