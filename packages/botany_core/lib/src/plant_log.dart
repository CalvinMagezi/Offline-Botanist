import 'plant.dart';

/// The user's plants and their sightings, held in memory.
class PlantLog {
  final Map<String, Plant> _plants = {};
  final List<Sighting> _sightings = [];

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
}
