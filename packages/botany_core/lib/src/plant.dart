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

  Map<String, dynamic> toJson() => {
    'id': id,
    'commonName': commonName,
    'scientificName': scientificName,
  };

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
    id: json['id'] as String,
    commonName: json['commonName'] as String,
    scientificName: json['scientificName'] as String?,
  );
}

/// One time the user saw or gathered a plant.
class Sighting {
  const Sighting({required this.plantId, required this.observedAt, this.note});

  final String plantId;
  final DateTime observedAt;
  final String? note;

  Map<String, dynamic> toJson() => {
    'plantId': plantId,
    'observedAt': observedAt.toIso8601String(),
    'note': note,
  };

  factory Sighting.fromJson(Map<String, dynamic> json) => Sighting(
    plantId: json['plantId'] as String,
    observedAt: DateTime.parse(json['observedAt'] as String),
    note: json['note'] as String?,
  );
}

/// How a plant is prepared for use.
enum PreparationMethod { tea, infusion, decoction }

/// A way the user prepares one logged plant, with its steps and cautions.
class Preparation {
  Preparation({
    required this.plantId,
    required this.method,
    required List<String> steps,
    List<String> cautions = const [],
  }) : steps = List.unmodifiable(steps),
       cautions = List.unmodifiable(cautions) {
    if (this.steps.every((s) => s.trim().isEmpty)) {
      throw ArgumentError.value(
        steps,
        'steps',
        'must include at least one step',
      );
    }
  }

  final String plantId;
  final PreparationMethod method;
  final List<String> steps;
  final List<String> cautions;
}
