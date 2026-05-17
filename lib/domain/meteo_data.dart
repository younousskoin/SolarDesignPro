class MeteoData {
  // ---------------------------------------------------------
  // 🌞 Irradiation
  // ---------------------------------------------------------
  List<double> irradiationMonthly;   // GHI
  List<double> diffuseMonthly;       // DHI
  List<double> directMonthly;        // DNI

  // ---------------------------------------------------------
  // 🌡️ Température
  // ---------------------------------------------------------
  List<double> temperatureMonthly;   // T2M

  // ---------------------------------------------------------
  // 💨 Vent & Humidité
  // ---------------------------------------------------------
  List<double> windMonthly;          // WS2M
  List<double> humidityMonthly;      // RH2M
  List<double> windDirectionMonthly; // WD2M

  MeteoData({
    required this.irradiationMonthly,
    required this.diffuseMonthly,
    required this.directMonthly,
    required this.temperatureMonthly,
    required this.windMonthly,
    required this.humidityMonthly,
    required this.windDirectionMonthly,
  });

  // ---------------------------------------------------------
  // 🔥 Données par défaut (sécurité)
  // ---------------------------------------------------------
  factory MeteoData.empty() {
    return MeteoData(
      irradiationMonthly: List.filled(12, 0.0),
      diffuseMonthly: List.filled(12, 0.0),
      directMonthly: List.filled(12, 0.0),
      temperatureMonthly: List.filled(12, 25.0),
      windMonthly: List.filled(12, 2.0),
      humidityMonthly: List.filled(12, 60.0),
      windDirectionMonthly: List.filled(12, 180.0),
    );
  }

  // ---------------------------------------------------------
  // 🔄 Conversion depuis Map (JSON ou Hive)
  // ---------------------------------------------------------
  factory MeteoData.fromMap(Map<String, dynamic> m) {
    List<double> parseList(String key, double fallback) {
      if (!m.containsKey(key)) return List.filled(12, fallback);

      final raw = m[key];
      if (raw is! List) return List.filled(12, fallback);

      return raw.map((e) => (e as num).toDouble()).toList();
    }

    final ghi = parseList("ghi", 0.0);

    final dhi = m.containsKey("dhi")
        ? parseList("dhi", 0.0)
        : _estimateDiffuse(ghi);

    final dni = m.containsKey("dni")
        ? parseList("dni", 0.0)
        : List.generate(12, (i) => (ghi[i] - dhi[i]).clamp(0.0, ghi[i]));

    return MeteoData(
      irradiationMonthly: ghi,
      diffuseMonthly: dhi,
      directMonthly: dni,
      temperatureMonthly: parseList("temperature", 25.0),
      windMonthly: parseList("wind", 2.0),
      humidityMonthly: parseList("humidity", 60.0),
      windDirectionMonthly: parseList("windDirection", 180.0),
    );
  }

  // ---------------------------------------------------------
  // 🔄 Conversion vers Map (JSON ou Hive)
  // ---------------------------------------------------------
  Map<String, dynamic> toMap() => {
        'ghi': irradiationMonthly,
        'dhi': diffuseMonthly,
        'dni': directMonthly,
        'temperature': temperatureMonthly,
        'wind': windMonthly,
        'humidity': humidityMonthly,
        'windDirection': windDirectionMonthly,
      };

  // ---------------------------------------------------------
  // 🔧 Estimation de la diffuse si manquante
  // ---------------------------------------------------------
  static List<double> _estimateDiffuse(List<double> ghi) {
    return ghi.map((g) => g <= 0 ? 0.0 : g * 0.28).toList();
  }
}
