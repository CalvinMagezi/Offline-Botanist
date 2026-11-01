import 'package:botany_core/botany_core.dart';
import 'package:test/test.dart';

void main() {
  Plant mint() =>
      Plant(id: 'mint', commonName: 'Mint', scientificName: 'Mentha');

  test('a plant needs an id and a common name', () {
    expect(() => Plant(id: ' ', commonName: 'Mint'), throwsArgumentError);
    expect(() => Plant(id: 'mint', commonName: '  '), throwsArgumentError);
    expect(Plant(id: 'mint', commonName: ' Mint ').commonName, 'Mint');
  });

  test('the same plant id cannot be logged twice', () {
    final log = PlantLog()..addPlant(mint());
    expect(() => log.addPlant(mint()), throwsStateError);
  });

  test('a sighting of an unlogged plant is refused', () {
    final log = PlantLog();
    final sighting = Sighting(
      plantId: 'mint',
      observedAt: DateTime(2026, 11, 1),
    );
    expect(() => log.recordSighting(sighting), throwsStateError);
  });

  test('sightings come back newest first', () {
    final log = PlantLog()..addPlant(mint());
    log
      ..recordSighting(
        Sighting(plantId: 'mint', observedAt: DateTime(2026, 1, 1)),
      )
      ..recordSighting(
        Sighting(plantId: 'mint', observedAt: DateTime(2026, 6, 1)),
      );
    expect(log.sightingsOf('mint').map((s) => s.observedAt.month), [6, 1]);
  });
}
