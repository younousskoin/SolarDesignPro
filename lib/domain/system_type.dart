import 'package:flutter/material.dart';

/// Types de systèmes PV supportés par SolarDesignPro
enum PVSystemType { offGrid, onGrid, hybrid, directUse, pumpingWithStorage }

/// ---------------------------------------------------------
/// EXTENSIONS PREMIUM : labels, icônes, images, couleurs, etc.
/// ---------------------------------------------------------
extension PVSystemTypeFeatures on PVSystemType {
  // ---------------------------------------------------------
  // 🔥 IDENTIFIANT STABLE POUR SAUVEGARDE (clé Hive)
  // ---------------------------------------------------------
  String get key => name;

  static PVSystemType fromKey(String key) {
    return PVSystemType.values.firstWhere(
      (t) => t.name == key,
      orElse: () => PVSystemType.offGrid,
    );
  }

  // ---------------------------------------------------------
  // 🔥 LABEL LISIBLES POUR L’UI
  // ---------------------------------------------------------
  String get label {
    switch (this) {
      case PVSystemType.offGrid:
        return "Système Off-Grid";
      case PVSystemType.onGrid:
        return "Système On-Grid";
      case PVSystemType.hybrid:
        return "Système Hybride";
      case PVSystemType.directUse:
        return "Pompage direct";
      case PVSystemType.pumpingWithStorage:
        return "Pompage avec stockage";
    }
  }

  // ---------------------------------------------------------
  // 🔥 ICÔNE PAR TYPE (UI premium)
  // ---------------------------------------------------------
  IconData get icon {
    switch (this) {
      case PVSystemType.offGrid:
        return Icons.battery_full;
      case PVSystemType.onGrid:
        return Icons.electric_bolt;
      case PVSystemType.hybrid:
        return Icons.sync_alt;
      case PVSystemType.directUse:
        return Icons.water_drop;
      case PVSystemType.pumpingWithStorage:
        return Icons.water;
    }
  }

  // ---------------------------------------------------------
  // 🔥 IMAGE PAR TYPE
  // ---------------------------------------------------------
  String get imagePath {
    switch (this) {
      case PVSystemType.offGrid:
        return "assets/offgrid.png";
      case PVSystemType.onGrid:
        return "assets/ongrid.png";
      case PVSystemType.hybrid:
        return "assets/hybrid.png";
      case PVSystemType.directUse:
        return "assets/direct.png";
      case PVSystemType.pumpingWithStorage:
        return "assets/pumping_storage.png";
    }
  }

  // ---------------------------------------------------------
  // 🔥 COULEUR THÉMATIQUE
  // ---------------------------------------------------------
  Color get color {
    switch (this) {
      case PVSystemType.offGrid:
        return Colors.orange;
      case PVSystemType.onGrid:
        return Colors.green;
      case PVSystemType.hybrid:
        return Colors.blue;
      case PVSystemType.directUse:
        return Colors.teal;
      case PVSystemType.pumpingWithStorage:
        return Colors.indigo;
    }
  }

  // ---------------------------------------------------------
  // 🔥 COMPOSANTS REQUIS
  // ---------------------------------------------------------
  bool get requiresBattery {
    switch (this) {
      case PVSystemType.offGrid:
      case PVSystemType.hybrid:
      case PVSystemType.pumpingWithStorage:
        return true;
      default:
        return false;
    }
  }

  bool get requiresInverter {
    switch (this) {
      case PVSystemType.onGrid:
      case PVSystemType.offGrid:
      case PVSystemType.hybrid:
        return true;
      default:
        return false;
    }
  }

  bool get requiresRegulator {
    switch (this) {
      case PVSystemType.offGrid:
      case PVSystemType.pumpingWithStorage:
        return true;
      default:
        return false;
    }
  }

  bool get requiresPump {
    return this == PVSystemType.directUse ||
        this == PVSystemType.pumpingWithStorage;
  }
}

/// ---------------------------------------------------------
/// 🔥 FONCTIONS GLOBALES UTILISABLES PARTOUT
/// ---------------------------------------------------------

/// Convertit un String (clé Hive) → enum PVSystemType
PVSystemType parseSystemType(String key) {
  return PVSystemType.values.firstWhere(
    (t) => t.key == key,
    orElse: () => PVSystemType.offGrid,
  );
}

/// Retourne le label lisible
String systemTypeLabel(PVSystemType type) => type.label;
