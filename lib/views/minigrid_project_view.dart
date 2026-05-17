import 'package:flutter/material.dart';

class MiniGridView extends StatelessWidget {
  const MiniGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mini-réseau")),
      body: const Center(
        child: Text("Page Mini-réseau", style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
