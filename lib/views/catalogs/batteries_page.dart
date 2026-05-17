import 'package:flutter/material.dart';
import '../../domain/battery.dart';
import '../../data/catalogs.dart';
import '../../models/widgets/battery_card.dart';

class BatteriesPage extends StatelessWidget {
  const BatteriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Battery> items = batteriesDb;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogue Batteries"),
        centerTitle: true,
      ),

      body: items.isEmpty
          ? const Center(
              child: Text(
                "Aucune batterie disponible",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final battery = items[index];

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: BatteryCard(battery: battery),
                );
              },
            ),
    );
  }
}
