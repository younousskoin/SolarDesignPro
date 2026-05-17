import 'package:flutter/material.dart';
import '../../domain/panel.dart';
import '../../data/catalogs.dart';
import '../../models/widgets/panel_card.dart';
import '../details/panel_details_page.dart';

class PanelsPage extends StatefulWidget {
  const PanelsPage({super.key});

  @override
  State<PanelsPage> createState() => _PanelsPageState();
}

class _PanelsPageState extends State<PanelsPage> {
  String search = "";
  String sort = "Puissance";

  @override
  Widget build(BuildContext context) {
    List<Panel> items = List.from(panelsDb);

    // 🔍 FILTRAGE
    if (search.isNotEmpty) {
      final s = search.toLowerCase();
      items = items.where((p) {
        return p.name.toLowerCase().contains(s) ||
            p.power.toString().contains(s) ||
            p.voc.toString().contains(s) ||
            p.vmp.toString().contains(s);
      }).toList();
    }

    // ↕️ TRI
    if (sort == "Puissance") {
      items.sort((a, b) => a.power.compareTo(b.power));
    } else if (sort == "Tension") {
      items.sort((a, b) => a.vmp.compareTo(b.vmp));
    } else if (sort == "Prix") {
      items.sort((a, b) => a.price.compareTo(b.price));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogue Panneaux"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // 🔍 BARRE DE RECHERCHE
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher (ex: 450W, 40V, mono...)",
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
                    DropdownMenuItem(value: "Tension", child: Text("Tension")),
                    DropdownMenuItem(value: "Prix", child: Text("Prix")),
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
                      "Aucun panneau trouvé",
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
                      final panel = items[index];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PanelDetailsPage(panel: panel),
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
                          child: PanelCard(panel: panel),
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
