import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/project.dart';
import '../domain/location_data.dart';
import '../domain/meteo_data.dart';
import '../domain/system_type.dart';
import '../models/project_model.dart';
import '../pages/component_selection_view.dart';
import '../services/meteo_service.dart';

// ⭐ NOUVEAUX IMPORTS PREMIUM
import '../core/theme/app_theme.dart';
import '../core/theme/app_typography.dart';
import '../core/theme/app_spacing.dart';


class ProjectInputView extends StatefulWidget {
  final PVSystemType? preselectedType;

  const ProjectInputView({super.key, this.preselectedType});

  @override
  State<ProjectInputView> createState() => _ProjectInputViewState();
}

class _ProjectInputViewState extends State<ProjectInputView> {
  int _currentStep = 0;

  // ---------------------------------------------------------
  // FORM CONTROLLERS
  // ---------------------------------------------------------
  final nameCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final latCtrl = TextEditingController();
  final lonCtrl = TextEditingController();
  final tiltCtrl = TextEditingController(text: "30");
  final orientCtrl = TextEditingController(text: "0");
  final autonomyCtrl = TextEditingController(text: "1");

  final hourlyCtrl = List.generate(24, (_) => TextEditingController(text: "0"));
  final ghiCtrl = List.generate(12, (_) => TextEditingController(text: "5"));
  final dhiCtrl = List.generate(12, (_) => TextEditingController(text: "1"));
  final dniCtrl = List.generate(12, (_) => TextEditingController(text: "4"));
  final tempCtrl = List.generate(12, (_) => TextEditingController(text: "25"));

  bool loadingMeteo = false;

  late PVSystemType _selectedType;

  ProjectModel? _editingModel;
  bool _initializedFromArgs = false;

