import 'dart:convert';

import 'package:botany_core/botany_core.dart';
import 'package:test/test.dart';

void main() {
  test('a plant log survives a JSON round trip', () {
    final log = PlantLog()
      ..addPlant(
        Plant(id: 'mint', commonName: 'Mint', scientificName: 'Mentha'),
      )
      ..addPlant(Plant(id: 'ginger', commonName: 'Ginger'))
      ..recordSighting(
        Sighting(
          plantId: 'mint',
          observedAt: DateTime.utc(2026, 6, 1, 9, 30),
          note: 'by the river',
        ),
      )
      ..recordSighting(
        Sighting(plantId: 'mint', observedAt: DateTime.utc(2026, 1, 1)),
      );

    final encoded = jsonEncode(log.toJson());
    final restored = PlantLog.fromJson(
      jsonDecode(encoded) as Map<String, dynamic>,
    );

    final mint = restored.plant('mint')!;
    expect(mint.commonName, 'Mint');
    expect(mint.scientificName, 'Mentha');
    expect(restored.plant('ginger')!.scientificName, isNull);
    expect(restored.plants.map((p) => p.id), ['mint', 'ginger']);

    final sightings = restored.sightingsOf('mint');
    expect(sightings.map((s) => s.observedAt.toUtc()), [
      DateTime.utc(2026, 6, 1, 9, 30),
      DateTime.utc(2026, 1, 1),
    ]);
    expect(sightings.first.note, 'by the river');
    expect(sightings.last.note, isNull);
  });

  test('loading refuses a sighting of an unknown plant', () {
    final json = {
      'plants': <Object>[],
      'sightings': [
        {
          'plantId': 'mint',
          'observedAt': DateTime.utc(2026, 1, 1).toIso8601String(),
          'note': null,
        },
      ],
    };
    expect(
      () => PlantLog.fromJson(json),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'no plant with id mint is logged',
        ),
      ),
    );
  });

  test('loading refuses a duplicate plant id', () {
    final json = {
      'plants': [
        {'id': 'mint', 'commonName': 'Mint', 'scientificName': null},
        {'id': 'mint', 'commonName': 'Mint again', 'scientificName': null},
      ],
      'sightings': <Object>[],
    };
    expect(
      () => PlantLog.fromJson(json),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'a plant with id mint is already logged',
        ),
      ),
    );
  });
}
