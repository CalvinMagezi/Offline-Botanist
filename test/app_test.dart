import 'package:botany_core/botany_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_botanist/main.dart';

void main() {
  testWidgets('the home screen counts logged plants', (tester) async {
    final log = PlantLog()..addPlant(Plant(id: 'mint', commonName: 'Mint'));
    await tester.pumpWidget(OfflineBotanistApp(log: log));
    expect(find.text('1 plants logged'), findsOneWidget);
  });
}
