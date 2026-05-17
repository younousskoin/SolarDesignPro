import 'package:flutter/material.dart';
import '../theme.dart';
import '../domain/project.dart';
import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';
import '../widgets/slide_fade_horizontal.dart';

class DashboardView extends StatelessWidget {
  final Project project;

  const DashboardView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 900;
    final bool isTablet = width >= 600 && width < 900;

    // 🔥 Calculs essentiels
    final double dailyConsumption = project.dailyConsumption;
    final double dailyPV = project.monthlyProduction.isNotEmpty
        ? project.monthlyProduction[0]
        : 0;

    final double losses = project.totalLossPercent;
    final double pr = project.pr * 100;
    final double autonomy = project.realAutonomyDays;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SlideFadeHorizontal(
          delay: 100,
          child: Text(
            "Projet : ${project.name}",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          FadeSlide(
            delay: 150,
            child: Text(
              "Tableau de bord",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppTheme.blueDeep,
              ),
            ),
          ),
          const SizedBox(height: 6),

          FadeSlide(
            delay: 200,
            child: Text(
              "Analyse et indicateurs clés du système solaire",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),

          const SizedBox(height: 20),

          // 🔷 Informations générales
          FadeScale(
            delay: 250,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: AppTheme.whiteCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    "Localisation",
                    "${project.location.city}, ${project.location.country}",
                  ),
                  _infoRow("Type de système", project.systemType.label),
                  _infoRow("Inclinaison", "${project.tilt}°"),
                  _infoRow("Orientation", "${project.orientation}°"),
                  _infoRow(
                    "Autonomie demandée",
                    "${project.autonomyDays} jours",
                  ),
                  _infoRow(
                    "Conso journalière",
                    "${dailyConsumption.toStringAsFixed(2)} kWh/j",
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 🔷 Cartes de métriques
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _metricCard(
                context: context,
                title: "Production journalière",
                value: "${dailyPV.toStringAsFixed(2)} kWh/j",
                icon: Icons.bolt_rounded,
                delay: 300,
                width: isDesktop
                    ? 260
                    : isTablet
                    ? 240
                    : double.infinity,
              ),
              _metricCard(
                context: context,
                title: "Pertes système",
                value: "${losses.toStringAsFixed(1)} %",
                icon: Icons.trending_down_rounded,
                delay: 350,
                width: isDesktop
                    ? 260
                    : isTablet
                    ? 240
                    : double.infinity,
              ),
              _metricCard(
                context: context,
                title: "Rendement global (PR)",
                value: "${pr.toStringAsFixed(1)} %",
                icon: Icons.speed_rounded,
                delay: 400,
                width: isDesktop
                    ? 260
                    : isTablet
                    ? 240
                    : double.infinity,
              ),
              _metricCard(
                context: context,
                title: "Autonomie batterie",
                value: "${autonomy.toStringAsFixed(1)} jours",
                icon: Icons.battery_charging_full_rounded,
                delay: 450,
                width: isDesktop
                    ? 260
                    : isTablet
                    ? 240
                    : double.infinity,
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 🔥🔥🔥 NOUVELLE CARTE : CONFIGURATION PV 🔥🔥🔥
          FadeScale(
            delay: 500,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: AppTheme.whiteCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Configuration PV",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.blueDeep,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _infoRow(
                    "Panneaux en série",
                    "${project.pvSeriesCount} panneaux",
                  ),
                  _infoRow(
                    "Strings en parallèle",
                    "${project.pvParallelCount} strings",
                  ),

                  const SizedBox(height: 10),

                  _infoRow(
                    "Voc total string",
                    "${project.pvVocString.toStringAsFixed(1)} V",
                  ),
                  _infoRow(
                    "Vmp total string",
                    "${project.pvVmpString.toStringAsFixed(1)} V",
                  ),

                  const SizedBox(height: 10),

                  _infoRow(
                    "Imp total",
                    "${project.pvImpString.toStringAsFixed(2)} A",
                  ),
                  _infoRow(
                    "Isc total",
                    "${project.pvIscString.toStringAsFixed(2)} A",
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/pv_strings',
                          arguments: project,
                        );
                      },
                      child: const Text(
                        "Voir les détails",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          _sectionTitle("Courbe de production", 600),
          FadeScale(delay: 620, child: _chartPlaceholder(height: 220)),
          const SizedBox(height: 40),

          _sectionTitle("Répartition des pertes", 650),
          FadeScale(delay: 670, child: _chartPlaceholder(height: 220)),
          const SizedBox(height: 40),

          _sectionTitle("Profil de consommation", 700),
          FadeScale(delay: 720, child: _chartPlaceholder(height: 220)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 Widgets utilitaires
  // ---------------------------------------------------------

  Widget _sectionTitle(String text, int delay) {
    return SlideFadeHorizontal(
      delay: delay,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "Non renseigné" : value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required int delay,
    required double width,
  }) {
    return FadeScale(
      delay: delay,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/metric_detail',
            arguments: {"title": title, "value": value, "icon": icon},
          );
        },
        child: Hero(
          tag: "metric_$title",
          child: Container(
            width: width,
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.whiteCard,
            child: Row(
              children: [
                Icon(icon, size: 36, color: AppTheme.blueDeep),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chartPlaceholder({required double height}) {
    return Container(
      height: height,
      decoration: AppTheme.whiteCard,
      child: const Center(
        child: Text("Graphique ici", style: TextStyle(color: Colors.black45)),
      ),
    );
  }
}
