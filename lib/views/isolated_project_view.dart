import 'package:flutter/material.dart';

class IsolatedProjectView extends StatelessWidget {
  const IsolatedProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Système isolé")),
      body: const Center(
        child: Text("Page Système isolé", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
