import 'package:flutter/material.dart';
import '../inverter.dart';

class InverterCard extends StatelessWidget {
  final Inverter inverter;

  const InverterCard({super.key, required this.inverter});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(inverter.name),
        subtitle: Text(
          "${inverter.power} W • ${inverter.type} • ${inverter.outputVoltage}",
        ),
        trailing: Text("${inverter.price} €"),
      ),
    );
  }
}
