import 'package:flutter/material.dart';
import '../theme.dart';

class Demo2View extends StatelessWidget {
  const Demo2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Démo 2 | Pompage solaire 1.5 kW"),
        backgroundColor: AppTheme.blueDeep,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _title("Principe du pompage solaire"),
          _text(
            "Le pompage solaire utilise l’énergie photovoltaïque pour alimenter "
            "une pompe immergée ou de surface. Aucun besoin de batteries.",
          ),

          const SizedBox(height: 20),
          _schema("Schéma du système de pompage"),

          const SizedBox(height: 20),
          _title("Composants principaux"),
          _bullet([
            "Panneaux solaires 1.5 kW",
            "Variateur solaire (VFD)",
            "Pompe immergée 1.5 kW",
            "Capteurs de niveau",
          ]),

          const SizedBox(height: 20),
          _title("Animation : Variation de puissance"),
          _pumpAnimation(),
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
        const Icon(Icons.waterfall_chart, size: 60, color: Colors.blue),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _pumpAnimation() => Container(
    padding: const EdgeInsets.all(20),
    decoration: AppTheme.whiteCard,
    child: Column(
      children: [
        const Text(
          "Puissance de la pompe en fonction du soleil",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.2, end: 1.0),
          duration: const Duration(seconds: 2),
          builder: (context, value, _) {
            return Container(
              height: 12,
              width: 200 * value,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          },
        ),
      ],
    ),
  );
}
