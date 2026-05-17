class Battery {
  final String name;
  final double capacity;
  final double voltage;
  final double dod;
  final double efficiency;
  final double price;
  final String type;

  Battery({
    required this.name,
    required this.capacity,
    required this.voltage,
    required this.dod,
    required this.efficiency,
    required this.price,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'capacity': capacity,
    'voltage': voltage,
    'dod': dod,
    'efficiency': efficiency,
    'price': price,
    'type': type,
  };

  factory Battery.fromMap(Map<String, dynamic> m) => Battery(
    name: m['name'],
    capacity: (m['capacity'] ?? 0).toDouble(),
    voltage: (m['voltage'] ?? 0).toDouble(),
    dod: (m['dod'] ?? 0).toDouble(),
    efficiency: (m['efficiency'] ?? 0).toDouble(),
    price: (m['price'] ?? 0).toDouble(),
    type: m['type'] ?? "",
  );
}
