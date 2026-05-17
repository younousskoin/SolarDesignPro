import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/project_model.dart';
import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';
import '../domain/system_type.dart';
import '../views/results_view.dart';
import '../domain/project.dart';
import '../views/pdf_viewer_page.dart';

class ProjectDetailsView extends StatelessWidget {
  final ProjectModel project;

  const ProjectDetailsView({super.key, required this.project});

  // ---------------------------------------------------------
  // WIDGET KPI CARD PREMIUM
  // ---------------------------------------------------------
  Widget _kpiCard({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: "Manrope",
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                fontFamily: "Manrope",
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // WIDGET INFO LIGNE PREMIUM
  // ---------------------------------------------------------
  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: "Manrope",
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                fontFamily: "Manrope",
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // CONSOMMATION JOURNALIÈRE
  // ---------------------------------------------------------
  double _dailyConsumption(List<double> hourly) {
    if (hourly.isEmpty) return 0;
    return hourly.reduce((a, b) => a + b);
  }

  // ---------------------------------------------------------
  // OUVERTURE DIMENSIONNEMENT
  // ---------------------------------------------------------
  void _openDimensioning(BuildContext context) {
    Navigator.pushNamed(
      context,
      "/project_input",
      arguments: project.systemType,
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final Project domain = project.toDomain();

    double socMin = 0;
    double socMax = 0;
    if (domain.socDaily.isNotEmpty) {
      socMin = domain.socDaily.reduce((a, b) => a < b ? a : b);
      socMax = domain.socDaily.reduce((a, b) => a > b ? a : b);
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      // ---------------------------------------------------------
      // APPBAR PREMIUM
      // ---------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: FadeSlide(
          delay: 100,
          child: Text(
            project.name,
            style: const TextStyle(
              fontFamily: "Manrope",
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      // ---------------------------------------------------------
      // BODY PREMIUM
      // ---------------------------------------------------------
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          // -----------------------------------------------------
          // HEADER PREMIUM
          // -----------------------------------------------------
          Hero(
            tag: "project_${project.createdAt.toIso8601String()}",
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.whiteCard.copyWith(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.blueLight.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.solar_power_rounded,
                      size: 42,
                      color: AppTheme.blueDeep,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Projet",
                        style: TextStyle(
                          fontFamily: "Manrope",
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontFamily: "Manrope",
                          color: Colors.black87,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // -----------------------------------------------------
          // INFOS GÉNÉRALES PREMIUM
          // -----------------------------------------------------
          FadeScale(
            delay: 200,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: AppTheme.whiteCard.copyWith(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _info("Ville", project.city),
                  _info("Pays", project.country),
                  _info(
                    "Type de système",
                    systemTypeLabel(
                      PVSystemTypeFeatures.fromKey(project.systemType),
                    ),
                  ),
                  _info("Consommation",
                      "${_dailyConsumption(project.hourlyConsumption)} kWh/j"),
                  _info("Inclinaison", "${project.tilt}°"),
                  _info("Orientation", "${project.orientation}°"),
                  _info("Latitude", "${project.latitude}°"),
                  _info("Longitude", "${project.longitude}°"),
                  _info("Autonomie", "${project.autonomyDays} jours"),
                  _info("Créé le",
                      project.createdAt.toLocal().toString().split(".")[0]),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // -----------------------------------------------------
          // BILAN ÉNERGÉTIQUE PREMIUM
          // -----------------------------------------------------
          FadeScale(
            delay: 250,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: AppTheme.whiteCard.copyWith(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bilan énergétique",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: _kpiCard(
                          label: "Production annuelle",
                          value:
                              "${domain.annualProduction.toStringAsFixed(0)} kWh/an",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _kpiCard(
                          label: "Consommation annuelle",
                          value:
                              "${domain.annualConsumption.toStringAsFixed(0)} kWh/an",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _kpiCard(
                          label: "Couverture PV",
                          value:
                              "${(domain.pvCoverage * 100).toStringAsFixed(1)} %",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _kpiCard(
                          label: "Autonomie réelle",
                          value:
                              "${domain.realAutonomyDays.toStringAsFixed(1)} jours",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _kpiCard(
                          label: "SOC min / max (24h)",
                          value:
                              "${socMin.toStringAsFixed(0)} % / ${socMax.toStringAsFixed(0)} %",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _kpiCard(
                          label: "PR global",
                          value: "${(domain.pr * 100).toStringAsFixed(1)} %",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // -----------------------------------------------------
          // ACTIONS PREMIUM
          // -----------------------------------------------------
          FadeSlide(
            delay: 300,
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 12,
              runSpacing: 12,
              children: [
                // Voir les résultats
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultsView(project: domain),
                      ),
                    );
                  },
                  child: const Text(
                    "Voir les résultats",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 15,
                      color: AppTheme.blueDeep,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Voir le PDF
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewerPage(project: domain),
                      ),
                    );
                  },
                  child: const Text(
                    "Voir le rapport PDF",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Modifier
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/project_input",
                      arguments: project.systemType,
                    );
                  },
                  child: const Text(
                    "Modifier",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Dupliquer
                TextButton.icon(
                  icon: const Icon(Icons.copy, color: Colors.black87),
                  label: const Text(
                    "Dupliquer",
                    style: TextStyle(fontFamily: "Manrope"),
                  ),
                  onPressed: () async {
                    final box = Hive.box<ProjectModel>("projects");
                    final clone = ProjectModel.fromProject(domain);
                    clone.name = "${project.name} (copie)";
                    await box.add(clone);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Projet dupliqué avec succès"),
                        backgroundColor: AppTheme.blueDeep,
                      ),
                    );
                  },
                ),

                // Supprimer
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Supprimer",
                    style: TextStyle(fontFamily: "Manrope"),
                  ),
                  onPressed: () async {
                    final box = Hive.box<ProjectModel>("projects");
                    await box.deleteAt(box.values.toList().indexOf(project));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Projet supprimé"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );

                    Navigator.pop(context);
                  },
                ),

                // Lancer le dimensionnement
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.blueDeep,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => _openDimensioning(context),
                  child: const Text(
                    "Lancer le dimensionnement",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
