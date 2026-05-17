import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../domain/project.dart';
import '../domain/panel.dart';
import '../domain/battery.dart';
import '../domain/inverter.dart';
import '../domain/regulator.dart';
import '../domain/pump.dart';

import '../data/catalogs.dart';
import '../views/results_view.dart';
import '../views/pv_strings_view.dart';
import '../domain/system_type.dart';
import '../pages/pump_form_page.dart';
import '../pages/pump_selection_view.dart';

// ⭐ NOUVEAUX IMPORTS PREMIUM
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';


class ComponentSelectionView extends StatefulWidget {
  final Project project;

  const ComponentSelectionView({super.key, required this.project});

  @override
  State<ComponentSelectionView> createState() => _ComponentSelectionViewState();
}

class _ComponentSelectionViewState extends State<ComponentSelectionView> {
  Panel? selectedPanel;
  Battery? selectedBattery;
  Inverter? selectedInverter;
  Regulator? selectedRegulator;
  Pump? selectedPump;

  List<Panel> panelListLocal = [];
  List<Battery> batteryListLocal = [];
  List<Inverter> inverterListLocal = [];
  List<Regulator> regulatorList = [];
  List<Pump> pumpList = [];

  @override
  void initState() {
    super.initState();
    panelListLocal = panelCatalog;
    batteryListLocal = batteryCatalog;
    inverterListLocal = inverterCatalog;
    regulatorList = regulatorCatalog;
    pumpList = pumpCatalog;
  }

  @override
  Widget build(BuildContext context) {
    final PVSystemType type = widget.project.systemType;
    final bool isValid = _validateSelection(type);

    final double dailyConsumption = widget.project.hourlyConsumption.fold(
      0.0,
      (a, b) => a + b,
    );

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      // ---------------------------------------------------------
      // 🔷 APPBAR GLASS PREMIUM
      // ---------------------------------------------------------
      appBar: AppBar(
        title: const Text("Choix des composants", style: AppTypography.h2),
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
          _projectSummary(dailyConsumption),
          const SizedBox(height: AppSpacing.md),

          // ---------------------------------------------------------
          // 🔷 SÉLECTION AUTOMATIQUE
          // ---------------------------------------------------------
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.auto_fix_high, size: 22, color: Colors.white),
              label: const Text("Sélection automatique", style: AppTypography.h3),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blueDeep,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _autoSelect,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // ---------------------------------------------------------
          // 🔷 SÉLECTIONS MANUELLES
          // ---------------------------------------------------------
          _buildDropdown<Panel>(
            icon: Icons.solar_power,
            label: "Panneau solaire",
            items: panelListLocal,
            value: selectedPanel,
            onChanged: (v) => setState(() => selectedPanel = v),
          ),

          if (type.requiresBattery)
            _buildDropdown<Battery>(
              icon: Icons.battery_full,
              label: "Batterie",
              items: batteryListLocal,
              value: selectedBattery,
              onChanged: (v) => setState(() => selectedBattery = v),
            ),

          if (type.requiresInverter)
            _buildDropdown<Inverter>(
              icon: Icons.power,
              label: "Onduleur",
              items: _filteredInverters(),
              value: selectedInverter,
              onChanged: (v) => setState(() => selectedInverter = v),
            ),

          if (type.requiresRegulator)
            _buildDropdown<Regulator>(
              icon: Icons.settings_input_component,
              label: "Régulateur",
              items: _filteredRegulators(),
              value: selectedRegulator,
              onChanged: (v) => setState(() => selectedRegulator = v),
            ),

          if (type.requiresPump) _pumpSection(),

          const SizedBox(height: AppSpacing.sm),

          _buildDiagnosticCard(),

          const SizedBox(height: AppSpacing.md),

          _pvStringsButton(),

          const SizedBox(height: AppSpacing.sm),

          _continueButton(isValid),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 LOGIQUE
  // ---------------------------------------------------------

  void _autoSelect() {
    widget.project.autoSelectComponents(
      panels: panelListLocal,
      batteries: batteryListLocal,
      inverters: inverterListLocal,
      regulators: regulatorList,
      pumps: pumpList,
    );

    setState(() {
      selectedPanel = widget.project.selectedPanel;
      selectedBattery = widget.project.selectedBattery;
      selectedInverter = widget.project.selectedInverter;
      selectedRegulator = widget.project.selectedRegulator;
      selectedPump = widget.project.selectedPump;
    });
  }

  bool _validateSelection(PVSystemType systemType) {
    if (selectedPanel == null) return false;
    if (systemType.requiresBattery && selectedBattery == null) return false;
    if (systemType.requiresInverter && selectedInverter == null) return false;
    if (systemType.requiresRegulator && selectedRegulator == null) return false;
    if (systemType.requiresPump && selectedPump == null) return false;
    return true;
  }

  List<Inverter> _filteredInverters() {
    if (selectedBattery == null) return inverterListLocal;
    return inverterListLocal
        .where((inv) => inv.voltage == selectedBattery!.voltage)
        .toList();
  }

  List<Regulator> _filteredRegulators() {
    if (selectedPanel == null) return regulatorList;
    return regulatorList
        .where((reg) => reg.pvMaxVoltage >= selectedPanel!.voc)
        .toList();
  }

  // ---------------------------------------------------------
  // 🔧 NAVIGATION
  // ---------------------------------------------------------

  void _continue() {
    widget.project.selectedPanel = selectedPanel;
    widget.project.selectedBattery = selectedBattery;
    widget.project.selectedInverter = selectedInverter;
    widget.project.selectedRegulator = selectedRegulator;
    widget.project.selectedPump = selectedPump;

    widget.project.computePVStrings();
    widget.project.computeAll();

    final diag = widget.project.diagnostic();
    final hasError = diag.values.any((msg) => msg.startsWith("❌"));

    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Certaines incompatibilités doivent être corrigées."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsView(project: widget.project),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 UI WIDGETS
  // ---------------------------------------------------------

  Widget _projectSummary(double dailyConsumption) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info, color: AppTheme.blueDeep, size: 22),
              SizedBox(width: 8),
              Text("Résumé du projet", style: AppTypography.h2),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.project.name, style: AppTypography.h3),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18),
              const SizedBox(width: 4),
              Text("${widget.project.location.city}, ${widget.project.location.country}",
                  style: AppTypography.body),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.timelapse, size: 18),
              const SizedBox(width: 4),
              Text("Autonomie : ${widget.project.autonomyDays} jours",
                  style: AppTypography.body),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.flash_on, size: 18),
              const SizedBox(width: 4),
              Text("Conso journalière : ${dailyConsumption.toStringAsFixed(2)} kWh/j",
                  style: AppTypography.body),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pumpSection() {
    return Column(
      children: [
        _buildDropdown<Pump>(
          icon: Icons.water,
          label: "Pompe",
          items: pumpList,
          value: selectedPump,
          onChanged: (v) => setState(() => selectedPump = v),
        ),

        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.water, size: 22, color: Colors.white),
            label: const Text("Catalogue complet des pompes", style: AppTypography.h3),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueDeep,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final pump = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PumpSelectionView(project: widget.project),
                ),
              );

              if (pump != null) {
                setState(() => selectedPump = pump);
              }
            },
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle, size: 22),
            label: const Text("Créer une pompe personnalisée", style: AppTypography.h3),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueLight,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PumpFormPage(
                    onPumpSelected: (pump) {
                      setState(() {
                        pumpList.add(pump);
                        selectedPump = pump;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
Widget _pvStringsButton() {
  return SizedBox(
    height: 52,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.cable, size: 22),
      onPressed: selectedPanel != null
          ? () {
              widget.project.selectedPanel = selectedPanel;
              widget.project.selectedBattery = selectedBattery;
              widget.project.selectedInverter = selectedInverter;
              widget.project.selectedRegulator = selectedRegulator;
              widget.project.selectedPump = selectedPump;

              widget.project.computePVProduction();
              widget.project.computePVSize();
              widget.project.computePVStrings();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PvStringsView(project: widget.project),
                ),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedPanel != null ? AppTheme.blueDeep : Colors.grey.shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26), // harmonisation premium
        ),
      ),
      label: const Text("Branchement série / parallèle", style: AppTypography.h3),
    ),
  );
}

