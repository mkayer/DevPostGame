import 'dart:ui';
import 'dart:math';
import 'package:flame/components.dart';
import 'card.dart';
import 'pile.dart';
import '../enemy.dart';
import '../ui/utility_helpers.dart';

class Discard extends PositionComponent implements Pile {

  Discard( 
    Enemy enemy,
    {super.position}
    ) : attachedEnemy = enemy,
    super(size: cardSize);

  final List<Card> _cards = [];
  final Enemy attachedEnemy;

//----------------------------------------------------------------
//------------------------------pile methods----------------------------------
//----------------------------------------------------------------

  @override
  bool canMoveCard(Card card) => false;

  @override
  bool canAcceptCard(Card card)  => true; //can accept only if the attached enemy is in front

  @override
  void removeCard(Card card)  => throw StateError('cannot move cards in discard');

  @override
  void returnCard(Card card)  => throw StateError('cannot move cards in discard');

  @override
  void acquireCard(Card card) {
    assert(
      card.isFaceUp,
      'card should be face up in discard pile'
      );
    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
      //card.rank.dmgrange is a string with range of dmg specified like "3 to 5"
      //split(' ') returns a list of strings by splitting at every space in "3 to 5"
      //so card.rank.dmgrange.split(' ') = ['3','to','5']
      //save this min max and use random to generate a basedmg from that range
    int dmgmin = int.parse(card.rank.dmgrange.split(' ')[0]);
    int dmgmax = int.parse(card.rank.dmgrange.split(' ')[2]);
    int basedmg=Random().nextInt(dmgmax - dmgmin) + dmgmin;
    attachedEnemy.enemyHit(basedmg, card.triangle.bufflabel, card.triangle.buffvalue);
  }

//----------------------------------------------------------------
//------------------------------ on attached enemy dead----------------------------------
//----------------------------------------------------------------

//use function from deck that takes cards from waste pile if the deck is empty
//to pass discard stack back to deck when attached enemy dies

//----------------------------------------------------------------
//------------------------------render methods----------------------------------
//----------------------------------------------------------------

  static final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color.fromARGB(255, 68, 68, 68);
  static final Paint backgroundPaint = Paint()
    ..color = const Color.fromARGB(255, 19, 19, 19);
  static final cardRRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    Radius.circular(cardRadius),
  );
  
  @override
  void render(Canvas canvas) {
    canvas.drawRRect(cardRRect, _borderPaint);
  }
}