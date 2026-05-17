import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';

/// ------------------------------------------------------------
/// 🔹 Modèle de série (DOIT être en dehors de la classe)
/// ------------------------------------------------------------
class SeriesData {
  final String label;
  final Color color;
  final List<double> values;

  SeriesData({
    required this.label,
    required this.color,
    required this.values,
  });
}

/// ------------------------------------------------------------
/// 🔷 Légende scientifique premium
/// ------------------------------------------------------------
Widget _legend(List<SeriesData> series) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Wrap(
      spacing: 20,
      runSpacing: 8,
      children: [
        for (final s in series)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: s.color,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: s.color.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                s.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

/// ------------------------------------------------------------
/// 🔥 UltraPremiumCharts — version complète + légende intégrée
/// ------------------------------------------------------------
class UltraPremiumCharts extends StatelessWidget {
  // Données existantes
  final List<double> monthlyProduction;
  final List<double> monthlyConsumption;

  final List<double> pvPowerDaily;
  final List<double> socDaily;
  final List<double> surplusDaily;
  final List<double> deficitDaily;
  final List<double> batteryChargeDaily;
  final List<double> batteryDischargeDaily;
  final List<double> inverterLoadDaily;

  final List<double> pvHourly8760;
  final List<double> socHourly8760;

  // 🔥 Nouvelles données 24h
  final List<double> hourlyConsumption;
  final List<double> ghi24h;
  final List<double> temperature24h;

  const UltraPremiumCharts({
    super.key,
    required this.monthlyProduction,
    required this.monthlyConsumption,
    required this.pvPowerDaily,
    required this.socDaily,
    required this.surplusDaily,
    required this.deficitDaily,
    required this.batteryChargeDaily,
    required this.batteryDischargeDaily,
    required this.inverterLoadDaily,
    required this.pvHourly8760,
    required this.socHourly8760,
    required this.hourlyConsumption,
    required this.ghi24h,
    required this.temperature24h,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _chartCard(
          title: "Production vs consommation (mensuelle)",
          icon: Icons.calendar_month,
          child: _multiLineChart(
            series: [
              SeriesData(
                label: "Production",
                color: AppTheme.blueDeep,
                values: monthlyProduction,
              ),
              SeriesData(
                label: "Consommation",
                color: Colors.orange,
                values: monthlyConsumption,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _chartCard(
          title: "PV vs Consommation (24h)",
          icon: Icons.bolt,
          child: _multiLineChart(
            series: [
              SeriesData(
                label: "PV (24h)",
                color: AppTheme.blueDeep,
                values: pvPowerDaily,
              ),
              SeriesData(
                label: "Conso (24h)",
                color: Colors.orange,
                values: hourlyConsumption,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _chartCard(
          title: "Irradiation & Température (24h)",
          icon: Icons.sunny,
          child: _multiLineChart(
            series: [
              SeriesData(
                label: "GHI (24h)",
                color: Colors.amber,
                values: ghi24h,
              ),
              SeriesData(
                label: "Température (24h)",
                color: Colors.redAccent,
                values: temperature24h,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _chartCard(
          title: "État de charge batterie (SOC 24h)",
          icon: Icons.battery_full,
          child: _singleLineChart(
            label: "SOC",
            color: AppTheme.blueLight,
            values: socDaily,
          ),
        ),

        const SizedBox(height: 16),

        _chartCard(
          title: "Surplus / Déficit (24h)",
          icon: Icons.compare_arrows,
          child: _multiLineChart(
            series: [
              SeriesData(
                label: "Surplus",
                color: Colors.green,
                values: surplusDaily,
              ),
              SeriesData(
                label: "Déficit",
                color: Colors.red,
                values: deficitDaily,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _chartCard(
          title: "Charge / Décharge batterie (24h)",
          icon: Icons.battery_charging_full,
          child: _multiLineChart(
            series: [
              SeriesData(
                label: "Charge",
                color: AppTheme.blueDeep,
                values: batteryChargeDaily,
              ),
              SeriesData(
                label: "Décharge",
                color: Colors.orange,
                values: batteryDischargeDaily,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _chartCard(
          title: "Charge onduleur (24h)",
          icon: Icons.power,
          child: _singleLineChart(
            label: "Charge onduleur",
            color: Colors.purple,
            values: inverterLoadDaily,
          ),
        ),

        const SizedBox(height: 16),

        _chartCard(
          title: "PV & SOC (8760h)",
          icon: Icons.timeline,
          child: _multiLineChart(
            series: [
              SeriesData(
                label: "PV (8760h)",
                color: AppTheme.blueDeep.withOpacity(0.7),
                values: _downsample(pvHourly8760, 365),
              ),
              SeriesData(
                label: "SOC (8760h)",
                color: Colors.green.withOpacity(0.7),
                values: _downsample(socHourly8760, 365),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 🔧 UI Helpers
  // ---------------------------------------------------------
  Widget _chartCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.whiteCard.copyWith(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.blueDeep),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: child),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔧 Charts
  // ---------------------------------------------------------
  Widget _singleLineChart({
    required String label,
    required Color color,
    required List<double> values,
  }) {
    return _multiLineChart(
      series: [
        SeriesData(label: label, color: color, values: values),
      ],
    );
  }

  Widget _multiLineChart({required List<SeriesData> series}) {
    if (series.isEmpty || series.first.values.isEmpty) {
      return const Center(child: Text("Aucune donnée"));
    }

    final int length = series.first.values.length;

    double minY = series.first.values.first;
    double maxY = series.first.values.first;

    for (final s in series) {
      for (final v in s.values) {
        if (v < minY) minY = v;
        if (v > maxY) maxY = v;
      }
    }

    if (minY == maxY) {
      minY -= 1;
      maxY += 1;
    }

    return Column(
      children: [
        _legend(series),

        Expanded(
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (length - 1).toDouble(),
              minY: minY,
              maxY: maxY,

              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: (maxY - minY) / 5,
                verticalInterval: (length / 6).toDouble(),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.25),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.15),
                  strokeWidth: 1,
                ),
              ),

              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: (maxY - minY) / 5,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (length / 6).toDouble(),
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),

              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey.shade300),
              ),

              lineBarsData: [
                for (final s in series)
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: s.color,
                    barWidth: 3,
                    shadow: Shadow(
                      color: s.color.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 1,
                            strokeColor: s.color,
                          ),
                    ),
                    spots: [
                      for (int i = 0; i < s.values.length; i++)
                        FlSpot(i.toDouble(), s.values[i]),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // 🔧 Downsample 8760h → 365 points
  // ---------------------------------------------------------
  List<double> _downsample(List<double> data, int targetLength) {
    if (data.isEmpty || data.length <= targetLength) return data;

    final factor = data.length / targetLength;
    final List<double> result = [];

    for (int i = 0; i < targetLength; i++) {
      final start = (i * factor).floor();
      final end = ((i + 1) * factor).floor().clamp(start + 1, data.length);
      final slice = data.sublist(start, end);
      final avg = slice.reduce((a, b) => a + b) / slice.length;
      result.add(avg);
    }

    return result;
  }
}
