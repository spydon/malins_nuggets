import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:malins_nuggets/game.dart';

class Background extends ParallaxComponent<MalinsNuggetsGame> {
  Background(this.velocity);

  final Vector2 velocity;

  void startMoving(int direction) {
    velocity.x = game.speed * 10 * direction;
  }

  void stopMoving() {
    velocity.x = 0;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    height = 200;

    parallax = await game.loadParallax(
      [
        ParallaxImageData('parallax/5.png'),
        ParallaxImageData('parallax/4.png'),
        ParallaxImageData('parallax/3.png'),
        ParallaxImageData('parallax/2.png'),
        ParallaxImageData('parallax/0.png'),
      ],
      baseVelocity: velocity,
      velocityMultiplierDelta: Vector2.all(2),
      fill: LayerFill.width,
    );
  }
}
