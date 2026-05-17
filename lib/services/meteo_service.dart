import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/meteo_data.dart';

class MeteoService {
  // ---------------------------------------------------------
  // 🌍 Correction automatique des pays
  // ---------------------------------------------------------
  static const Map<String, String> countryFix = {
    "guinee": "Guinea",
    "guinée": "Guinea",
    "guinea": "Guinea",
    "guinee bissau": "Guinea-Bissau",
    "guinée bissau": "Guinea-Bissau",
    "cote d'ivoire": "Ivory Coast",
    "côte d'ivoire": "Ivory Coast",
    "senegal": "Senegal",
    "sénégal": "Senegal",
    "maroc": "Morocco",
    "algerie": "Algeria",
    "algérie": "Algeria",
    "tunisie": "Tunisia",
    "mauritanie": "Mauritania",
    "mali": "Mali",
    "niger": "Niger",
    "tchad": "Chad",
  };

  // ---------------------------------------------------------
  // 🔷 1) Géocodage intelligent (ville + fallback)
  // ---------------------------------------------------------
  static Future<Map<String, double>?> geocode(
      String city, String country) async {
    try {
      city = city.trim();
      country = country.trim();

      if (city.isEmpty) return null;

      final fixedCountry = countryFix[country.toLowerCase()] ?? country;

      // 1) Tentative : ville + pays
      final url1 =
          "https://geocoding-api.open-meteo.com/v1/search?name=$city&country=$fixedCountry&count=1";

      final r1 = await http
          .get(Uri.parse(url1))
          .timeout(const Duration(seconds: 10));

      if (r1.statusCode == 200) {
        final data = jsonDecode(r1.body);
        if (data["results"] != null && data["results"].isNotEmpty) {
          final r = data["results"][0];
          return {
            "lat": (r["latitude"] as num).toDouble(),
            "lon": (r["longitude"] as num).toDouble(),
          };
        }
      }

      // 2) Fallback : ville seule
      final url2 =
          "https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1";

      final r2 = await http
          .get(Uri.parse(url2))
          .timeout(const Duration(seconds: 10));

      if (r2.statusCode == 200) {
        final data = jsonDecode(r2.body);
        if (data["results"] != null && data["results"].isNotEmpty) {
          final r = data["results"][0];
          return {
            "lat": (r["latitude"] as num).toDouble(),
            "lon": (r["longitude"] as num).toDouble(),
          };
        }
      }

      return null;
    } catch (e) {
      print("❌ Erreur géocodage : $e");
      return null;
    }
  }

  // ---------------------------------------------------------
  // 🔷 2) Récupération mensuelle NASA POWER (lat/lon)
  // ---------------------------------------------------------
  Future<Map<String, List<double>>?> fetchMonthlyMeteo({
    required double lat,
    required double lon,
  }) async {
    try {
      final url =
          "https://power.larc.nasa.gov/api/temporal/monthly/point?"
          "parameters=ALLSKY_SFC_SW_DWN,DNI,DHI,T2M,WS2M,RH2M,WD2M"
          "&latitude=$lat"
          "&longitude=$lon"
          "&start=2023"
          "&end=2023"
          "&community=RE"
          "&format=JSON";

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        print("❌ NASA status code : ${response.statusCode}");
        return null;
      }

      final data = jsonDecode(response.body);

      if (!data.containsKey("properties")) {
        print("❌ NASA JSON sans 'properties'");
        return null;
      }

      final params = data["properties"]["parameter"];
      if (params == null) {
        print("❌ NASA JSON sans 'parameter'");
        return null;
      }

      List<double> extract(Map<String, dynamic>? map) {
        if (map == null) return List.filled(12, 0.0);
        final keys = map.keys.toList()..sort();
        return keys.map((k) => (map[k] as num).toDouble()).toList();
      }

      return {
        "GHI": extract(params["ALLSKY_SFC_SW_DWN"]),
        "DNI": extract(params["DNI"]),
        "DHI": extract(params["DHI"]),
        "TEMP": extract(params["T2M"]),
        "WIND": extract(params["WS2M"]),
        "HUM": extract(params["RH2M"]),
        "WIND_DIR": extract(params["WD2M"]),
      };
    } catch (e) {
      print("❌ Erreur NASA : $e");
      return null;
    }
  }

  // ---------------------------------------------------------
  // 🔥 3) Méthode utilisée par ton bouton "Importer météo"
  // ---------------------------------------------------------
  static Future<MeteoData?> fetchMeteo(String city, String country) async {
    try {
      print("🔎 Début import NASA pour $city, $country");

      // 1. Géocodage
      final geo = await geocode(city, country);
      print("📍 GEO = $geo");

      if (geo == null || geo["lat"] == null || geo["lon"] == null) {
        print("❌ Coordonnées invalides (null)");
        return null;
      }

      final lat = geo["lat"]!;
      final lon = geo["lon"]!;

      if (lat == 0 || lon == 0) {
        print("❌ Coordonnées (0,0) → NASA ignorée");
        return null;
      }

      print("📌 Coordonnées trouvées → lat=$lat, lon=$lon");

      // 2. Appel NASA POWER
      final service = MeteoService();
      final raw = await service.fetchMonthlyMeteo(lat: lat, lon: lon);

      print("🌤 RAW NASA = $raw");

      if (raw == null) {
        print("❌ NASA n'a pas renvoyé de données");
        return null;
      }

      // 3. Conversion en MeteoData complète
      print("✅ Données NASA valides → création MeteoData");

      return MeteoData(
        irradiationMonthly: raw["GHI"]!,
        diffuseMonthly: raw["DHI"]!,
        directMonthly: raw["DNI"]!,
        temperatureMonthly: raw["TEMP"]!,
        windMonthly: raw["WIND"]!,
        humidityMonthly: raw["HUM"]!,
        windDirectionMonthly: raw["WIND_DIR"]!,
      );
    } catch (e) {
      print("⚠️ Exception fetchMeteo : $e");
      return null;
    }
  }
}
