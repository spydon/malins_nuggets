import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class RestartButton extends ButtonComponent {
  RestartButton({super.onPressed, super.position})
      : super(
          button: ButtonBackground(Colors.white),
          buttonDown: ButtonBackground(Colors.orangeAccent),
          children: [
            TextComponent(
              text: 'Restart',
              position: Vector2(60, 20),
              anchor: Anchor.center,
            ),
          ],
          size: Vector2(120, 40),
          anchor: Anchor.center,
        );
}

class ButtonBackground extends PositionComponent
    with HasAncestor<RestartButton> {
  ButtonBackground(Color color) {
    _paint.color = color;
  }

  @override
  void onMount() {
    super.onMount();
    size = ancestor.size;
  }

  late final _background = RRect.fromRectAndRadius(
    size.toRect(),
    const Radius.circular(5),
  );
  final _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_background, _paint);
  }
}
