import 'package:flutter/material.dart';
import '../domain/system_type.dart';
import '../views/project_input_view.dart';
import '../theme.dart';
import '../widgets/fade_slide.dart';
import '../widgets/fade_scale.dart';
import '../widgets/slide_fade_horizontal.dart';

class SystemSelectionPage extends StatelessWidget {
  const SystemSelectionPage({super.key});

  final List<Map<String, dynamic>> systems = const [
    {
      "name": "Système Off-Grid",
      "type": PVSystemType.offGrid,
      "image": "assets/offgrid.png",
      "description": "Un système autonome sans réseau.",
    },
    {
      "name": "Système On-Grid",
      "type": PVSystemType.onGrid,
      "image": "assets/ongrid.png",
      "description": "Un système connecté au réseau.",
    },
    {
      "name": "Système Hybride",
      "type": PVSystemType.hybrid,
      "image": "assets/hybrid.png",
      "description": "Un système combinant PV, batterie et réseau.",
    },
    {
      "name": "Pompage direct",
      "type": PVSystemType.directUse,
      "image": "assets/direct.png",
      "description": "Pompage solaire sans batterie.",
    },
    {
      "name": "Pompage avec stockage",
      "type": PVSystemType.pumpingWithStorage,
      "image": "assets/pumping_storage.png",
      "description": "Pompage solaire avec batterie.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: SlideFadeHorizontal(
          delay: 100,
          child: const Text(
            "Choisir un type de système",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: systems.length,
        itemBuilder: (context, index) {
          final system = systems[index];

          return FadeScale(
            delay: 150 + (index * 80),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjectInputView(
                      preselectedType: system["type"] as PVSystemType,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.whiteCard,
                child: Row(
                  children: [
                    // IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        system["image"] as String,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // TEXTES
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            system["name"] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            system["description"] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
