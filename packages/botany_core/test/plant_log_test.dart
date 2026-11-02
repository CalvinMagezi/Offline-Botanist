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

  test('a preparation needs at least one step', () {
    expect(
      () => Preparation(
        plantId: 'mint',
        method: PreparationMethod.tea,
        steps: const [],
      ),
      throwsArgumentError,
    );
    expect(
      () => Preparation(
        plantId: 'mint',
        method: PreparationMethod.tea,
        steps: const ['  '],
      ),
      throwsArgumentError,
    );
  });

  test('a preparation keeps its method, steps and cautions', () {
    final prep = Preparation(
      plantId: 'mint',
      method: PreparationMethod.infusion,
      steps: const ['Steep leaves', 'Strain'],
      cautions: const ['Avoid in pregnancy'],
    );
    expect(prep.method, PreparationMethod.infusion);
    expect(prep.steps, ['Steep leaves', 'Strain']);
    expect(prep.cautions, ['Avoid in pregnancy']);
  });

  test('a preparation of an unlogged plant is refused', () {
    final log = PlantLog();
    final prep = Preparation(
      plantId: 'mint',
      method: PreparationMethod.tea,
      steps: const ['Boil water'],
    );
    expect(() => log.recordPreparation(prep), throwsStateError);
  });

  test('preparations are stored per logged plant', () {
    final log = PlantLog()
      ..addPlant(mint())
      ..addPlant(Plant(id: 'ginger', commonName: 'Ginger'));
    log
      ..recordPreparation(
        Preparation(
          plantId: 'mint',
          method: PreparationMethod.tea,
          steps: const ['Boil water', 'Add leaves'],
        ),
      )
      ..recordPreparation(
        Preparation(
          plantId: 'ginger',
          method: PreparationMethod.decoction,
          steps: const ['Simmer root'],
        ),
      );
    final mintPreps = log.preparationsOf('mint');
    expect(mintPreps.map((p) => p.method), [PreparationMethod.tea]);
    expect(
      log.preparationsOf('ginger').single.method,
      PreparationMethod.decoction,
    );
    expect(log.preparationsOf('nettle'), isEmpty);
  });
}
