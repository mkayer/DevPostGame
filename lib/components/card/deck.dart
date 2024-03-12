import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'card.dart';
import 'waste.dart';
import 'pile.dart';
import '../ui/utility_helpers.dart';


class Deck extends PositionComponent with TapCallbacks implements Pile {

  Deck({super.position}) : super(size: cardSize);

  /// Which cards are currently placed onto this pile. The first card in the
  /// list is at the bottom, the last card is on top.
  final List<Card> _cards = [];

//----------------------------------------------------------------
//------------------------------pile methods----------------------------------
//----------------------------------------------------------------

  @override
  bool canMoveCard(Card card) => false;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) => throw StateError('cannot remove cards in deck');

  @override
  void returnCard(Card card) => throw StateError('cannot remove cards in deck');

  @override
  void acquireCard(Card card) {
    assert(
      !card.isFaceUp,
      'card should be face down in deck class'
      );
    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

//----------------------------------------------------------------
//------------------------------On tap event----------------------------------
//----------------------------------------------------------------

  @override
  void onTapUp(TapUpEvent event) {
    //this wont return null because parent is battle scene
    //and first child of type Waste in parent "battle scene" is waste pile
    final wastePile = parent!.firstChild<Waste>()!; 

    //if there are no cards, then refill deck from waste cards
    if (_cards.isEmpty) {
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } else {  
      for (var i = 0; i < 3; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }
      }
    }
  }

  
//----------------------------------------------------------------
//------------------------------Render method----------------------------------
//----------------------------------------------------------------


  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x883F5B5D);
  static final cardRRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    Radius.circular(cardRadius),
  );

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(cardRRect, _borderPaint);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      cardWidth * 0.3,
      _circlePaint,
    );
  }
}