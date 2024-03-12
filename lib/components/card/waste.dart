import 'package:flame/components.dart';
import 'card.dart';
import 'pile.dart';
import '../ui/utility_helpers.dart';


class Waste extends PositionComponent implements Pile {

  Waste({super.position}) : super(size: cardSize);

  //cards that are currenty on waste pile
  //last in first out 
  final List<Card> _cards = []; 

  //offset to spread out waste pile top three
  final Vector2 _fanOffset = Vector2(cardWidth * 0.2, 0);

//----------------------------------------------------------------
//------------------------------pile methods----------------------------------
//----------------------------------------------------------------

  @override
  bool canMoveCard(Card card) => _cards.isNotEmpty && card == _cards.last;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
    _fanOutTopCards();
  }

  @override
  void returnCard(Card card) {
    card.priority = _cards.indexOf(card);
    _fanOutTopCards();
  }

  @override
  void acquireCard(Card card) {
    assert(
      card.isFaceUp,
      'card should be face up in waste class'
      );
    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    _fanOutTopCards();
  }

//----------------------------------------------------------------
//------------------------------waste specific----------------------------------
//----------------------------------------------------------------

  List<Card> removeAllCards() {
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }

  void _fanOutTopCards() {
    final n = _cards.length;

    //set position of all cards in waste pile to the position of waste pile
    for (var i = 0; i < n; i++) {
      _cards[i].position = position;
    }

    //if there are only two cards in waste pile, add an offset to the top card
    if (n == 2) {
      _cards[1].position.add(_fanOffset);
    } 
    //else if there are three or more cards in the waste pile
    //then add twice the amount of offset to the top card
    //and add one offset to the card under top card
    else if (n >= 3) {
      _cards[n - 2].position.add(_fanOffset);
      _cards[n - 1].position.addScaled(_fanOffset, 2);
    }
  }
}