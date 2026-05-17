import 'package:flutter/material.dart';
import '../../domain/pump.dart';
import '../../data/catalogs.dart';
import '../../models/widgets/pump_card.dart';
import '../details/pump_details_page.dart';

class PumpsPage extends StatefulWidget {
  const PumpsPage({super.key});

  @override
  State<PumpsPage> createState() => _PumpsPageState();
}

class _PumpsPageState extends State<PumpsPage> {
  String search = "";
  String sort = "Puissance";

  @override
  Widget build(BuildContext context) {
    List<Pump> items = List.from(pumpsDb);

    // 🔍 FILTRAGE
    if (search.isNotEmpty) {
      final s = search.toLowerCase();
      items = items.where((p) {
        return p.name.toLowerCase().contains(s) ||
            p.flow.toString().contains(s) ||
            p.head.toString().contains(s) ||
            p.power.toString().contains(s);
      }).toList();
    }

    // ↕️ TRI
    if (sort == "Puissance") {
      items.sort((a, b) => a.power.compareTo(b.power));
    } else if (sort == "Débit") {
      items.sort((a, b) => a.flow.compareTo(b.flow));
    } else if (sort == "HMT") {
      items.sort((a, b) => a.head.compareTo(b.head));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Catalogue Pompes"), centerTitle: true),

      body: Column(
        children: [
          // 🔍 BARRE DE RECHERCHE
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher (ex: 2m³/h, 40m HMT, 370W...)",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),

          // ↕️ MENU DE TRI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text("Trier par : "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: sort,
                  items: const [
                    DropdownMenuItem(
                      value: "Puissance",
                      child: Text("Puissance"),
                    ),
                    DropdownMenuItem(
                      value: "Débit",
                      child: Text("Débit (m³/h)"),
                    ),
                    DropdownMenuItem(value: "HMT", child: Text("HMT (m)")),
                  ],
                  onChanged: (value) => setState(() => sort = value!),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📋 LISTE
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      "Aucune pompe trouvée",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pump = items[index];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PumpDetailsPage(pump: pump),
                          ),
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: PumpCard(pump: pump),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
