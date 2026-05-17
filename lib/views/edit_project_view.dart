import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/project_model.dart';
import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';

class EditProjectView extends StatefulWidget {
  final ProjectModel project;

  const EditProjectView({super.key, required this.project});

  @override
  State<EditProjectView> createState() => _EditProjectViewState();
}

class _EditProjectViewState extends State<EditProjectView> {
  late final TextEditingController nameCtrl;
  late final TextEditingController cityCtrl;
  late final TextEditingController countryCtrl;
  late final TextEditingController orientationCtrl;
  late final TextEditingController tiltCtrl;
  late final TextEditingController latitudeCtrl;
  late final TextEditingController longitudeCtrl;
  late final TextEditingController autonomyCtrl;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.project.name);
    cityCtrl = TextEditingController(text: widget.project.city);
    countryCtrl = TextEditingController(text: widget.project.country);

    orientationCtrl = TextEditingController(
      text: widget.project.orientation.toString(),
    );
    tiltCtrl = TextEditingController(text: widget.project.tilt.toString());

    latitudeCtrl = TextEditingController(
      text: widget.project.latitude.toString(),
    );
    longitudeCtrl = TextEditingController(
      text: widget.project.longitude.toString(),
    );

    autonomyCtrl = TextEditingController(
      text: widget.project.autonomyDays.toString(),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    cityCtrl.dispose();
    countryCtrl.dispose();
    orientationCtrl.dispose();
    tiltCtrl.dispose();
    latitudeCtrl.dispose();
    longitudeCtrl.dispose();
    autonomyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: FadeSlide(
          delay: 100,
          child: const Text(
            "Modifier le projet",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FadeScale(
            delay: 150,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.whiteCard.copyWith(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  _field("Nom du projet", nameCtrl),
                  _field("Ville", cityCtrl),
                  _field("Pays", countryCtrl),
                  _field("Latitude", latitudeCtrl),
                  _field("Longitude", longitudeCtrl),
                  _field("Inclinaison (°)", tiltCtrl),
                  _field("Orientation (°)", orientationCtrl),
                  _field("Autonomie (jours)", autonomyCtrl),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          FadeSlide(
            delay: 250,
            child: SizedBox(
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.blueDeep,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveProject,
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // CHAMP PREMIUM
  // ---------------------------------------------------------
  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // SAUVEGARDE DU PROJET
  // ---------------------------------------------------------
  void _saveProject() {
    widget.project
      ..name = nameCtrl.text
      ..city = cityCtrl.text
      ..country = countryCtrl.text
      ..latitude = double.tryParse(latitudeCtrl.text) ?? 0
      ..longitude = double.tryParse(longitudeCtrl.text) ?? 0
      ..tilt = double.tryParse(tiltCtrl.text) ?? 0
      ..orientation = double.tryParse(orientationCtrl.text) ?? 0
      ..autonomyDays = double.tryParse(autonomyCtrl.text) ?? 1
      ..save();

    Navigator.pop(context);
  }
}
