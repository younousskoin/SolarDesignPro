import 'package:flutter/material.dart';

class PumpingProjectView extends StatelessWidget {
  const PumpingProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pompage solaire")),
      body: const Center(
        child: Text("Page Pompage solaire", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
