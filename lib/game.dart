import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:malins_nuggets/audio_manager.dart';
import 'package:malins_nuggets/components/background.dart';
import 'package:malins_nuggets/components/button.dart';
import 'package:malins_nuggets/components/world.dart';

var _textRenderer = TextPaint(
  style: const TextStyle(fontSize: 50, fontFamily: 'Handlee'),
);

class MalinsNuggetsGame extends FlameGame<MalinsWorld> {
  MalinsNuggetsGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            height: 1080,
            width: 1920,
          ),
          world: MalinsWorld(),
        );

  final Background background = Background(Vector2(0, 0));
  final TextComponent scoreText = TextComponent(
    text: 'Score: 0',
    position: Vector2.all(20),
    textRenderer: _textRenderer,
  );
  final TextComponent timerText = TextComponent(
    text: '60 seconds',
    position: Vector2(20, 70),
    textRenderer: _textRenderer,
  );

  final sounds = <String, Object?>{};

  int _score = 0;
  int get score => _score;
  set score(int value) {
    _score = value;
    scoreText.text = 'Score: $value';
    if (value < 0) {
      speed = max(speed, 1 + _score / 20);
      world.itemSpawner.maxPeriod = max(0.5, 3 - _score / 10);
    }
  }

  double speed = 1;
  double timeLeft = 90;
  bool isGameOver = false;

  void reset() {
    world.add(world.itemSpawner);
    speed = 1;
    score = 0;
    timeLeft = 90;
    isGameOver = false;
  }

  late final AudioManager audioManager;

  @override
  void update(double dt) {
    super.update(dt);
    if (!isGameOver) {
      timeLeft -= dt;
      timerText.text = '${max(timeLeft, 0).toStringAsFixed(0)} seconds';
    }
    if (timeLeft <= 0 && !isGameOver) {
      isGameOver = true;
      world.itemSpawner.removeFromParent();
      final endText = TextComponent(
          text: 'Grattis Malin!!! <3',
          textRenderer: _textRenderer,
          position: size / 2,
          anchor: Anchor.center)
        ..add(
          ScaleEffect.to(
            Vector2.all(1.5),
            EffectController(duration: 0.5, alternate: true, infinite: true),
          ),
        );
      late final RestartButton restartButton;
      camera.viewport.addAll([
        endText,
        restartButton = RestartButton(
          position: size / 2 + Vector2(0, 100),
          onPressed: () {
            restartButton.removeFromParent();
            endText.removeFromParent();
            reset();
          },
        ),
      ]);
    }
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();
    final sky = await Sprite.load('parallax/6.png');
    audioManager = await AudioManager.load();

    camera.backdrop.add(SpriteComponent(sprite: sky, size: size));
    camera.backdrop.add(background);
    camera.viewport.add(scoreText);
    camera.viewport.add(timerText);
  }
}
