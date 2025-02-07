import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:malins_nuggets/components/item.dart';
import 'package:malins_nuggets/game.dart';

enum PlayerState { idle, run }

class PlayerComponent extends SpriteAnimationGroupComponent
    with DragCallbacks, HasGameReference<MalinsNuggetsGame> {
  PlayerComponent()
      : super(
          size: Vector2.all(400),
          anchor: Anchor.bottomCenter,
        );

  late final Head head;

  @override
  Future<void> onLoad() async {
    final idleAnimation = await SpriteAnimation.load(
      'donkey_idle.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 100,
        textureSize: Vector2.all(700),
      ),
    );
    final runAnimation = await SpriteAnimation.load(
      'donkey_run.png',
      SpriteAnimationData.sequenced(
        amount: 15,
        amountPerRow: 5,
        stepTime: 0.05,
        textureSize: Vector2.all(700),
      ),
    );
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
    };
    current = PlayerState.idle;
    position.y = game.size.y / 2;
    add(head = Head());
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    current = PlayerState.run;
    head.startMoving();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    final dx = event.localDelta.x * scale.x.sign;
    final viewportWidth = game.size.x;
    game.background.startMoving(dx.sign.toInt());

    x = (x + dx).clamp(
      -viewportWidth / 2 + size.x / 2,
      viewportWidth / 2 - size.x / 2,
    );
    if (isFlippedHorizontally && dx < 0) {
      flipHorizontally();
    } else if (!isFlippedHorizontally && dx > 0) {
      flipHorizontally();
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    game.background.stopMoving();
    current = PlayerState.idle;
    head.stopMoving();
  }
}

final _headPosition = Vector2(100, 170);
final _headSize = Vector2(215, 275);

class Head extends PositionComponent
    with CollisionCallbacks, HasGameReference<MalinsNuggetsGame> {
  Head()
      : super(
          position: _headPosition,
          size: Vector2.all(215),
          anchor: Anchor.center,
        );

  late final SpriteComponent head;
  late final SpriteComponent headNose;
  late final CircleHitbox hitbox;
  MoveByEffect? headEffect;

  void startMoving() {
    hitbox.collisionType = CollisionType.inactive;
    headNose.add(
      OpacityEffect.to(
        0.0,
        EffectController(duration: 0.5),
      ),
    );
    headEffect = MoveByEffect(
      Vector2(0, -50),
      EffectController(duration: 0.2, alternate: true, infinite: true),
    );
    add(headEffect!);
    add(
      RotateEffect.to(0, EffectController(duration: 0.5)),
    );
  }

  void stopMoving() {
    hitbox.collisionType = CollisionType.active;
    if (headEffect != null) {
      headEffect?.controller.setToEnd();
      remove(headEffect!);
      position = _headPosition;
    }
    add(
      RotateEffect.to(tau / 2, EffectController(duration: 0.5)),
    );
    headNose.add(
      OpacityEffect.to(
        1.0,
        EffectController(duration: 0.5),
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    flipHorizontally();
    final headSprite = await Sprite.load('head.png');
    final headNoseSprite = await Sprite.load('head_nose.png');
    head = SpriteComponent(
      sprite: headSprite,
      size: _headSize,
    );
    headNose = SpriteComponent(
      sprite: headNoseSprite,
      size: _headSize,
    )..paint.color = Colors.transparent;
    hitbox = CircleHitbox(position: Vector2(80, 110), radius: 35);
    addAll([head, headNose, hitbox]);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Item && !other.isTaken) {
      other.isTaken = true;
      game.score += other.entry.isGood ? 1 : -1;
      other.removeEffect();
      game.audioManager.play(other.entry.sound);
    }
  }
}
