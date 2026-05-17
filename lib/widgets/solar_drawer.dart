import 'package:flutter/material.dart';
import '../theme.dart';

import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';
import '../widgets/slide_fade_horizontal.dart';
import '../widgets/staggered_list.dart';

class SolarDrawer extends StatefulWidget {
  const SolarDrawer({super.key});

  @override
  State<SolarDrawer> createState() => _SolarDrawerState();
}

class _SolarDrawerState extends State<SolarDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ribbonHeight;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _ribbonHeight = Tween<double>(
      begin: 0,
      end: 600,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isSelected(BuildContext context, String route) {
    return ModalRoute.of(context)?.settings.name == route;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    final double drawerWidth = isDesktop ? 280 : 240;

    return Drawer(
      width: drawerWidth,
      backgroundColor: Colors.white,
      elevation: 6,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _ribbonHeight,
            builder: (context, child) {
              return Container(
                width: 6,
                height: _ribbonHeight.value,
                color: AppTheme.blueDeep,
              );
            },
          ),

          Positioned.fill(
            left: 6,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 18,
                ),
                children: [
                  Row(
                    children: [
                      Image.asset("assets/logo/solardesignpro.png", width: 42),
                      const SizedBox(width: 12),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "SolarDesign",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text: "Pro",
                              style: TextStyle(
                                color: AppTheme.blueLight,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  _menuItem(
                    context: context,
                    icon: Icons.home_rounded,
                    label: "Accueil",
                    route: '/',
                    delay: 200,
                  ),

                  _menuItem(
                    context: context,
                    icon: Icons.add_circle_outline_rounded,
                    label: "Nouveau projet",
                    route: '/newProject',   // ✔ Correction ici
                    delay: 260,
                  ),

                  _menuItem(
                    context: context,
                    icon: Icons.folder_copy_rounded,
                    label: "Mes projets",
                    route: '/projects',
                    delay: 320,
                  ),

                  // ❌ SUPPRESSION : /components nécessite un Project → crash
                  // _menuItem(
                  //   context: context,
                  //   icon: Icons.inventory_2_rounded,
                  //   label: "Composants",
                  //   route: '/components',
                  //   delay: 380,
                  // ),

                  _menuItem(
                    context: context,
                    icon: Icons.settings_rounded,
                    label: "Paramètres",
                    route: '/settings',
                    delay: 380,
                  ),

                  _menuItem(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    label: "À propos",
                    route: '/about',
                    delay: 440,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required int delay,
  }) {
    final bool selected = _isSelected(context, route);

    return FadeSlide(
      delay: delay,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppTheme.blueLight.withOpacity(0.12) : null,
            borderRadius: BorderRadius.circular(10),
            border: selected
                ? Border(left: BorderSide(color: AppTheme.blueDeep, width: 4))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: selected ? AppTheme.blueDeep : Colors.black54,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: selected ? AppTheme.blueDeep : Colors.black87,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
