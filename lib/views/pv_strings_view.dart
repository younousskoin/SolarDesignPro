import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../domain/project.dart';

// ⭐ NOUVEAUX IMPORTS PREMIUM
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';

import '../widgets/fade_scale.dart';
import '../widgets/slide_fade_horizontal.dart';

class PvStringsView extends StatelessWidget {
  final Project project;

  const PvStringsView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      // ---------------------------------------------------------
      // 🔷 APPBAR GLASS PREMIUM
      // ---------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.white.withOpacity(0.75)),
          ),
        ),
        title: SlideFadeHorizontal(
          delay: 100,
          child: const Text("Configuration PV", style: AppTypography.h2),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          FadeScale(
            delay: 150,
            child: Text(
              "Branchement des panneaux solaires",
              style: AppTypography.h1.copyWith(color: AppTheme.blueDeep),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          FadeScale(
            delay: 200,
            child: const Text(
              "Analyse détaillée du câblage série / parallèle et compatibilité électrique.",
              style: AppTypography.body,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ---------------------------------------------------------
          // 🔷 CONFIGURATION DES STRINGS
          // ---------------------------------------------------------
          _pvCard(
            title: "Configuration des strings",
            delay: 250,
            children: [
              _info("Panneaux en série", "${project.pvSeriesCount}"),
              _info("Strings en parallèle", "${project.pvParallelCount}"),
              _info("Total panneaux", "${project.resultPanelCount}"),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ---------------------------------------------------------
          // 🔷 TENSIONS
          // ---------------------------------------------------------
          _pvCard(
            title: "Tensions électriques",
            delay: 300,
            children: [
              _info("Voc total", "${project.pvVocString.toStringAsFixed(1)} V"),
              _info("Vmp total", "${project.pvVmpString.toStringAsFixed(1)} V"),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ---------------------------------------------------------
          // 🔷 COURANTS
          // ---------------------------------------------------------
          _pvCard(
            title: "Courants électriques",
            delay: 350,
            children: [
              _info("Imp total", "${project.pvImpString.toStringAsFixed(2)} A"),
              _info("Isc total", "${project.pvIscString.toStringAsFixed(2)} A"),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ---------------------------------------------------------
          // 🔷 COMPATIBILITÉ
          // ---------------------------------------------------------
          _pvCard(
            title: "Compatibilité système",
            delay: 400,
            children: [
              _status("Compatibilité régulateur", project.panelRegulatorOK),
              _status("Compatibilité onduleur", project.panelInverterOK),
              _status("Batterie ↔ Onduleur", project.batteryInverterOK),
              _status("Pompe ↔ Onduleur", project.pumpInverterOK),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 CARTE PV PREMIUM GLASS
  // ---------------------------------------------------------
  Widget _pvCard({
    required String title,
    required int delay,
    required List<Widget> children,
  }) {
    return FadeScale(
      delay: delay,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: AppTheme.glassCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.h2.copyWith(color: AppTheme.blueDeep)),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 LIGNE INFO
  // ---------------------------------------------------------
  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Text("$label : ", style: AppTypography.h3),
          Expanded(child: Text(value, style: AppTypography.body)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 LIGNE STATUT
  // ---------------------------------------------------------
  Widget _status(String label, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.error_rounded,
            color: ok ? Colors.green : Colors.red,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.h3.copyWith(
              color: ok ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }
}
