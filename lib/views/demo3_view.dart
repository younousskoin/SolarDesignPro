import 'package:flutter/material.dart';
import '../theme.dart';

class Demo3View extends StatelessWidget {
  const Demo3View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Démo 3 | Système hybride 5 kW"),
        backgroundColor: AppTheme.blueDeep,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _title("Principe du système hybride"),
          _text(
            "Un système hybride combine panneaux solaires, batteries et réseau. "
            "Il optimise l’autoconsommation et assure une continuité d’alimentation.",
          ),

          const SizedBox(height: 20),
          _schema("Schéma du système hybride"),

          const SizedBox(height: 20),
          _title("Modes de fonctionnement"),
          _bullet([
            "Mode solaire → charges",
            "Mode solaire + batterie",
            "Mode réseau + batterie",
            "Mode secours (backup)",
          ]),

          const SizedBox(height: 20),
          _title("Animation : Priorité énergétique"),
          _hybridAnimation(),
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
        const Icon(Icons.bolt_rounded, size: 60, color: Colors.green),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _hybridAnimation() => Container(
    padding: const EdgeInsets.all(20),
    decoration: AppTheme.whiteCard,
    child: Column(
      children: [
        const Text(
          "Priorité : Solaire → Batterie → Réseau",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 3),
          builder: (context, value, _) {
            return Row(
              children: [
                Expanded(
                  flex: (value * 100).toInt(),
                  child: Container(height: 10, color: Colors.orange),
                ),
                Expanded(
                  flex: 100 - (value * 100).toInt(),
                  child: Container(height: 10, color: Colors.grey[300]),
                ),
              ],
            );
          },
        ),
      ],
    ),
  );
}
