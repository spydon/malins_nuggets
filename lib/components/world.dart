import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:malins_nuggets/components/item.dart';
import 'package:malins_nuggets/components/player.dart';

class MalinsWorld extends World with HasGameReference, HasCollisionDetection {
  late final SpawnComponent itemSpawner = SpawnComponent.periodRange(
    minPeriod: 0.5,
    maxPeriod: 10,
    area: Rectangle.fromLTWH(
      -game.size.x / 2,
      -game.size.y / 2 - 100,
      game.size.x,
      100,
    ),
    factory: (i) => Item(),
  );

  @override
  Future<void> onLoad() async {
    addAll([PlayerComponent(), itemSpawner]);
  }
}
