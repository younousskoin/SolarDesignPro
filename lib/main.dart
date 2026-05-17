import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ⭐ NOUVEAUX IMPORTS PREMIUM
import 'core/theme/app_theme.dart';
import 'core/theme/app_typography.dart';

// 👉 Vues principales
import 'views/home_view.dart';
import 'views/project_input_view.dart';
import 'views/projects_view.dart';

// 👉 Démos pédagogiques
import 'views/demo1_view.dart';
import 'views/demo2_view.dart';
import 'views/demo3_view.dart';

// 👉 Nouveau menu premium
import 'views/new_project_view.dart';

// 👉 Modèle Hive
import 'models/project_model.dart';

// 👉 Domaine : classe Project
import 'domain/project.dart';
import 'domain/system_type.dart';

// 👉 Nouvelle page PV Strings
import 'views/pv_strings_view.dart';

// 👉 Paramètres & À propos
import 'views/settings_view.dart';
import 'views/about_view.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialisation Hive (Web + Mobile + Desktop)
  await Hive.initFlutter();

  // 🔥 Enregistrement des adapters
  Hive.registerAdapter(ProjectModelAdapter());

  // 🔥 Ouverture de la box principale
  await Hive.openBox<ProjectModel>('projects');

  runApp(const SolarDesignApp());
}

class SolarDesignApp extends StatelessWidget {
  const SolarDesignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SolarDesign Pro',
      debugShowCheckedModeBanner: false,

      // 🌟 THEME GLOBAL PREMIUM
      theme: AppTheme.lightTheme,

      // 👉 Page d’accueil premium
      home: const HomeView(),

      // 👉 Toutes les routes de l’application
      routes: {
        '/project_input': (context) => const ProjectInputView(),

        '/projects': (context) => ProjectsView(),

        // 👉 Démos pédagogiques
        '/demo1': (context) => Demo1View(),
        '/demo2': (context) => Demo2View(),
        '/demo3': (context) => Demo3View(),

        // 👉 Nouveau menu de création de projet
        '/newProject': (context) => NewProjectView(),

        // ⭐⭐ PAGES RÉELLES DES TYPES DE PROJETS ⭐⭐
        '/isolated': (context) =>
            const ProjectInputView(preselectedType: PVSystemType.offGrid),

        '/hybrid': (context) =>
            const ProjectInputView(preselectedType: PVSystemType.hybrid),

        '/selfconsumption': (context) =>
            const ProjectInputView(preselectedType: PVSystemType.onGrid),

        '/minigrid': (context) =>
            const ProjectInputView(preselectedType: PVSystemType.hybrid),

        '/customProject': (context) =>
            const ProjectInputView(preselectedType: PVSystemType.offGrid),

        // 👉 Pompage solaire
        '/pumping': (context) =>
            const ProjectInputView(preselectedType: PVSystemType.pumpingWithStorage),

        // 👉 Nouvelle page premium : PV Strings Optimisés
        '/pv_strings': (context) {
          final project = ModalRoute.of(context)!.settings.arguments as Project;
          return PvStringsView(project: project);
        },

        // ⭐⭐ ROUTES IMPORTANTES ⭐⭐
        '/settings': (context) => const SettingsView(),
        '/about': (context) => const AboutView(),
      },
    );
  }
}
