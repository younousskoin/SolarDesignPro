import 'package:flutter/material.dart';
import '../../domain/inverter.dart';
import '../../data/catalogs.dart';
import '../../models/widgets/inverter_card.dart';
import 'inverter_details_page.dart';

class InvertersPage extends StatefulWidget {
  const InvertersPage({super.key});

  @override
  State<InvertersPage> createState() => _InvertersPageState();
}

class _InvertersPageState extends State<InvertersPage> {
  String search = "";
  String sort = "Puissance";

  @override
  Widget build(BuildContext context) {
    List<Inverter> items = List.from(invertersDb);

    // 🔍 FILTRAGE
    if (search.isNotEmpty) {
      items = items.where((inv) {
        final s = search.toLowerCase();
        return inv.name.toLowerCase().contains(s) ||
            inv.type.toLowerCase().contains(s) ||
            inv.power.toString().contains(s) ||
            inv.inputVoltage.toString().contains(s);
      }).toList();
    }

    // ↕️ TRI
    if (sort == "Puissance") {
      items.sort((a, b) => a.power.compareTo(b.power));
    } else if (sort == "Prix") {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (sort == "Tension") {
      items.sort((a, b) => a.inputVoltage.compareTo(b.inputVoltage));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogue Onduleurs"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // 🔍 BARRE DE RECHERCHE
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher (ex: 1000W, 48V, hybride...)",
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
                    DropdownMenuItem(value: "Prix", child: Text("Prix")),
                    DropdownMenuItem(
                      value: "Tension",
                      child: Text("Tension entrée"),
                    ),
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
                      "Aucun onduleur trouvé",
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
                      final inverter = items[index];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                InverterDetailsPage(inverter: inverter),
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
                          child: InverterCard(inverter: inverter),
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
