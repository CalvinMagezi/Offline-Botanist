/// A plant the user keeps in their log.
class Plant {
  Plant({required this.id, required String commonName, this.scientificName})
    : commonName = commonName.trim() {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'must not be blank');
    }
    if (this.commonName.isEmpty) {
      throw ArgumentError.value(commonName, 'commonName', 'must not be blank');
    }
  }

  final String id;
  final String commonName;
  final String? scientificName;
}

/// One time the user saw or gathered a plant.
class Sighting {
  const Sighting({required this.plantId, required this.observedAt, this.note});

  final String plantId;
  final DateTime observedAt;
  final String? note;
}
