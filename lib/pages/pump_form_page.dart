import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../domain/pump.dart';
import '../domain/enums.dart';

// ⭐ NOUVEAUX IMPORTS PREMIUM
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';


class PumpFormPage extends StatefulWidget {
  final Function(Pump) onPumpSelected;

  const PumpFormPage({super.key, required this.onPumpSelected});

  @override
  State<PumpFormPage> createState() => _PumpFormPageState();
}

class _PumpFormPageState extends State<PumpFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Champs du formulaire
  String name = "";
  String brand = "";
  String modelRef = "";

  PumpType type = PumpType.dcSolar;

  int power = 0;
  double flow = 0;
  int head = 0;
  int hoursPerDay = 5;

  double efficiency = 0.75;
  int startingCurrent = 10;

  String supplyVoltage = "DC";
  int supplyVoltageValue = 48;

  double price = 0;
  String currency = "EUR";

  int lifetimeYears = 10;
  int warrantyYears = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      // ---------------------------------------------------------
      // 🔷 APPBAR GLASS PREMIUM
      // ---------------------------------------------------------
      appBar: AppBar(
        title: const Text("Ajouter une pompe", style: AppTypography.h2),
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

      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // ---------------------------------------------------------
              // 🔷 SECTION : INFORMATIONS GÉNÉRALES
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Informations générales", style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.sm),

                    _field(
                      label: "Nom",
                      onChanged: (v) => name = v,
                      validator: (v) => v!.isEmpty ? "Nom requis" : null,
                    ),

                    _field(
                      label: "Marque",
                      onChanged: (v) => brand = v,
                      validator: (v) => v!.isEmpty ? "Marque requise" : null,
                    ),

                    _field(
                      label: "Référence modèle",
                      onChanged: (v) => modelRef = v,
                      validator: (v) => v!.isEmpty ? "Référence requise" : null,
                    ),

                    DropdownButtonFormField<PumpType>(
                      value: type,
                      decoration: _inputDecoration("Type de pompe"),
                      items: const [
                        DropdownMenuItem(
                          value: PumpType.surfaceAC,
                          child: Text("Surface AC"),
                        ),
                        DropdownMenuItem(
                          value: PumpType.immergeeAC,
                          child: Text("Immergée AC"),
                        ),
                        DropdownMenuItem(
                          value: PumpType.dcSolar,
                          child: Text("DC Solar"),
                        ),
                      ],
                      onChanged: (v) => setState(() => type = v!),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 SECTION : CARACTÉRISTIQUES TECHNIQUES
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Caractéristiques techniques", style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.sm),

                    _field(
                      label: "Puissance (W)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => power = int.tryParse(v) ?? 0,
                    ),

                    _field(
                      label: "Débit (m³/h)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => flow = double.tryParse(v) ?? 0,
                    ),

                    _field(
                      label: "HMT (m)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => head = int.tryParse(v) ?? 0,
                    ),

                    _field(
                      label: "Heures/jour",
                      keyboard: TextInputType.number,
                      onChanged: (v) => hoursPerDay = int.tryParse(v) ?? 5,
                    ),

                    _field(
                      label: "Rendement (%)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => efficiency = (double.tryParse(v) ?? 75) / 100,
                    ),

                    _field(
                      label: "Courant de démarrage (A)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => startingCurrent = int.tryParse(v) ?? 10,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 SECTION : ALIMENTATION
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Alimentation", style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.sm),

                    DropdownButtonFormField(
                      value: supplyVoltage,
                      decoration: _inputDecoration("Type d’alimentation"),
                      items: const [
                        DropdownMenuItem(value: "DC", child: Text("DC")),
                        DropdownMenuItem(value: "AC", child: Text("AC")),
                      ],
                      onChanged: (v) => setState(() => supplyVoltage = v!),
                    ),

                    _field(
                      label: "Tension (V)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => supplyVoltageValue = int.tryParse(v) ?? 48,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ---------------------------------------------------------
              // 🔷 SECTION : COÛTS & DURÉE DE VIE
              // ---------------------------------------------------------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Coûts & durée de vie", style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.sm),

                    _field(
                      label: "Prix",
                      keyboard: TextInputType.number,
                      onChanged: (v) => price = double.tryParse(v) ?? 0,
                    ),

                    _field(
                      label: "Devise",
                      onChanged: (v) => currency = v,
                    ),

                    _field(
                      label: "Durée de vie (ans)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => lifetimeYears = int.tryParse(v) ?? 10,
                    ),

                    _field(
                      label: "Garantie (ans)",
                      keyboard: TextInputType.number,
                      onChanged: (v) => warrantyYears = int.tryParse(v) ?? 2,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ---------------------------------------------------------
              // 🔷 BOUTON VALIDER
              // ---------------------------------------------------------
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onPumpSelected(
                        Pump(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name,
                          brand: brand,
                          modelRef: modelRef,
                          type: type,
                          power: power,
                          flow: flow,
                          head: head.toDouble(),
                          hoursPerDay: hoursPerDay.toDouble(),
                          efficiency: efficiency,
                          startingCurrent: startingCurrent,
                          supplyVoltage: supplyVoltage,
                          supplyVoltageValue: supplyVoltageValue,
                          price: price,
                          currency: currency,
                          lifetimeYears: lifetimeYears,
                          warrantyYears: warrantyYears,
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blueDeep,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Valider", style: AppTypography.h3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 CHAMP DE FORMULAIRE PREMIUM
  // ---------------------------------------------------------
  Widget _field({
    required String label,
    TextInputType keyboard = TextInputType.text,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: TextFormField(
        decoration: _inputDecoration(label),
        keyboardType: keyboard,
        validator: validator,
        onChanged: onChanged,
        style: AppTypography.body,
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 INPUT DECORATION PREMIUM
  // ---------------------------------------------------------
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
