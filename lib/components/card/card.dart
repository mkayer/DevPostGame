import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'pile.dart';
import '../ui/utility_helpers.dart';

//----------------------------------------------------------------
//------------------------------TYPE OF PLASTIC: from suit----------------------------------
//----------------------------------------------------------------

@immutable
class PlasticTriangle {
  factory PlasticTriangle.fromInt(int index) {
    assert(
      index >= 0 && index <= 7,
      'index is outside of the bounds of what a card can be',
    );
    return _singletons[index];
  }

  PlasticTriangle._(this.typeindex, this.typelabel, this.buffvalue, this.bufflabel, double x, double y)
      : cardface = triangleFinder('card_faces.png' , x, y);

  final int typeindex;
  final String typelabel;
  final int buffvalue;
  final String bufflabel;
  final Sprite cardface;

  static final List<PlasticTriangle> _singletons = [
    PlasticTriangle._(0, '△1', 5, 'Carcinogen', 0, 0),
    PlasticTriangle._(1, '△2', 15, 'Physical DMG', 870, 0),
    PlasticTriangle._(2, '△3', 20, 'Toxicity + immunity disruptor', (870*2), 0),
    PlasticTriangle._(3, '△4', 5, 'Physical DMG', (870*3), 0),
    PlasticTriangle._(4, '△5', 2, 'Physical DMG', 0, 1080),
    PlasticTriangle._(5, '△6', 15, 'Carcinogen', 870, 1080),
    PlasticTriangle._(6, '△7', 25, 'Endocrine Disruptor', (870*2), 1080),
    PlasticTriangle._(7, '⠶mp', 500, 'One Hit KO', (870*3), 1080),
  ];
}

//----------------------------------------------------------------
//------------------------------BASE DMG: from rank----------------------------------
//----------------------------------------------------------------

@immutable
class CardRank {
  factory CardRank.fromInt(int index) {
    assert(
      index >= 0 && index <= 3,
      'hello rank is out of bounds check class CardRank in card dot dart',
    );
    return _singletons[index];
  }

  const CardRank._(
    this.rankindex,
    this.dmgrange,
    this.label,
  ); 

  final int rankindex;
  final String dmgrange;
  final String label;

  static final List<CardRank> _singletons = [
    const CardRank._(0, '3 to 5', 'weak',),
    const CardRank._(1, '6 to 9', 'mid', ),
    const CardRank._(2, '10 to 15', 'strong',),
    const CardRank._(3, '20 to 30', 'KO',),
  ];
}

//----------------------------------------------------------------
//------------------------------CARD----------------------------------
//----------------------------------------------------------------

class Card extends PositionComponent with DragCallbacks {
  
  //when creating a card, base dmg should be chosen using dart:math random
  //and the limits of random should be chosen based on card type
  Card(int cardType, int baseDmg) 
      : triangle = PlasticTriangle.fromInt(cardType),
        rank = CardRank.fromInt(baseDmg),
        _faceUp = false,
        super(size: cardSize);

  //by default, the card is generated face down
  //to get face up, call method flip() or Card.flip() on the instance
  //example Card egcard= Card(4,5) this is LDPE with base dmg 4
  //to get it face up, do egcard.flip()
  final CardRank rank;
  final PlasticTriangle triangle;
  Pile? pile;
  bool _faceUp;
  bool get isFaceUp => _faceUp;
  void flip() => _faceUp = !_faceUp;

  @override
  String toString() => rank.label + triangle.typelabel + triangle.bufflabel ; // e.g. "10♦" or "mid△5Physical DMG +2"

  @override
  void onDragStart(DragStartEvent event) {
    if (pile?.canMoveCard(this) ?? false) {
      super.onDragStart(event);
      priority = 100;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragged) {
      return;
    }
    final delta = event.localDelta;
    position.add(delta);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDragged) {
      return;
    }
    super.onDragEnd(event);
    final dropPiles = parent!
        .componentsAtPoint(position + size / 2)
        .whereType<Pile>()
        .toList();
    if (dropPiles.isNotEmpty) {
      if (dropPiles.first.canAcceptCard(this)) {
        pile!.removeCard(this);
        dropPiles.first.acquireCard(this);
        return;
      }
    }
    pile!.returnCard(this);
  }


  @override
  void render(Canvas canvas) {
    if (_faceUp) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }
  }

  static final Sprite cardBackSprite = Sprite(
    Flame.images.fromCache('card_back.png'),
  ); //sprite for backface of cards

  void _renderBack(Canvas canvas) {
    cardBackSprite.render(canvas, position: size / 2, size: cardSize, anchor: Anchor.center);
  }

  void _renderFront(Canvas canvas) {
    triangle.cardface.render(canvas, position: size / 2, size: cardSize, anchor: Anchor.center);
  }

  void _drawSprite(
    Canvas canvas,
    Sprite sprite,
    double relativeX,
    double relativeY, {
    double scale = 1,
  }) {
    sprite.render(
      canvas,
      position: Vector2(relativeX * size.x, relativeY * size.y),
      anchor: Anchor.center,
      size: sprite.srcSize.scaled(scale),
    );
  }

}