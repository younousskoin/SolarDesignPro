import 'package:flutter/material.dart';

class ComponentTypeView extends StatefulWidget {
  const ComponentTypeView({super.key});

  @override
  State<ComponentTypeView> createState() => _ComponentTypeViewState();
}

class _ComponentTypeViewState extends State<ComponentTypeView> {
  String? panelType;
  String? batteryType;
  String? inverterType;
  String? regulatorType;
  String? pumpType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choix du type de composants")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionTitle("Type de panneaux"),
            DropdownButton<String>(
              value: panelType,
              isExpanded: true,
              hint: const Text("Choisir un type de panneau"),
              items: const [
                DropdownMenuItem(value: "mono", child: Text("Monocristallin")),
                DropdownMenuItem(value: "poly", child: Text("Polycristallin")),
                DropdownMenuItem(value: "bifacial", child: Text("Bifacial")),
              ],
              onChanged: (v) => setState(() => panelType = v),
            ),
            const SizedBox(height: 16),

            _sectionTitle("Type de batteries"),
            DropdownButton<String>(
              value: batteryType,
              isExpanded: true,
              hint: const Text("Choisir un type de batterie"),
              items: const [
                DropdownMenuItem(value: "gel", child: Text("Gel")),
                DropdownMenuItem(value: "agm", child: Text("AGM")),
                DropdownMenuItem(value: "lithium", child: Text("Lithium")),
                DropdownMenuItem(value: "opzs", child: Text("OPzS")),
              ],
              onChanged: (v) => setState(() => batteryType = v),
            ),
            const SizedBox(height: 16),

            _sectionTitle("Type d’onduleur"),
            DropdownButton<String>(
              value: inverterType,
              isExpanded: true,
              hint: const Text("Choisir un type d’onduleur"),
              items: const [
                DropdownMenuItem(value: "offgrid", child: Text("Off-grid")),
                DropdownMenuItem(value: "ongrid", child: Text("On-grid")),
                DropdownMenuItem(value: "hybrid", child: Text("Hybride")),
              ],
              onChanged: (v) => setState(() => inverterType = v),
            ),
            const SizedBox(height: 16),

            _sectionTitle("Type de régulateur"),
            DropdownButton<String>(
              value: regulatorType,
              isExpanded: true,
              hint: const Text("Choisir un type de régulateur"),
              items: const [
                DropdownMenuItem(value: "PWM", child: Text("PWM")),
                DropdownMenuItem(value: "MPPT", child: Text("MPPT")),
              ],
              onChanged: (v) => setState(() => regulatorType = v),
            ),
            const SizedBox(height: 16),

            _sectionTitle("Type de pompe"),
            DropdownButton<String>(
              value: pumpType,
              isExpanded: true,
              hint: const Text("Choisir un type de pompe"),
              items: const [
                DropdownMenuItem(
                  value: "surface",
                  child: Text("Pompe de surface"),
                ),
                DropdownMenuItem(
                  value: "immergee",
                  child: Text("Pompe immergée"),
                ),
              ],
              onChanged: (v) => setState(() => pumpType = v),
            ),
            const SizedBox(height: 28),

            FilledButton.icon(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/components',
                  arguments: {
                    'panelType': panelType,
                    'batteryType': batteryType,
                    'inverterType': inverterType,
                    'regulatorType': regulatorType,
                    'pumpType': pumpType,
                  },
                );
              },
              label: const Text("Continuer vers choix des composants"),
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: () {
                setState(() {
                  panelType = null;
                  batteryType = null;
                  inverterType = null;
                  regulatorType = null;
                  pumpType = null;
                });
              },
              icon: const Icon(Icons.restart_alt),
              label: const Text("Réinitialiser"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.black87,
    ),
  );
}
