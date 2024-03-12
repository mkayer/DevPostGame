import 'dart:ui';
import 'package:flame/components.dart';
import 'package:mygamejanus/components/ui/utility_helpers.dart';

class Background extends PositionComponent {
  //Background(this.backgroundSprite):super(size: );
  Background(this.backgroundImage) : backgroundSprite = Sprite(backgroundImage);

  final Image backgroundImage;
  final Sprite backgroundSprite;
  final bgPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0);
      final rrect = Rect.fromLTRB(0, 0, gameSize.x, gameSize.y);
      

  @override
  void render(Canvas canvas) {
    //canvas.drawRect(rrect, bgPaint);
    backgroundSprite.render(canvas, position: gameSize / 2, size: gameSize, anchor: Anchor.center);
  }
}