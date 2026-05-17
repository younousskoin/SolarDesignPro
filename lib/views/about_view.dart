import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';
import '../widgets/slide_fade_horizontal.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SlideFadeHorizontal(
          delay: 100,
          child: const Text(
            "À propos",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---------------------------------------------------------
          // HEADER ICON
          // ---------------------------------------------------------
          FadeScale(
            delay: 120,
            child: Center(
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.sunny, size: 50, color: AppTheme.blueDeep),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ---------------------------------------------------------
          // TITLE
          // ---------------------------------------------------------
          FadeSlide(
            delay: 150,
            child: Text(
              "SolarDesignPro",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: AppTheme.blueDeep,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 8),

          FadeSlide(
            delay: 200,
            child: const Text(
              "Plateforme professionnelle de conception et d’analyse des systèmes solaires.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // DESCRIPTION
          // ---------------------------------------------------------
          SlideFadeHorizontal(
            delay: 250,
            child: const Text(
              "Présentation",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          FadeScale(
            delay: 300,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.whiteCard,
              child: const Text(
                "SolarDesignPro est un outil moderne dédié à l’ingénierie solaire. "
                "Il permet de concevoir, analyser et optimiser des systèmes photovoltaïques, "
                "des solutions de pompage solaire, ainsi que des systèmes hybrides. "
                "L’objectif est d’offrir une plateforme pédagogique et professionnelle, "
                "simple d’utilisation, mais techniquement robuste.",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // DEVELOPER
          // ---------------------------------------------------------
          SlideFadeHorizontal(
            delay: 350,
            child: const Text(
              "Développeur",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          FadeScale(
            delay: 400,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.whiteCard,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: AppTheme.blueDeep,
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dr. Younoussa M. Baldé, PhD",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Docteur en Automatique, enseignant-chercheur spécialisé en "
                          "énergies renouvelables, contrôle-commande et efficacité énergétique. "
                          "Architecte de plateformes pédagogiques et outils professionnels "
                          "pour la conception de systèmes solaires.",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // INFORMATIONS
          // ---------------------------------------------------------
          SlideFadeHorizontal(
            delay: 450,
            child: const Text(
              "Informations",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          FadeScale(
            delay: 500,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.whiteCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Version : 1.0.0",
                    style: TextStyle(color: Colors.black87, fontSize: 15),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    "Licence : Usage pédagogique et professionnel.",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    onTap: () async {
                      final Uri emailUri = Uri(
                        scheme: 'mailto',
                        path: 'solardesignpro@outlook.com',
                      );
                      if (await canLaunchUrl(emailUri)) {
                        await launchUrl(emailUri);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.email_rounded,
                          color: AppTheme.blueDeep,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "solardesignpro@outlook.com",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "© 2024 - SolarDesignPro. Tous droits réservés.",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ---------------------------------------------------------
          // CONTACT PREMIUM
          // ---------------------------------------------------------
          SlideFadeHorizontal(
            delay: 550,
            child: const Text(
              "Contact",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          FadeScale(
            delay: 600,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.whiteCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.email_rounded,
                        color: AppTheme.blueDeep,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "solardesignpro@outlook.com",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            const ClipboardData(
                              text: "solardesignpro@outlook.com",
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Adresse copiée"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text("Copier"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.blueDeep,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      OutlinedButton.icon(
                        onPressed: () async {
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: 'solardesignpro@outlook.com',
                          );
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          }
                        },
                        icon: const Icon(Icons.send_rounded),
                        label: const Text("Envoyer un message"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.blueDeep,
                          side: BorderSide(
                            color: AppTheme.blueDeep,
                            width: 1.4,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
