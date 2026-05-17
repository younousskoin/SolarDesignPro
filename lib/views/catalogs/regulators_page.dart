import 'package:flutter/material.dart';
import '../../domain/regulator.dart';
import '../../data/catalogs.dart';
import '../../models/widgets/regulator_card.dart';
import '../details/regulator_details_page.dart';

class RegulatorsPage extends StatefulWidget {
  const RegulatorsPage({super.key});

  @override
  State<RegulatorsPage> createState() => _RegulatorsPageState();
}

class _RegulatorsPageState extends State<RegulatorsPage> {
  String search = "";
  String sort = "Courant";

  @override
  Widget build(BuildContext context) {
    List<Regulator> items = List.from(regulatorsDb);

    // 🔍 FILTRAGE
    if (search.isNotEmpty) {
      final s = search.toLowerCase();
      items = items.where((r) {
        return r.name.toLowerCase().contains(s) ||
            r.type.toLowerCase().contains(s) ||
            r.current.toString().contains(s) ||
            r.batteryVoltage.toString().contains(s);
      }).toList();
    }

    // ↕️ TRI
    if (sort == "Courant") {
      items.sort((a, b) => a.current.compareTo(b.current));
    } else if (sort == "Tension") {
      items.sort((a, b) => a.batteryVoltage.compareTo(b.batteryVoltage));
    } else if (sort == "Prix") {
      items.sort((a, b) => a.price.compareTo(b.price));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalogue Régulateurs"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // 🔍 BARRE DE RECHERCHE
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Rechercher (ex: MPPT, 30A, 48V...)",
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
                      value: "Courant",
                      child: Text("Courant (A)"),
                    ),
                    DropdownMenuItem(
                      value: "Tension",
                      child: Text("Tension (V)"),
                    ),
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
                      "Aucun régulateur trouvé",
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
                      final regulator = items[index];

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RegulatorDetailsPage(regulator: regulator),
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
                          child: RegulatorCard(regulator: regulator),
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
