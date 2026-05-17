import 'package:flutter/material.dart';
import '../regulator.dart';

class RegulatorCard extends StatelessWidget {
  final Regulator regulator;

  const RegulatorCard({super.key, required this.regulator});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(regulator.name),
        subtitle: Text(
          "${regulator.current} A • ${regulator.type} • ${regulator.pvMaxPower} W PV",
          style: TextStyle(color: Colors.grey[700]),
        ),

        trailing: Text("${regulator.price} €"),
      ),
    );
  }
}
