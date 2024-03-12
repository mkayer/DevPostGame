import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:mygamejanus/components/ui/utility_helpers.dart';

class Cutton extends PositionComponent with TapCallbacks {
  Cutton (
    String buttonText,
    void Function() buttonAction,
    {
    super.anchor = Anchor.center,
    super.position,
  }) :  text = buttonText, action = buttonAction, super(size: buttonSize);

  final String text;
  final void Function() action;

  final _bgPaint = Paint()
  ..color = const Color.fromARGB(255, 160, 152, 79);
  final _borderPaint = Paint()
  ..color = const Color.fromARGB(255, 104, 80, 48)
  ..style = PaintingStyle.stroke
  ..strokeWidth = buttonBorderWidth;
  final _rrect = RRect.fromLTRBR(0, 0, buttonSize.x, buttonSize.y, Radius.circular(buttonSize.y*0.1));

  late final _textspan = TextSpan(
    text: text,
    style: TextStyle(
      color: const Color.fromARGB(255, 255, 255, 255),
      fontSize: buttonFontSize,
    ),
  );
  late final _textDrawable = TextPainter(
    text: _textspan,
    textDirection: TextDirection.ltr,
  )
  ..layout(
    minWidth: 0,
    maxWidth: buttonWidth,
  );
  late final _textOffset = Offset(
    (buttonSize.x - _textDrawable.width) / 2, 
    (buttonSize.y - _textDrawable.height) / 2,
    );


  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_rrect, _bgPaint);
    canvas.drawRRect(_rrect, _borderPaint);
    _textDrawable.paint(canvas, _textOffset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    scale = Vector2.all(0.95);
  }

  @override
  void onTapUp(TapUpEvent event) {
    scale = Vector2.all(1.0);
    action();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    scale = Vector2.all(1.0);
  }
  
}
