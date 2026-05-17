import 'package:flutter/material.dart';

class CustomProjectView extends StatelessWidget {
  const CustomProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Projet personnalisé")),
      body: const Center(
        child: Text("Page Projet personnalisé", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
