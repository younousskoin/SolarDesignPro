import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/fade_scale.dart';
import '../widgets/slide_fade_horizontal.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // -----------------------------
  // VARIABLES LOCALES
  // -----------------------------
  String language = "fr";
  String energyUnit = "kWh";

  String themeMode = "system"; // clair / sombre / system
  bool expertMode = false;
  bool diagnosticLogs = false;

  // Aperçu du thème
  bool get isDarkPreview =>
      themeMode == "dark" ||
      (themeMode == "system" &&
          MediaQuery.of(context).platformBrightness == Brightness.dark);

  // RESET
  void resetSettings() {
    setState(() {
      language = "fr";
      energyUnit = "kWh";
      themeMode = "system";
      expertMode = false;
      diagnosticLogs = false;
    });
  }

  // STYLE TITRE PREMIUM
  Text _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: [AppTheme.blueDeep, Colors.blueGrey],
          ).createShader(Rect.fromLTWH(0, 0, 200, 0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Paramètres",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---------------------------------------------------------
          // GÉNÉRAL
          // ---------------------------------------------------------
          SlideFadeHorizontal(delay: 100, child: _sectionTitle("Général")),
          const SizedBox(height: 12),

          FadeScale(
            delay: 150,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12, width: 0.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // LANGUE
                  Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        color: AppTheme.blueDeep,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text("Langue", style: TextStyle(fontSize: 16)),
                      ),
                      DropdownButton<String>(
                        value: language,
                        items: const [
                          DropdownMenuItem(
                            value: "fr",
                            child: Text("Français"),
                          ),
                          DropdownMenuItem(value: "en", child: Text("English")),
                        ],
                        onChanged: (v) {
                          setState(() => language = v!);
                        },
                      ),
                    ],
                  ),

                  const Divider(
                    height: 22,
                    thickness: 0.6,
                    color: Colors.black12,
                  ),

                  // UNITÉ
                  Row(
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: AppTheme.blueDeep,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Unité d’énergie",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      DropdownButton<String>(
                        value: energyUnit,
                        items: const [
                          DropdownMenuItem(value: "kWh", child: Text("kWh")),
                          DropdownMenuItem(value: "Wh", child: Text("Wh")),
                          DropdownMenuItem(value: "MhH", child: Text("MhH")),
                        ],
                        onChanged: (v) {
                          setState(() => energyUnit = v!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // APPARENCE
          // ---------------------------------------------------------
          SlideFadeHorizontal(delay: 200, child: _sectionTitle("Apparence")),
          const SizedBox(height: 12),

          FadeScale(
            delay: 250,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12, width: 0.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // SÉLECTEUR DE THÈME
                  Row(
                    children: [
                      Icon(
                        Icons.color_lens_rounded,
                        color: AppTheme.blueDeep,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text("Thème", style: TextStyle(fontSize: 16)),
                      ),
                      DropdownButton<String>(
                        value: themeMode,
                        items: const [
                          DropdownMenuItem(
                            value: "light",
                            child: Text("Clair"),
                          ),
                          DropdownMenuItem(
                            value: "dark",
                            child: Text("Sombre"),
                          ),
                          DropdownMenuItem(
                            value: "system",
                            child: Text("Automatique"),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => themeMode = v!);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // APERÇU DU THÈME
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDarkPreview ? Colors.black87 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Center(
                      child: Text(
                        isDarkPreview ? "Aperçu sombre" : "Aperçu clair",
                        style: TextStyle(
                          color: isDarkPreview ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // AVANCÉ
          // ---------------------------------------------------------
          SlideFadeHorizontal(delay: 300, child: _sectionTitle("Avancé")),
          const SizedBox(height: 12),

          FadeScale(
            delay: 350,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12, width: 0.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.engineering_rounded,
                        color: AppTheme.blueDeep,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Mode expert",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Switch(
                        value: expertMode,
                        onChanged: (v) {
                          setState(() => expertMode = v);
                        },
                        activeColor: AppTheme.blueDeep,
                      ),
                    ],
                  ),

                  const Divider(
                    height: 22,
                    thickness: 0.6,
                    color: Colors.black12,
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.bug_report_rounded,
                        color: AppTheme.blueDeep,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Logs de diagnostic",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Switch(
                        value: diagnosticLogs,
                        onChanged: (v) {
                          setState(() => diagnosticLogs = v);
                        },
                        activeColor: AppTheme.blueDeep,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // RÉINITIALISATION
          // ---------------------------------------------------------
          SlideFadeHorizontal(
            delay: 400,
            child: _sectionTitle("Réinitialisation"),
          ),
          const SizedBox(height: 12),

          FadeScale(
            delay: 450,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12, width: 0.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: resetSettings,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text("Réinitialiser les paramètres"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