Widget _continueButton(bool isValid) {
  return SizedBox(
    height: 52,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.arrow_forward, size: 22),
      onPressed: isValid ? _continue : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isValid ? AppTheme.blueLight : Colors.grey.shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26), // harmonisation premium
        ),
      ),
      label: const Text("Continuer vers simulation", style: AppTypography.h3),
    ),
  );
}

Widget _buildDropdown<T>({
  required IconData icon,
  required String label,
  required List<T> items,
  required T? value,
  required ValueChanged<T?> onChanged,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(16),
    decoration: AppTheme.glassCard,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.blueDeep, size: 22),
            const SizedBox(width: 8),
            Text(label, style: AppTypography.h3),
          ],
        ),

        const SizedBox(height: 12),

        DropdownButtonFormField<T>(
          isExpanded: true,
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(26), // harmonisation premium
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
          style: const TextStyle(fontSize: 15),
          hint: Text("Sélectionner $label", style: AppTypography.body),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(_displayName(e), style: AppTypography.body),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

Widget _buildDiagnosticCard() {
  final diag = widget.project.diagnostic();
  if (diag.isEmpty) return const SizedBox.shrink();

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: AppTheme.glassCard,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.health_and_safety, color: AppTheme.blueDeep, size: 22),
            SizedBox(width: 8),
            Text("Diagnostic compatibilité", style: AppTypography.h2),
          ],
        ),

        const SizedBox(height: 12),

        ...diag.entries.map((e) {
          final isOk = e.value.startsWith("✔");
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  isOk ? Icons.check_circle : Icons.error,
                  color: isOk ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "${e.key} : ${e.value}",
                    style: TextStyle(
                      color: isOk ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Manrope",
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}

  String _displayName<T>(T item) {
    final dyn = item as dynamic;

    if (dyn.name != null && dyn.name is String && dyn.name.isNotEmpty) {
      return dyn.name;
    }
    if (dyn.model != null) return dyn.model.toString();
    if (dyn.reference != null) return dyn.reference.toString();

    return item.toString();
  }
}
