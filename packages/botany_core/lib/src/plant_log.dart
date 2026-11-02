import 'plant.dart';

/// The user's plants and their sightings, held in memory.
class PlantLog {
  final Map<String, Plant> _plants = {};
  final List<Sighting> _sightings = [];
  final List<Preparation> _preparations = [];

  PlantLog();

  Iterable<Plant> get plants => _plants.values;

  void addPlant(Plant plant) {
    if (_plants.containsKey(plant.id)) {
      throw StateError('a plant with id ${plant.id} is already logged');
    }
    _plants[plant.id] = plant;
  }

  Plant? plant(String id) => _plants[id];

  /// Records a sighting. A sighting of a plant that is not logged is refused,
  /// so the log never holds an orphan.
  void recordSighting(Sighting sighting) {
    if (!_plants.containsKey(sighting.plantId)) {
      throw StateError('no plant with id ${sighting.plantId} is logged');
    }
    _sightings.add(sighting);
  }

  /// Sightings of one plant, newest first.
  List<Sighting> sightingsOf(String plantId) =>
      _sightings.where((s) => s.plantId == plantId).toList()
        ..sort((a, b) => b.observedAt.compareTo(a.observedAt));

  /// Records a preparation. A preparation of a plant that is not logged is
  /// refused, so the log never holds an orphan.
  void recordPreparation(Preparation preparation) {
    if (!_plants.containsKey(preparation.plantId)) {
      throw StateError('no plant with id ${preparation.plantId} is logged');
    }
    _preparations.add(preparation);
  }

  /// Preparations of one plant, in the order they were recorded.
  List<Preparation> preparationsOf(String plantId) =>
      _preparations.where((p) => p.plantId == plantId).toList();

  /// Plants, sightings and preparations.
  Map<String, dynamic> toJson() => {
    'plants': [for (final plant in _plants.values) plant.toJson()],
    'sightings': [for (final sighting in _sightings) sighting.toJson()],
    'preparations': [
      for (final preparation in _preparations) preparation.toJson(),
    ],
  };

  /// Rebuilds a log through [addPlant], [recordSighting] and
  /// [recordPreparation], so duplicate plant ids and records of unknown plants
  /// are refused with the same errors as the live methods. A missing
  /// `preparations` key is read as no preparations.
  factory PlantLog.fromJson(Map<String, dynamic> json) {
    final log = PlantLog();
    for (final plant in json['plants'] as List<dynamic>) {
      log.addPlant(Plant.fromJson(plant as Map<String, dynamic>));
    }
    for (final sighting in json['sightings'] as List<dynamic>) {
      log.recordSighting(Sighting.fromJson(sighting as Map<String, dynamic>));
    }
    for (final preparation
        in (json['preparations'] as List<dynamic>?) ?? const <dynamic>[]) {
      log.recordPreparation(
        Preparation.fromJson(preparation as Map<String, dynamic>),
      );
    }
    return log;
  }
}