  bool get _isEditing => _editingModel != null;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.preselectedType ?? PVSystemType.offGrid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initializedFromArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is ProjectModel) {
      _editingModel = args;
      _loadFromModel(args);
    } else if (args is PVSystemType) {
      _selectedType = args;
    }

    _initializedFromArgs = true;
  }

  // ---------------------------------------------------------
  // LOAD EXISTING PROJECT
  // ---------------------------------------------------------
  void _loadFromModel(ProjectModel m) {
    nameCtrl.text = m.name;
    cityCtrl.text = m.city;
    countryCtrl.text = m.country;
    latCtrl.text = "${m.latitude}";
    lonCtrl.text = "${m.longitude}";
    tiltCtrl.text = "${m.tilt}";
    orientCtrl.text = "${m.orientation}";
    autonomyCtrl.text = "${m.autonomyDays}";

    for (int i = 0; i < 24; i++) {
      if (i < m.hourlyConsumption.length) {
        hourlyCtrl[i].text = "${m.hourlyConsumption[i]}";
      }
    }

    for (int i = 0; i < 12; i++) {
      if (i < m.ghi.length) ghiCtrl[i].text = "${m.ghi[i]}";
      if (i < m.dhi.length) dhiCtrl[i].text = "${m.dhi[i]}";
      if (i < m.dni.length) dniCtrl[i].text = "${m.dni[i]}";
      if (i < m.temperature.length) tempCtrl[i].text = "${m.temperature[i]}";
    }

    try {
      _selectedType = PVSystemType.values.firstWhere(
        (t) => t.key == m.systemType,
      );
    } catch (_) {
      _selectedType = widget.preselectedType ?? PVSystemType.offGrid;
    }

    setState(() {});
  }

  // ---------------------------------------------------------
  // UI BUILD
  // ---------------------------------------------------------
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
        title: Text(
          _isEditing ? "Modifier le projet" : "Création du projet",
          style: AppTypography.h2,
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  children: [
                    _buildStepperHeader(),
                    const SizedBox(height: AppSpacing.md),
                    _buildStepContent(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: _buildNavigationButtons(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------
  Widget _buildStepperHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Configuration du projet", style: AppTypography.h1),
        SizedBox(height: 8),
        Text(
          "Complétez les étapes ci-dessous pour définir votre projet.",
          style: AppTypography.body,
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // STEPPER CONTENT
  // ---------------------------------------------------------
  Widget _buildStepContent() {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: _nextStep,
      onStepCancel: _previousStep,
      controlsBuilder: (context, details) => const SizedBox.shrink(),
      steps: [
        Step(title: const Text("Informations générales"), content: _card(_buildGeneralInfoForm())),
        Step(title: const Text("Localisation"), content: _card(_buildLocationForm())),
        Step(title: const Text("Consommation"), content: _card(_buildConsumptionForm())),
        Step(title: const Text("Données météo"), content: _card(_buildMeteoForm())),
        Step(title: const Text("Système PV"), content: _card(_buildSystemForm())),
      ],
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassCard,
      child: child,
    );
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  // ---------------------------------------------------------
  // FORMS
  // ---------------------------------------------------------
  Widget _buildGeneralInfoForm() {
    return Column(
      children: [
        _field("Nom du projet", nameCtrl),
        _field("Autonomie (jours)", autonomyCtrl, number: true),
      ],
    );
  }

  Widget _buildLocationForm() {
    return Column(
      children: [
        _field("Ville", cityCtrl),
        _field("Pays", countryCtrl),
        _field("Latitude", latCtrl, number: true),
        _field("Longitude", lonCtrl, number: true),
      ],
    );
  }

  Widget _buildConsumptionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Consommation horaire (24 valeurs)", style: AppTypography.h3),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(24, (i) {
            return SizedBox(
              width: 70,
              child: _field("$i h", hourlyCtrl[i], number: true),
            );
          }),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // MÉTÉO + NASA POWER
  // ---------------------------------------------------------
  Widget _buildMeteoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.cloud_download_rounded, size: 22),
            label: const Text("Importer depuis NASA", style: AppTypography.h3),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueDeep,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: loadingMeteo ? null : _importNASA,
          ),
        ),

        if (loadingMeteo)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: CircularProgressIndicator(
                color: AppTheme.blueDeep,
                strokeWidth: 3,
              ),
            ),
          ),

        const SizedBox(height: AppSpacing.md),

        _label("Irradiation GHI (kWh/m²/j)"),
        _monthGrid(ghiCtrl),

        const SizedBox(height: AppSpacing.md),
        _label("Irradiation diffuse DHI"),
        _monthGrid(dhiCtrl),

        const SizedBox(height: AppSpacing.md),
        _label("Irradiation directe DNI"),
        _monthGrid(dniCtrl),

        const SizedBox(height: AppSpacing.md),
        _label("Température moyenne (°C)"),
        _monthGrid(tempCtrl),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppTypography.h3),
    );
  }

  Widget _monthGrid(List<TextEditingController> ctrls) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(12, (i) {
        return SizedBox(
          width: 70,
          child: _field("M${i + 1}", ctrls[i], number: true),
        );
      }),
    );
  }

  // ---------------------------------------------------------
  // NASA IMPORT
  // ---------------------------------------------------------
  Future<void> _importNASA() async {
    latCtrl.clear();
    lonCtrl.clear();

    setState(() => loadingMeteo = true);

    final data = await MeteoService.fetchMeteo(
      cityCtrl.text.trim(),
      countryCtrl.text.trim(),
    );

    setState(() => loadingMeteo = false);

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'importer les données NASA"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    for (int i = 0; i < 12; i++) {
      ghiCtrl[i].text = data.irradiationMonthly[i].toStringAsFixed(2);
      dhiCtrl[i].text = data.diffuseMonthly[i].toStringAsFixed(2);
      dniCtrl[i].text = data.directMonthly[i].toStringAsFixed(2);
      tempCtrl[i].text = data.temperatureMonthly[i].toStringAsFixed(1);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Données NASA importées avec succès"),
        backgroundColor: AppTheme.blueDeep,
      ),
    );
  }

  // ---------------------------------------------------------
  // SYSTÈME PV
  // ---------------------------------------------------------
  Widget _buildSystemForm() {
    return Column(
      children: [
        DropdownButtonFormField<PVSystemType>(
          value: _selectedType,
          decoration: _inputDecoration("Type de système"),
          items: PVSystemType.values.map((t) {
            return DropdownMenuItem(
              value: t,
              child: Text(systemTypeLabel(t), style: AppTypography.body),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedType = v!),
        ),
        _field("Inclinaison (°)", tiltCtrl, number: true),
        _field("Orientation (°)", orientCtrl, number: true),
      ],
    );
  }

  // ---------------------------------------------------------
  // NAVIGATION BUTTONS
  // ---------------------------------------------------------
  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.blueDeep),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Précédent", style: AppTypography.h3),
            ),
          ),

        if (_currentStep > 0) const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              if (_currentStep == 4) {
                final p = _buildFinalProject();
                p.computeAll();
                await _finishWithProject(p);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ComponentSelectionView(project: p),
                  ),
                );
              } else {
                setState(() => _currentStep++);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueDeep,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentStep == 4 ? "Choisir les composants" : "Suivant",
              style: AppTypography.h3,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // FINAL PROJECT BUILD
  // ---------------------------------------------------------
  Project _buildFinalProject() {
    final location = LocationData(
      city: cityCtrl.text,
      country: countryCtrl.text,
      latitude: double.tryParse(latCtrl.text) ?? 0,
      longitude: double.tryParse(lonCtrl.text) ?? 0,
    );

    final meteo = MeteoData(
      irradiationMonthly: List.generate(12, (i) => double.tryParse(ghiCtrl[i].text) ?? 0),
      diffuseMonthly: List.generate(12, (i) => double.tryParse(dhiCtrl[i].text) ?? 0),
      directMonthly: List.generate(12, (i) => double.tryParse(dniCtrl[i].text) ?? 0),
      temperatureMonthly: List.generate(12, (i) => double.tryParse(tempCtrl[i].text) ?? 0),
      windMonthly: List.filled(12, 2.0),
      humidityMonthly: List.filled(12, 60.0),
      windDirectionMonthly: List.filled(12, 180),
    );

    final hourly = List.generate(24, (i) => double.tryParse(hourlyCtrl[i].text) ?? 0);

    return Project(
      name: nameCtrl.text,
      location: location,
      meteo: meteo,
      systemType: _selectedType,
      hourlyConsumption: hourly,
      autonomyDays: double.tryParse(autonomyCtrl.text) ?? 1,
      tilt: double.tryParse(tiltCtrl.text) ?? 30,
      orientation: double.tryParse(orientCtrl.text) ?? 0,
    );
  }

  Future<void> _finishWithProject(Project p) async {
    final box = Hive.box<ProjectModel>("projects");
    final model = ProjectModel.fromProject(p);

    if (_isEditing) {
      final index = box.values.toList().indexOf(_editingModel!);
      if (index != -1) {
        await box.putAt(index, model);
      }
    } else {
      await box.add(model);
    }
  }

  // ---------------------------------------------------------
  // INPUT FIELD PREMIUM
  // ---------------------------------------------------------
  Widget _field(String label, TextEditingController ctrl, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: TextField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        style: AppTypography.body,
        decoration: _inputDecoration(label),
      ),
    );
  }

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
