import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';
import 'package:simpv_system/views/project_input_view.dart';

class MetricDetailView extends StatelessWidget {
  const MetricDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final String title = args["title"];
    final String value = args["value"];
    final IconData icon = args["icon"];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      appBar: AppBar(
        title: FadeSlide(
          delay: 100,
          child: Text(
            title,
            style: const TextStyle(color: Colors.black87, fontSize: 22),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---------------------------------------------------------
          // HERO CARD
          // ---------------------------------------------------------
          Hero(
            tag: "metric_$title",
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.whiteCard,
              child: Row(
                children: [
                  Icon(icon, size: 48, color: AppTheme.blueDeep),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // DESCRIPTION
          // ---------------------------------------------------------
          FadeScale(
            delay: 200,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.whiteCard,
              child: Text(
                "Analyse détaillée de l’indicateur « $title ».\n\n"
                "Cette section pourra afficher :\n"
                "- des graphiques avancés\n"
                "- des explications techniques\n"
                "- des comparaisons\n"
                "- des tendances temporelles\n"
                "- des recommandations d’optimisation\n\n"
                "SolarDesignPro est conçu pour offrir une analyse complète et pédagogique.",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
