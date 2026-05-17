import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';
import '../widgets/slide_fade_horizontal.dart';
import '../widgets/staggered_list.dart';
import '../widgets/solar_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      drawer: const SolarDrawer(),

      // ---------------------------------------------------------
      // APPBAR PREMIUM
      // ---------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(color: Colors.white.withOpacity(0.70)),
          ),
        ),
        title: SlideFadeHorizontal(
          delay: 100,
          child: Row(
            children: [
              Image.asset("assets/logo/solardesignpro.png", width: 34),
              const SizedBox(width: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontFamily: "Manrope"),
                  children: [
                    const TextSpan(
                      text: "SolarDesign",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    TextSpan(
                      text: "Pro",
                      style: TextStyle(
                        color: AppTheme.blueDeep,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 6),
        ],
      ),

      // ---------------------------------------------------------
      // BODY
      // ---------------------------------------------------------
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? 60 : 22,
                vertical: 22,
              ),
              children: [
                // ---------------------------------------------------------
                // HERO SECTION PREMIUM
                // ---------------------------------------------------------
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.blueLight.withOpacity(0.12),
                        AppTheme.blueDeep.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      FadeScale(
                        delay: 150,
                        child: Image.asset(
                          "assets/logo/solardesignpro.png",
                          width: 150,
                        ),
                      ),
                      const SizedBox(height: 20),

                      FadeSlide(
                        delay: 250,
                        child: const Text(
                          "Bienvenue sur",
                          style: TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      FadeScale(
                        delay: 300,
                        child: Text(
                          "SolarDesignPro",
                          style: TextStyle(
                            fontFamily: "Manrope",
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.blueDeep,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SlideFadeHorizontal(
                        delay: 350,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            "Plateforme professionnelle de conception, d’analyse et de dimensionnement solaire",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Manrope",
                              fontSize: 16,
                              color: Colors.black45,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ---------------------------------------------------------
                      // BOUTON ACTIF
                      // ---------------------------------------------------------
                      FadeSlide(
                        delay: 400,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.blueDeep,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, "/newProject"),
                          child: const Text(
                            "Commencer un projet",
                            style: TextStyle(
                              fontFamily: "Manrope",
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ---------------------------------------------------------
                // OUTILS
                // ---------------------------------------------------------
                SlideFadeHorizontal(
                  delay: 450,
                  child: const Text(
                    "Outils",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                StaggeredList(
                  initialDelay: 500,
                  step: 120,
                  children: [
                    _toolCard(
                      Icons.wb_sunny_rounded,
                      "Météo & Irradiation",
                      "Données climatiques et températures",
                    ),
                    _toolCard(
                      Icons.inventory_2_rounded,
                      "Base de composants",
                      "Modules, onduleurs, batteries...",
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ---------------------------------------------------------
                // DEMOS
                // ---------------------------------------------------------
                SlideFadeHorizontal(
                  delay: 650,
                  child: const Text(
                    "Démos pédagogiques",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                StaggeredList(
                  initialDelay: 700,
                  step: 120,
                  children: [
                    _demoCard(
                      context,
                      "Démo 1 | Système isolé 2 kWc",
                      "/demo1",
                    ),
                    _demoCard(
                      context,
                      "Démo 2 | Pompage solaire 1.5 kW",
                      "/demo2",
                    ),
                    _demoCard(
                      context,
                      "Démo 3 | Système hybride 5 kW",
                      "/demo3",
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // OUTILS — VERSION PREMIUM
  // ---------------------------------------------------------
  Widget _toolCard(IconData icon, String title, String subtitle) {
    return FadeSlide(
      delay: 200,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.whiteCard.copyWith(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.blueLight.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28, color: AppTheme.blueDeep),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Manrope",
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: "Manrope",
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

  // ---------------------------------------------------------
  // DEMOS — VERSION PREMIUM
  // ---------------------------------------------------------
  Widget _demoCard(BuildContext context, String title, String route) {
    return FadeSlide(
      delay: 200,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: AppTheme.whiteCard.copyWith(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: AppTheme.blueDeep,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Manrope",
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
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
