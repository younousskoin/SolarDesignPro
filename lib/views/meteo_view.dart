import 'package:flutter/material.dart';
import '../services/meteoservice.dart';
import '../domain/meteo_data.dart';
import '../theme.dart';

class MeteoView extends StatefulWidget {
  final String city;
  final String country;

  const MeteoView({
    super.key,
    required this.city,
    required this.country,
  });

  @override
  State<MeteoView> createState() => _MeteoViewState();
}

class _MeteoViewState extends State<MeteoView> {
  MeteoData meteo = MeteoData.empty();
  bool loading = false;
  bool loaded = false;

  // ---------------------------------------------------------
  // 🔥 Import NASA POWER
  // ---------------------------------------------------------
  Future<void> _importNASA() async {
    setState(() => loading = true);

    final data = await MeteoService.fetchMeteo(
      widget.city,
      widget.country,
    );

    setState(() => loading = false);

    if (data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'importer les données NASA"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      meteo = data;
      loaded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Données NASA importées avec succès"),
        backgroundColor: AppTheme.blueDeep,
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔷 Carte premium
  // ---------------------------------------------------------
  Widget _card(String label, double value, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                fontSize: 14,
              )),
          const SizedBox(height: 6),
          Text(
            "${value.toStringAsFixed(1)} $unit",
            style: const TextStyle(
              fontFamily: "Manrope",
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔷 Section premium
  // ---------------------------------------------------------
  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "Manrope",
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        ...children,
        const SizedBox(height: 30),
      ],
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text(
          "Météo & Irradiation",
          style: TextStyle(
            fontFamily: "Manrope",
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          // -----------------------------------------------------
          // Bouton Import NASA
          // -----------------------------------------------------
          ElevatedButton.icon(
            icon: const Icon(Icons.cloud_download_rounded),
            label: const Text(
              "Importer depuis NASA",
              style: TextStyle(fontFamily: "Manrope"),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueDeep,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: loading ? null : _importNASA,
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.blueDeep,
                  strokeWidth: 3,
                ),
              ),
            ),

          if (!loading && loaded) ...[
            const SizedBox(height: 30),

            // -----------------------------------------------------
            // 🌞 Irradiation
            // -----------------------------------------------------
            _section("Irradiation solaire", [
              Row(
                children: [
                  Expanded(
                      child: _card("GHI (Globale)", meteo.irradiationMonthly[0],
                          "kWh/m²/j")),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _card("DNI (Directe)", meteo.directMonthly[0],
                          "kWh/m²/j")),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _card("DHI (Diffuse)", meteo.diffuseMonthly[0],
                          "kWh/m²/j")),
                ],
              ),
            ]),

            // -----------------------------------------------------
            // 🌡️ Température
            // -----------------------------------------------------
            _section("Température", [
              Row(
                children: [
                  Expanded(
                      child: _card("Température moyenne",
                          meteo.temperatureMonthly[0], "°C")),
                ],
              ),
            ]),

            // -----------------------------------------------------
            // 💨 Vent & Humidité
            // -----------------------------------------------------
            _section("Vent & Humidité", [
              Row(
                children: [
                  Expanded(
                      child: _card(
                          "Vitesse du vent", meteo.windMonthly[0], "m/s")),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _card(
                          "Humidité", meteo.humidityMonthly[0], "%")),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: _card("Direction du vent",
                          meteo.windDirectionMonthly[0], "°")),
                ],
              ),
            ]),
          ],
        ],
      ),
    );
  }
}
