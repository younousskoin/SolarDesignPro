import 'package:flutter/material.dart';
import '../domain/project.dart';
import '../theme.dart';

class PVStringCalculatorView extends StatelessWidget {
  final Project project;

  const PVStringCalculatorView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    // Assure que les PV strings sont calculés
    project.computePVStrings();
    final diag = project.diagnostic(); // 🔥 Diagnostic intelligent

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text("Branchement série / parallèle"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---------------------------------------------------------
          // RÉSUMÉ PANNEAU
          // ---------------------------------------------------------
          _sectionTitle("Résumé du panneau"),
          _infoCard([
            _row("Puissance panneau", "${project.selectedPanel!.power} W"),
            _row("Voc panneau", "${project.selectedPanel!.voc} V"),
            _row("Vmp panneau", "${project.selectedPanel!.vmp} V"),
            _row("Imp panneau", "${project.selectedPanel!.imp} A"),
            _row("Isc panneau", "${project.selectedPanel!.isc} A"),
          ]),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // CONFIGURATION PV
          // ---------------------------------------------------------
          _sectionTitle("Configuration PV calculée"),
          _infoCard([
            _row("Panneaux en série", "${project.pvSeriesCount}"),
            _row("Branches en parallèle", "${project.pvParallelCount}"),
            _row("Total panneaux", "${project.resultPanelCount}"),
          ]),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // TENSIONS
          // ---------------------------------------------------------
          _sectionTitle("Tensions résultantes"),
          _infoCard([
            _row("Voc string", "${project.pvVocString.toStringAsFixed(1)} V"),
            _row("Vmp string", "${project.pvVmpString.toStringAsFixed(1)} V"),
          ]),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // COURANTS
          // ---------------------------------------------------------
          _sectionTitle("Courants résultants"),
          _infoCard([
            _row("Imp total", "${project.pvImpString.toStringAsFixed(1)} A"),
            _row("Isc total", "${project.pvIscString.toStringAsFixed(1)} A"),
          ]),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // COMPATIBILITÉS (ancienne version)
          // ---------------------------------------------------------
          _sectionTitle("Compatibilités (rapide)"),
          _infoCard([
            _compat("Régulateur", project.panelRegulatorOK),
            _compat("Onduleur", project.panelInverterOK),
            _compat("Batterie", project.batteryInverterOK),
            _compat("Pompe", project.pumpInverterOK),
          ]),

          const SizedBox(height: 20),

          // ---------------------------------------------------------
          // 🔥 DIAGNOSTIC INTELLIGENT (nouvelle version)
          // ---------------------------------------------------------
          _sectionTitle("Diagnostic intelligent"),
          _infoCard(
            diag.entries.map((e) {
              final ok = e.value.startsWith("✔");
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        e.key,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        e.value,
                        style: TextStyle(
                          color: ok ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // RETOUR
          // ---------------------------------------------------------
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueDeep,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              "Retour",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Widgets utilitaires
  // ---------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.whiteCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compat(String label, bool ok) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
          Icon(
            ok ? Icons.check_circle : Icons.cancel,
            color: ok ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
