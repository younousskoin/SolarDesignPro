import 'package:flutter/material.dart';
import '../pump.dart';

class PumpCard extends StatelessWidget {
  final Pump pump;

  const PumpCard({super.key, required this.pump});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(pump.name),
        subtitle: Text(
          "${pump.power} kW • ${pump.flow} m³/h • ${pump.head} m • ${pump.supplyVoltage}",
        ),
        trailing: Text("${pump.price} €"),
      ),
    );
  }
}
