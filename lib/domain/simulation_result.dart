class SimulationResult {
  final double totalPower; // Puissance totale PV (W)
  final double dailyEnergy; // Production journalière (Wh)
  final double monthlyEnergy; // Production mensuelle (Wh)
  final double annualEnergy; // Production annuelle (Wh)

  final double batteryCapacity; // Capacité batterie utile (Wh)
  final double autonomyHours; // Autonomie (h)

  final double inverterLoad; // Charge onduleur (%)
  final double regulatorLoad; // Charge régulateur (%)

  final bool isSystemValid; // Système dimensionné correctement ?

  SimulationResult({
    required this.totalPower,
    required this.dailyEnergy,
    required this.monthlyEnergy,
    required this.annualEnergy,
    required this.batteryCapacity,
    required this.autonomyHours,
    required this.inverterLoad,
    required this.regulatorLoad,
    required this.isSystemValid,
  });

  Map<String, dynamic> toMap() => {
    'totalPower': totalPower,
    'dailyEnergy': dailyEnergy,
    'monthlyEnergy': monthlyEnergy,
    'annualEnergy': annualEnergy,
    'batteryCapacity': batteryCapacity,
    'autonomyHours': autonomyHours,
    'inverterLoad': inverterLoad,
    'regulatorLoad': regulatorLoad,
    'isSystemValid': isSystemValid,
  };

  factory SimulationResult.fromMap(Map<String, dynamic> m) => SimulationResult(
    totalPower: (m['totalPower'] as num?)?.toDouble() ?? 0.0,
    dailyEnergy: (m['dailyEnergy'] as num?)?.toDouble() ?? 0.0,
    monthlyEnergy: (m['monthlyEnergy'] as num?)?.toDouble() ?? 0.0,
    annualEnergy: (m['annualEnergy'] as num?)?.toDouble() ?? 0.0,
    batteryCapacity: (m['batteryCapacity'] as num?)?.toDouble() ?? 0.0,
    autonomyHours: (m['autonomyHours'] as num?)?.toDouble() ?? 0.0,
    inverterLoad: (m['inverterLoad'] as num?)?.toDouble() ?? 0.0,
    regulatorLoad: (m['regulatorLoad'] as num?)?.toDouble() ?? 0.0,
    isSystemValid: m['isSystemValid'] ?? false,
  );

  @override
  String toString() =>
      "Simulation: ${totalPower}W, ${dailyEnergy}Wh/j, autonomie ${autonomyHours}h";
}
