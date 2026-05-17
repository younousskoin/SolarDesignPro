import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../domain/project.dart';
import '../domain/pump.dart';
import '../domain/enums.dart';

// ⭐ NOUVEAUX IMPORTS PREMIUM
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';


class PumpSelectionView extends StatelessWidget {
  final Project project;

  const PumpSelectionView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      // ---------------------------------------------------------
      // 🔷 APPBAR GLASS PREMIUM
      // ---------------------------------------------------------
      appBar: AppBar(
        title: const Text("Catalogue des pompes", style: AppTypography.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.white.withOpacity(0.75)),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.sm),
        children: [
          const Text(
            "Sélectionnez une pompe",
            style: AppTypography.h1,
          ),

          const SizedBox(height: AppSpacing.md),

          _pumpCard(
            context,
            pump: Pump(
              id: "pump_dc_1",
              brand: "Generic",
              modelRef: "DC-IM-01",
              name: "Pompe immergée DC",
              power: 600,
              flow: 3.5,
              head: 80,
              price: 450,
              type: PumpType.dcSolar,
              hoursPerDay: 5,
              efficiency: 0.55,
              startingCurrent: 12,
              supplyVoltage: "24V / 48V DC",
              supplyVoltageValue: 24,
              currency: "EUR",
              lifetimeYears: 10,
              warrantyYears: 2,
            ),
          ),

          _pumpCard(
            context,
            pump: Pump(
              id: "pump_dc_2",
              brand: "Generic",
              modelRef: "DC-SF-01",
              name: "Pompe de surface DC",
              power: 400,
              flow: 5,
              head: 40,
              price: 350,
              type: PumpType.dcSolar,
              hoursPerDay: 5,
              efficiency: 0.50,
              startingCurrent: 10,
              supplyVoltage: "24V / 48V DC",
              supplyVoltageValue: 24,
              currency: "EUR",
              lifetimeYears: 10,
              warrantyYears: 2,
            ),
          ),

          _pumpCard(
            context,
            pump: Pump(
              id: "pump_ac_1",
              brand: "Generic",
              modelRef: "AC-IM-01",
              name: "Pompe immergée AC",
              power: 1500,
              flow: 12,
              head: 120,
              price: 900,
              type: PumpType.immergeeAC,
              hoursPerDay: 5,
              efficiency: 0.60,
              startingCurrent: 15,
              supplyVoltage: "230V AC",
              supplyVoltageValue: 230,
              currency: "EUR",
              lifetimeYears: 10,
              warrantyYears: 2,
            ),
          ),

          _pumpCard(
            context,
            pump: Pump(
              id: "pump_ac_2",
              brand: "Generic",
              modelRef: "AC-SF-01",
              name: "Pompe de surface AC",
              power: 800,
              flow: 10,
              head: 60,
              price: 600,
              type: PumpType.surfaceAC,
              hoursPerDay: 5,
              efficiency: 0.58,
              startingCurrent: 14,
              supplyVoltage: "230V AC",
              supplyVoltageValue: 230,
              currency: "EUR",
              lifetimeYears: 10,
              warrantyYears: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 CARTE POMPE PREMIUM GLASS
  // ---------------------------------------------------------
  Widget _pumpCard(BuildContext context, {required Pump pump}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(pump.name, style: AppTypography.h3),
          const SizedBox(height: 8),

          Text("Marque : ${pump.brand}", style: AppTypography.body),
          Text("Modèle : ${pump.modelRef}", style: AppTypography.body),
          Text("Débit : ${pump.flow} m³/h", style: AppTypography.body),
          Text("HMT : ${pump.head} m", style: AppTypography.body),
          Text("Tension : ${pump.supplyVoltage}", style: AppTypography.body),
          Text("Puissance : ${pump.power} W", style: AppTypography.body),
          Text("Rendement : ${(pump.efficiency * 100).toStringAsFixed(0)} %",
              style: AppTypography.body),
          Text("Courant de démarrage : ${pump.startingCurrent} A",
              style: AppTypography.body),
          Text("Type : ${pump.type.name}", style: AppTypography.body),
          Text("Prix : ${pump.price} ${pump.currency}", style: AppTypography.body),

          const SizedBox(height: AppSpacing.md),

          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, pump),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blueDeep,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Sélectionner cette pompe", style: AppTypography.h3),
            ),
          ),
        ],
      ),
    );
  }
}
