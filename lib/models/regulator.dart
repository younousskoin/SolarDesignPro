class Regulator {
  final String name; // Nom du régulateur
  final double current; // Courant nominal (A)
  final String type; // PWM ou MPPT
  final double pvMaxPower; // Puissance PV max (W)
  final double price; // Prix (€)

  // Champs avancés
  final double efficiency; // Rendement (0–1)
  final double maxPvVoltage; // Tension PV max admissible (V)
  final double batteryVoltage; // Tension batterie (V)

  Regulator({
    required this.name,
    required this.current,
    required this.type,
    required this.pvMaxPower,
    required this.price,
    required this.efficiency,
    required this.maxPvVoltage,
    required this.batteryVoltage,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'current': current,
    'type': type,
    'pvMaxPower': pvMaxPower,
    'price': price,
    'efficiency': efficiency,
    'maxPvVoltage': maxPvVoltage,
    'batteryVoltage': batteryVoltage,
  };

  factory Regulator.fromMap(Map<String, dynamic> m) => Regulator(
    name: m['name'] ?? "",
    current: (m['current'] as num?)?.toDouble() ?? 0.0,
    type: m['type'] ?? "",
    pvMaxPower: (m['pvMaxPower'] as num?)?.toDouble() ?? 0.0,
    price: (m['price'] as num?)?.toDouble() ?? 0.0,
    efficiency: (m['efficiency'] as num?)?.toDouble() ?? 0.9,
    maxPvVoltage: (m['maxPvVoltage'] as num?)?.toDouble() ?? 0.0,
    batteryVoltage: (m['batteryVoltage'] as num?)?.toDouble() ?? 0.0,
  );

  @override
  String toString() => "$name (${current}A)";

  // Catalogue professionnel
  static List<Regulator> all = [
    Regulator(
      name: "Régulateur PWM 10A",
      current: 10,
      type: "PWM",
      pvMaxPower: 150,
      price: 25,
      efficiency: 0.85,
      maxPvVoltage: 25,
      batteryVoltage: 12,
    ),
    Regulator(
      name: "Régulateur MPPT 20A",
      current: 20,
      type: "MPPT",
      pvMaxPower: 300,
      price: 80,
      efficiency: 0.95,
      maxPvVoltage: 100,
      batteryVoltage: 12,
    ),
    Regulator(
      name: "Régulateur MPPT 40A",
      current: 40,
      type: "MPPT",
      pvMaxPower: 600,
      price: 150,
      efficiency: 0.97,
      maxPvVoltage: 150,
      batteryVoltage: 24,
    ),
  ];
}
