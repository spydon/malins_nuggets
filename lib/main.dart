import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:malins_nuggets/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GameWidget.controlled(
          gameFactory: MalinsNuggetsGame.new,
          loadingBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
