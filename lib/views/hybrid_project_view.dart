import 'package:flutter/material.dart';

class HybridProjectView extends StatelessWidget {
  const HybridProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Système hybride")),
      body: const Center(
        child: Text("Page Système hybride", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
