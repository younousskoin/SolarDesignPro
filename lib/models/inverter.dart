class Inverter {
  final String name; // Nom de l'onduleur
  final double power; // Puissance nominale AC (W)
  final double inputVoltage; // Tension d'entrée DC (V)
  final String outputVoltage; // Tension de sortie AC (ex: "230V AC")
  final String type; // Pur Sinus, Hybride, etc.
  final double price; // Prix (€)

  // Champs avancés
  final double efficiency; // Rendement (0–1)
  final double maxPvPower; // Puissance PV max admissible (W)
  final double maxCurrent; // Courant max AC (A)
  final double pvMaxVoltage; // ⚠️ Tension PV max admissible (Voc max)

  Inverter({
    required this.name,
    required this.power,
    required this.inputVoltage,
    required this.outputVoltage,
    required this.type,
    required this.price,
    required this.efficiency,
    required this.maxPvPower,
    required this.maxCurrent,
    required this.pvMaxVoltage,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'power': power,
    'inputVoltage': inputVoltage,
    'outputVoltage': outputVoltage,
    'type': type,
    'price': price,
    'efficiency': efficiency,
    'maxPvPower': maxPvPower,
    'maxCurrent': maxCurrent,
    'pvMaxVoltage': pvMaxVoltage,
  };

  factory Inverter.fromMap(Map<String, dynamic> m) => Inverter(
    name: m['name'] ?? "",
    power: (m['power'] as num?)?.toDouble() ?? 0.0,
    inputVoltage: (m['inputVoltage'] as num?)?.toDouble() ?? 0.0,
    outputVoltage: m['outputVoltage'] ?? "",
    type: m['type'] ?? "",
    price: (m['price'] as num?)?.toDouble() ?? 0.0,
    efficiency: (m['efficiency'] as num?)?.toDouble() ?? 0.9,
    maxPvPower: (m['maxPvPower'] as num?)?.toDouble() ?? 0.0,
    maxCurrent: (m['maxCurrent'] as num?)?.toDouble() ?? 0.0,
    pvMaxVoltage: (m['pvMaxVoltage'] as num?)?.toDouble() ?? 150.0,
  );

  @override
  String toString() => "$name (${power}W)";

  // Catalogue professionnel
  static List<Inverter> all = [
    Inverter(
      name: "Onduleur Pur Sinus 500W",
      power: 500,
      inputVoltage: 12,
      outputVoltage: "230V AC",
      type: "Pur Sinus",
      price: 120,
      efficiency: 0.90,
      maxPvPower: 600,
      maxCurrent: 50,
      pvMaxVoltage: 100,
    ),
    Inverter(
      name: "Onduleur Hybride 1kW",
      power: 1000,
      inputVoltage: 24,
      outputVoltage: "230V AC",
      type: "Hybride",
      price: 350,
      efficiency: 0.92,
      maxPvPower: 1500,
      maxCurrent: 60,
      pvMaxVoltage: 145,
    ),
    Inverter(
      name: "Onduleur Hybride 3kW",
      power: 3000,
      inputVoltage: 48,
      outputVoltage: "230V AC",
      type: "Hybride",
      price: 650,
      efficiency: 0.94,
      maxPvPower: 4500,
      maxCurrent: 80,
      pvMaxVoltage: 200,
    ),
  ];
}
