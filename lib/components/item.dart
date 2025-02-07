import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:malins_nuggets/game.dart';

class Item extends SpriteComponent
    with HasGameReference<MalinsNuggetsGame>, CollisionCallbacks {
  Item()
      : super(
          size: Vector2.all(100),
          anchor: Anchor.center,
          children: [CircleHitbox()],
        );

  late final entry = _items.random();
  bool isDead = false;
  bool isTaken = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load(entry.name);
    add(
      ScaleEffect.to(
        Vector2.all(1.1),
        EffectController(
          duration: 0.3,
          infinite: true,
          alternate: true,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += game.speed * 100 * dt;
    if (!isDead && position.y > game.size.y / 2) {
      if (entry.isGood) {
        game.score--;
      }
      removeEffect();
    }
  }

  void removeEffect() {
    isDead = true;
    add(
      MoveByEffect(
        Vector2(0, -100),
        EffectController(duration: 0.25, alternate: true),
        onComplete: removeFromParent,
      ),
    );
    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.5),
        onComplete: removeFromParent,
      ),
    );
  }
}

typedef ItemEntry = ({
  String name,
  String sound,
  bool isGood,
});

final _items = [
  (
    name: 'nugget1.png',
    sound: 'nuggets1',
    isGood: true,
  ),
  (
    name: 'nugget2.png',
    sound: 'nuggets2',
    isGood: true,
  ),
  //(
  //  name: 'guinness',
  //  sound: 'drink.wav',
  //  isGood: true,
  //),
  //(
  (
    name: 'rappare.png',
    sound: 'rappare',
    isGood: false,
  ),
  (
    name: 'emma.png',
    sound: 'emma_loser',
    isGood: true,
  ),
  //(
  //  name: 'whiskey',
  //  sound: 'whiskey.wav',
  //  isGood: false,
  //),
  //(
  //  name: 'jimmy',
  //  sound: 'jimmy.wav',
  //  isGood: false,
  //),
  (
    name: 'donkey.png',
    sound: 'donkey',
    isGood: false,
  ),
];
