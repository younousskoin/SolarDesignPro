import 'package:flutter/material.dart';

// 👉 Vues principales
import '../../views/home_view.dart';
import '../../views/project_input_view.dart';
import '../../views/projects_view.dart';
import '../../views/project_type_view.dart';
import '../../views/component_selection_view.dart';
import '../../views/results_view.dart';
import '../../views/pv_strings_view.dart';

// 👉 Domaine
import '../../domain/project.dart';
import '../../domain/system_type.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      // ---------------------------------------------------------
      // ACCUEIL
      // ---------------------------------------------------------
      case '/':
        return _page(const HomeView());

      // ---------------------------------------------------------
      // CHOIX DU TYPE DE PROJET
      // ---------------------------------------------------------
      case '/newProject':
        return _page(const ProjectTypeView());

      // ---------------------------------------------------------
      // SAISIE DU PROJET (STEPPER)
      // ---------------------------------------------------------
      case '/project_input':
        final type = settings.arguments as PVSystemType?;
        return _page(ProjectInputView(preselectedType: type));

      // ---------------------------------------------------------
      // SÉLECTION DES COMPOSANTS
      // ---------------------------------------------------------
      case '/components':
        final project = settings.arguments as Project;
        return _page(ComponentSelectionView(project: project));

      // ---------------------------------------------------------
      // RÉSULTATS
      // ---------------------------------------------------------
      case '/results':
        final project = settings.arguments as Project;
        return _page(ResultsView(project: project));

      // ---------------------------------------------------------
      // PV STRINGS
      // ---------------------------------------------------------
      case '/pv_strings':
        final project = settings.arguments as Project;
        return _page(PvStringsView(project: project));

      // ---------------------------------------------------------
      // LISTE DES PROJETS
      // ---------------------------------------------------------
      case '/projects':
        return _page(const ProjectsView());

      // ---------------------------------------------------------
      // PAGE INCONNUE
      // ---------------------------------------------------------
      default:
        return _page(
          Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "Page non trouvée : ${settings.name}",
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        );
    }
  }

  // ---------------------------------------------------------
  // TRANSITION PREMIUM
  // ---------------------------------------------------------
  static PageRouteBuilder _page(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) {
        return FadeTransition(opacity: animation, child: page);
      },
    );
  }
}
