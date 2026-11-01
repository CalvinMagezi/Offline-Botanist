import 'package:botany_core/botany_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(OfflineBotanistApp(log: PlantLog()));
}

class OfflineBotanistApp extends StatelessWidget {
  const OfflineBotanistApp({super.key, required this.log});

  final PlantLog log;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Botanist',
      home: Scaffold(
        appBar: AppBar(title: const Text('Offline Botanist')),
        body: Center(child: Text('${log.plants.length} plants logged')),
      ),
    );
  }
}
