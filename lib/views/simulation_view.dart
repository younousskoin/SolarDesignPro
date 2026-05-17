import 'package:flutter/material.dart';
import '../domain/panel.dart';
import '../domain/battery.dart';
import '../domain/inverter.dart';
import '../domain/regulator.dart';
import '../domain/pump.dart';

class SimulationView extends StatelessWidget {
  const SimulationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupérer les arguments passés via Navigator
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};

    final panel = data['panel'] as Panel?;
    final battery = data['battery'] as Battery?;
    final inverter = data['inverter'] as Inverter?;
    final regulator = data['regulator'] as Regulator?;
    final pump = data['pump'] as Pump?;

    return Scaffold(
      appBar: AppBar(title: const Text("Simulation")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("Panneau sélectionné : ${panel?.name ?? 'Aucun'}"),
            Text("Batterie sélectionnée : ${battery?.name ?? 'Aucune'}"),
            Text("Onduleur sélectionné : ${inverter?.name ?? 'Aucun'}"),
            Text("Régulateur sélectionné : ${regulator?.name ?? 'Aucun'}"),
            Text("Pompe sélectionnée : ${pump?.name ?? 'Aucune'}"),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: () {
                // On propage les mêmes arguments vers la vue de résultats
                Navigator.pushNamed(context, '/results', arguments: data);
              },
              child: const Text("Voir les résultats"),
            ),
          ],
        ),
      ),
    );
  }
}
