import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/project_model.dart';
import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/staggered_list.dart';
import '../views/project_details_view.dart';
import '../views/pdf_viewer_page.dart';
import '../domain/project.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  final TextEditingController searchCtrl = TextEditingController();
  String query = "";

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(() {
      setState(() => query = searchCtrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ProjectModel>('projects');

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
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
        title: const Text(
          "Mes projets",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.blueDeep,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nouveau projet", style: TextStyle(color: Colors.white)),
        onPressed: () => Navigator.pushNamed(context, '/newProject'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<ProjectModel> box, _) {
          final allProjects = box.values.toList().reversed.toList();

          final filtered = allProjects.where((p) {
            final name = p.name.toLowerCase();
            final city = p.city.toLowerCase();
            final country = p.country.toLowerCase();
            final type = p.systemType.toLowerCase();
            return name.contains(query) ||
                city.contains(query) ||
                country.contains(query) ||
                type.contains(query);
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              FadeSlide(
                delay: 80,
                child: TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    hintText: "Rechercher un projet...",
                    prefixIcon: const Icon(Icons.search, color: Colors.black45),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (filtered.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "Aucun projet trouvé",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ),
              if (filtered.isNotEmpty)
                StaggeredList(
                  initialDelay: 120,
                  step: 90,
                  children: [
                    for (int i = 0; i < filtered.length; i++)
                      _projectCard(context, filtered[i], i),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _projectCard(BuildContext context, ProjectModel model, int index) {
    final domain = model.toDomain();
    final isValid = model.name.isNotEmpty && _dailyConsumption(model.hourlyConsumption) > 0;

    return FadeSlide(
      delay: 100 + index * 90,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProjectDetailsView(project: model)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: AppTheme.whiteCard.copyWith(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.06),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔷 En-tête
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.blueLight.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.solar_power_rounded,
                        size: 32, color: Colors.black87),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 18, color: Colors.black45),
                            const SizedBox(width: 4),
                            Text("${model.city}, ${model.country}",
                                style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.bolt,
                                size: 18, color: Colors.black45),
                            const SizedBox(width: 4),
                            Text(
                              "Conso : ${_dailyConsumption(model.hourlyConsumption).toStringAsFixed(2)} kWh/j",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.solar_power,
                                size: 18, color: Colors.black45),
                            const SizedBox(width: 4),
                            Text("Type : ${_systemTypeLabel(model.systemType)}",
                                style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                    tooltip: "Voir le rapport PDF",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PdfViewerPage(project: domain)),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 🔷 Boutons d’action
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isValid)
                    TextButton.icon(
                      icon: const Icon(Icons.copy, color: Colors.black87),
                      label: const Text("Dupliquer"),
                      onPressed: () async {
                        final box = Hive.box<ProjectModel>("projects");
                        final clone = ProjectModel.fromProject(domain);
                        clone.name = "${model.name} (copie)";
                        await box.add(clone);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Projet dupliqué avec succès"),
                            backgroundColor: AppTheme.blueDeep,
                          ),
                        );
                      },
                    ),
                  const SizedBox(width: 8),
                  if (isValid)
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text("Supprimer"),
                      onPressed: () async {
                        final box = Hive.box<ProjectModel>("projects");
                        await model.delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Projet supprimé"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _dailyConsumption(List<double> hourly) {
    if (hourly.isEmpty) return 0;
    return hourly.reduce((a, b) => a + b);
  }

  String _systemTypeLabel(String key) {
    switch (key) {
      case "offGrid":
      case "isolated":
        return "Système isolé";

      case "hybrid":
        return "Système hybride";

      case "onGrid":
      case "selfconsumption":
        return "Autoconsommation";

      case "pumping":
      case "pumpingWithStorage":
        return "Pompage solaire";

      case "minigrid":
        return "Mini-réseau";

      default:
        return "Personnalisé";
    }
  }
}
