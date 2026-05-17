import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/fade_slide.dart';

class NewProjectView extends StatelessWidget {
  const NewProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Nouveau projet",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          FadeSlide(
            delay: 100,
            child: const Text(
              "Choisissez un type de projet",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 20),

          _projectCard(
            context,
            icon: Icons.bolt_rounded,
            title: "Système isolé",
            subtitle: "Installation hors réseau (sites autonomes)",
            route: "/isolated",
          ),

          _projectCard(
            context,
            icon: Icons.battery_charging_full_rounded,
            title: "Système hybride",
            subtitle: "PV + batteries + réseau électrique",
            route: "/hybrid",
          ),

          _projectCard(
            context,
            icon: Icons.water_drop_rounded,
            title: "Pompage solaire",
            subtitle: "Forage, irrigation, châteaux d’eau",
            route: "/pumping",
          ),

          _projectCard(
            context,
            icon: Icons.wb_sunny_rounded,
            title: "Autoconsommation",
            subtitle: "Maison, entreprise, industrie",
            route: "/selfconsumption",
          ),

          _projectCard(
            context,
            icon: Icons.grid_3x3_rounded,
            title: "Mini-réseau",
            subtitle: "Village, communauté, site isolé",
            route: "/minigrid",
          ),

          _projectCard(
            context,
            icon: Icons.settings_suggest_rounded,
            title: "Projet personnalisé",
            subtitle: "Configuration avancée",
            route: "/customProject",
          ),
        ],
      ),
    );
  }

  Widget _projectCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return FadeSlide(
      delay: 150,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.06),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.blueLight.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 32, color: AppTheme.blueDeep),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
