class PvArray {
  final double modulePower; // Wc
  final int series;
  final int parallel;
  final double pr; // performance ratio

  PvArray({
    required this.modulePower,
    required this.series,
    required this.parallel,
    required this.pr,
  });

  double get totalPower => modulePower * series * parallel;
}
