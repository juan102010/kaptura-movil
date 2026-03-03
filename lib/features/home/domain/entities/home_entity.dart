class HomeEntity {
  const HomeEntity({
    required this.id,
    required this.name,
    required this.stateClock,
  });

  final String id;
  final String name;
  final bool stateClock;

  HomeEntity copyWith({String? id, String? name, bool? stateClock}) {
    return HomeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      stateClock: stateClock ?? this.stateClock,
    );
  }
}
