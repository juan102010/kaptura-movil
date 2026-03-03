class ClockCoords {
  const ClockCoords({
    required this.lat,
    required this.lng,
    required this.accuracy,
  });

  final double lat;
  final double lng;
  final double accuracy;

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lng': lng,
    'accuracy': accuracy,
  };
}
