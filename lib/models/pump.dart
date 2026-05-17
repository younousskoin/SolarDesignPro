class Pump {
  final String id;
  final String brand;
  final String modelRef;

  final String name;
  final double power;
  final double flow;
  final double head;
  final double price;
  final String type;

  final double hoursPerDay;
  final double efficiency;
  final double startingCurrent;

  final String supplyVoltage;
  final double supplyVoltageValue;

  final String currency;
  final int lifetimeYears;

  Pump({
    required this.id,
    required this.brand,
    required this.modelRef,
    required this.name,
    required this.power,
    required this.flow,
    required this.head,
    required this.price,
    required this.type,
    this.hoursPerDay = 5,
    required this.efficiency,
    required this.startingCurrent,
    required this.supplyVoltage,
    required this.supplyVoltageValue,
    this.currency = "EUR",
    this.lifetimeYears = 10,
  });
}
