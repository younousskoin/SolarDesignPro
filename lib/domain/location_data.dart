class LocationData {
  final double latitude;
  final double longitude;
  final String country;
  final String city;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.city,
  });

  Map<String, dynamic> toMap() => {
    'latitude': latitude,
    'longitude': longitude,
    'country': country,
    'city': city,
  };

  factory LocationData.fromMap(Map<String, dynamic> m) => LocationData(
    latitude: (m['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (m['longitude'] as num?)?.toDouble() ?? 0.0,
    country: m['country'] ?? "",
    city: m['city'] ?? "",
  );
}
