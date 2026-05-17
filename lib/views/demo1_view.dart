import 'package:flutter/material.dart';
import '../theme.dart';

class Demo1View extends StatelessWidget {
  const Demo1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Démo 1 | Système isolé 2 kWc"),
        backgroundColor: AppTheme.blueDeep,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _title("Principe du système isolé"),
          _text(
            "Un système isolé (off-grid) fonctionne sans réseau électrique. "
            "Il utilise des panneaux solaires, un régulateur de charge, des batteries "
            "et un onduleur pour alimenter les charges en autonomie totale.",
          ),

          const SizedBox(height: 20),
          _schema("Schéma simplifié du système isolé"),

          const SizedBox(height: 20),
          _title("Composants principaux"),
          _bullet([
            "Panneaux solaires 2 kWc",
            "Régulateur MPPT 60A",
            "Batteries 24V – 400Ah",
            "Onduleur 2 kVA pur sinus",
          ]),

          const SizedBox(height: 20),
          _title("Animation : Flux d’énergie"),
          _energyFlowAnimation(),
        ],
      ),
    );
  }

  Widget _title(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  );

  Widget _text(String text) =>
      Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87));

  Widget _bullet(List<String> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items
        .map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              "• $e",
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        )
        .toList(),
  );

  Widget _schema(String label) => Container(
    padding: const EdgeInsets.all(20),
    decoration: AppTheme.whiteCard,
    child: Column(
      children: [
        const Icon(Icons.account_tree_rounded, size: 60, color: Colors.orange),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _energyFlowAnimation() => Container(
    padding: const EdgeInsets.all(20),
    decoration: AppTheme.whiteCard,
    child: Column(
      children: [
        const Text(
          "Flux : Panneaux → Régulateur → Batteries → Onduleur → Charges",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          height: 8,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    ),
  );
}
