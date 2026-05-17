import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../domain/system_type.dart';
import '../theme.dart';
import '../views/project_input_view.dart';

class ProjectTypeView extends StatelessWidget {
  const ProjectTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    final types = PVSystemType.values;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text("Choisir le type de projet"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(color: Colors.white.withOpacity(0.75)),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 1.05,
        ),
        itemCount: types.length,
        itemBuilder: (context, i) {
          final t = types[i];
          return _typeCard(context, t);
        },
      ),
    );
  }

  Widget _typeCard(BuildContext context, PVSystemType type) {
    final icon = _iconForType(type);
    final color = _colorForType(type);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectInputView(preselectedType: type),
          ),
        );
      },
      child: Container(
        decoration: AppTheme.whiteCard.copyWith(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 14),
            Text(
              type.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _descriptionForType(type),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(PVSystemType type) {
    switch (type.key) {
      case "isolated":
        return Icons.solar_power;
      case "hybrid":
        return Icons.bolt;
      case "selfconsumption":
        return Icons.home;
      case "pumping":
        return Icons.water;
      case "minigrid":
        return Icons.grid_view;
      default:
        return Icons.settings;
    }
  }

  Color _colorForType(PVSystemType type) {
    switch (type.key) {
      case "isolated":
        return AppTheme.blueDeep;
      case "hybrid":
        return Colors.orange;
      case "selfconsumption":
        return Colors.green;
      case "pumping":
        return Colors.teal;
      case "minigrid":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _descriptionForType(PVSystemType type) {
    switch (type.key) {
      case "isolated":
        return "Système autonome sans réseau.";
      case "hybrid":
        return "PV + batterie + réseau ou diesel.";
      case "selfconsumption":
        return "Production pour usage direct.";
      case "pumping":
        return "Pompage solaire pour irrigation.";
      case "minigrid":
        return "Mini-réseau communautaire.";
      default:
        return "Projet personnalisé selon vos besoins.";
    }
  }
}
