import 'package:flutter/material.dart';

class SelfConsumptionView extends StatelessWidget {
  const SelfConsumptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autoconsommation")),
      body: const Center(
        child: Text("Page Autoconsommation", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
