import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../models/project_model.dart';
import '../domain/project.dart';
import '../domain/system_type.dart';
import 'package:fl_chart/fl_chart.dart';

class ProjectDetailsPage extends StatelessWidget {
  final ProjectModel model;

  const ProjectDetailsPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final Project project = model.toDomain();

    // 🔥 Calcul SOC + PV Power avant affichage
    project.computeSocDaily();
    project.computePvPowerDaily();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: FadeSlide(
          delay: 80,
          child: Text(
            project.name,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _headerCard(project),
          const SizedBox(height: 20),
          _infoCard(project),
          const SizedBox(height: 20),
          _dailyConsumptionChart(project),
          const SizedBox(height: 20),
          _pvProductionChart(project),
          const SizedBox(height: 20),
          _socChart(project),
          const SizedBox(height: 20),
          _surplusDeficitChart(project),
          const SizedBox(height: 20),
          _actionButtons(context, model),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // HEADER CARD
  // ---------------------------------------------------------
  Widget _headerCard(Project project) {
    return FadeSlide(
      delay: 120,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.whiteCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.black45),
                const SizedBox(width: 6),
                Text(
                  "${project.location.city}, ${project.location.country}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // INFO CARD
  // ---------------------------------------------------------
  Widget _infoCard(Project project) {
    return FadeSlide(
      delay: 160,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.whiteCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Type de système", project.systemType.label),
            _infoRow(
              "Conso journalière",
              "${project.dailyConsumption.toStringAsFixed(2)} kWh/j",
            ),
            _infoRow("Inclinaison", "${project.tilt}°"),
            _infoRow("Orientation", "${project.orientation}°"),
            _infoRow("Autonomie demandée", "${project.autonomyDays} jours"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

  // ---------------------------------------------------------
  // ⭐ COURBE 1 : CONSOMMATION JOURNALIÈRE
  // ---------------------------------------------------------
  Widget _dailyConsumptionChart(Project project) {
    final hourly = project.hourlyConsumption;
    if (hourly.isEmpty) return const SizedBox.shrink();

    return FadeSlide(
      delay: 180,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.whiteCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profil de consommation journalière",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final h = value.toInt();
                          if (h % 4 != 0) return const SizedBox.shrink();
                          return Text(
                            "$h h",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: [
                    for (int i = 0; i < hourly.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: hourly[i],
                            width: 8,
                            borderRadius: BorderRadius.circular(4),
                            color: AppTheme.blueDeep,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // ⭐ COURBE 2 : PV RÉEL vs PV THÉORIQUE
  // ---------------------------------------------------------
  Widget _pvProductionChart(Project project) {
    final ghi = project.meteo.irradiationMonthly;
    if (ghi.isEmpty) return const SizedBox.shrink();

    final pvTheo = ghi.map((g) => g * 0.0012).toList();
    final pvReal = pvTheo.map((p) => p * 0.82).toList();

    return FadeSlide(
      delay: 200,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.whiteCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Production PV — Réel vs Théorique",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final m = value.toInt();
                          if (m < 0 || m >= 12) return const SizedBox.shrink();
                          const months = [
                            "Jan",
                            "Fév",
                            "Mar",
                            "Avr",
                            "Mai",
                            "Jun",
                            "Jul",
                            "Aoû",
                            "Sep",
                            "Oct",
                            "Nov",
                            "Déc",
                          ];
                          return Text(
                            months[m],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: AppTheme.blueDeep,
                      barWidth: 3,
                      spots: [
                        for (int i = 0; i < pvTheo.length; i++)
                          FlSpot(i.toDouble(), pvTheo[i]),
                      ],
                    ),
                    LineChartBarData(
                      isCurved: true,
                      color: Colors.orange.shade700,
                      barWidth: 3,
                      spots: [
                        for (int i = 0; i < pvReal.length; i++)
                          FlSpot(i.toDouble(), pvReal[i]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // ⭐ COURBE 3 : SOC BATTERIE
  // ---------------------------------------------------------
  Widget _socChart(Project project) {
    final soc = project.socDaily;
    if (soc.isEmpty) return const SizedBox.shrink();

    return FadeSlide(
      delay: 220,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.whiteCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "État de charge batterie (SOC)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          "${value.toInt()}%",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final h = value.toInt();
                          if (h % 4 != 0) return const SizedBox.shrink();
                          return Text(
                            "$h h",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: AppTheme.blueDeep,
                      barWidth: 3,
                      spots: [
                        for (int i = 0; i < soc.length; i++)
                          FlSpot(i.toDouble(), soc[i].toDouble()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // ⭐ COURBE 4 : SURPLUS / DÉFICIT ÉNERGÉTIQUE
  // ---------------------------------------------------------
  Widget _surplusDeficitChart(Project project) {
    final pv = project.pvPowerDaily;
    final load = project.hourlyConsumption.map((e) => e * 1000).toList();

    if (pv.isEmpty || load.isEmpty) return const SizedBox.shrink();

    final diff = List<double>.generate(24, (i) => pv[i] - load[i]);

    return FadeSlide(
      delay: 240,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.whiteCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Surplus / Déficit énergétique (24h)",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  minY: diff.reduce((a, b) => a < b ? a : b),
                  maxY: diff.reduce((a, b) => a > b ? a : b),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          "${(value / 1000).toStringAsFixed(1)} kWh",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (value, meta) {
                          final h = value.toInt();
                          if (h % 4 != 0) return const SizedBox.shrink();
                          return Text(
                            "$h h",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black45,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: [
                    for (int i = 0; i < 24; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: diff[i],
                            width: 8,
                            borderRadius: BorderRadius.circular(4),
                            color: diff[i] >= 0
                                ? Colors.green.shade600
                                : Colors.red.shade600,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // ACTION BUTTONS (VERSION COMPLÈTE ET CORRIGÉE)
  // ---------------------------------------------------------
  Widget _actionButtons(BuildContext context, ProjectModel model) {
    return FadeSlide(
      delay: 200,
      child: Row(
        children: [
          // 🔵 MODIFIER
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.blueDeep,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                "Modifier",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/project_input",
                  arguments: model,
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          // 🟧 DUPLIQUER (CORRIGÉ)
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.copy, color: Colors.white),
              label: const Text(
                "Dupliquer",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final box = Hive.box<ProjectModel>('projects');

                final copy = ProjectModel(
                  name: "${model.name} (copie)",
                  city: model.city,
                  country: model.country,
                  latitude: model.latitude,
                  longitude: model.longitude,
                  tilt: model.tilt,
                  orientation: model.orientation,
                  autonomyDays: model.autonomyDays,
                  hourlyConsumption: List.from(model.hourlyConsumption),
                  ghi: List.from(model.ghi),
                  dhi: List.from(model.dhi),
                  dni: List.from(model.dni),
                  temperature: List.from(model.temperature),
                  systemType: model.systemType,

                  // Champs PV Strings
                  pvSeriesCount: model.pvSeriesCount,
                  pvParallelCount: model.pvParallelCount,
                  pvVocString: model.pvVocString,
                  pvVmpString: model.pvVmpString,
                  pvImpString: model.pvImpString,
                  pvIscString: model.pvIscString,
                  resultPanelCount: model.resultPanelCount,

                  // Compatibilités
                  panelRegulatorOK: model.panelRegulatorOK,
                  panelInverterOK: model.panelInverterOK,
                  batteryInverterOK: model.batteryInverterOK,
                  pumpInverterOK: model.pumpInverterOK,
                );

                await box.add(copy);
                Navigator.pop(context);
              },
            ),
          ),

          const SizedBox(width: 12),

          // 🔴 SUPPRIMER
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text(
                "Supprimer",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await model.delete();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
