import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import '../../tr_game.dart';
import '../player.dart';
import '../enemy.dart';
import '../card/card.dart';
import '../card/deck.dart';
import '../card/waste.dart';
import '../card/discard.dart';
import '../progress.dart';
import '../ui/utility_helpers.dart';

@immutable
class Battles {
  factory Battles.fromInt(int index) {
    assert(
      index >= 0 && index <= 7,
      'invalid SpeciesRank index',
      );
    return _singletons[index];
  }

  final int index;
  final String label;
  final List<Enemy> enemies;

  const Battles._(
    this.index,
    this.label,
    this.enemies
  );

  static final List<Battles> _singletons = [
    Battles._(0, 'tutorial', [Enemy(0,0)]),
    Battles._(1, 'chumps', [Enemy(0, 0), Enemy(0, 0)]),
    Battles._(2, 'before jack', [Enemy(0, 1), Enemy(1, 0)]),
    Battles._(3, 'jack', [Enemy(1, 0), Enemy(0, 0), Enemy(1, 2)]),
    Battles._(4, 'filler episode', [Enemy(1, 0), Enemy(1, 1), Enemy(0, 1)]),
    Battles._(5, 'before smith', [Enemy(1, 1), Enemy(2, 0)]),
    Battles._(6, 'smith', [Enemy(2, 0), Enemy(2, 0), Enemy(2, 2)]),
    Battles._(7, 'albert', [Enemy(3, 2)]),
  ];
}


class FightScreen extends Component with HasGameReference<TRGame> {

  //FightScreen(Player player) : playerComponent = player;
  //final Player playerComponent;
  
  

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {

    //----------------check progress here-----------------------------
    //get savefile, if any
    Progress progress = Progress();
    progress.fetchAllProgress();

    //create a player instance with fetched progress
    Player playerComponent=Player(progress);
    

    //----------------generate deck here-----------------------------
    final deck = Deck()
      ..size = cardSize
      ..position = Vector2(0,200); //Vector2(Card.cardGap, Card.cardGap);
    game.world.add(deck);
    
    final cards = [ 
      for (int element in playerComponent.playerProgress.cardsUnlocked)
        if (element==3)
          Card(element, 0)
        else if (element==0 || element==4)
          Card(element, 1)
        else if (element==1 || element==5 || element==6)
          Card(element, 2)
        else if (element==2 || element==7)
          Card(element, 3) 
    ];
    cards.shuffle();
    game.world.addAll(cards);
    cards.forEach(deck.acquireCard);

    //----------------generate waste pile here-----------------------------
    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardWidth, 200); //Vector2(Card.cardWidth + 2 * Card.cardGap, Card.cardGap);
    game.world.add(waste);

    
    //----------------generate enemies here-----------------------------
    //if there is no completed battle, the length of the list will be zero
    //So battle zero 'tutorial' will be loaded as current battle
    //then we load the list of enemies from the current battle
    //these things can be final because for each level of battle, tr_game will generate a new instance of battle_scene and these things will be built again for each instance
    final currentBattleIndex = playerComponent.playerProgress.battlesCompleted.length;
    final currentBattle = Battles.fromInt(currentBattleIndex); 
    final currentEnemies = currentBattle.enemies;
    for (var i = 0; i < currentEnemies.length; i++) {
      var x = (game.width/2) + i*currentEnemies[i].width; //offset each enemy by width
      var y = 10.0; 
      currentEnemies[i].position = Vector2(x, y);
    }
    game.world.addAll(currentEnemies);

    //----------------generate discard piles for enemies here-----------------------------
    final foundations = List.generate(
      currentEnemies.length,
      (i) => Discard(currentEnemies[i])
        ..size = cardSize
        ..position =
            Vector2((i + 3) * cardWidth, 200),
    );
    game.world.addAll(foundations);

    //could copy card position from here, it might be useful
    //remove this later, it just adds a card to sthe screen to look at
        final cardFront = Card(1, 3)
          ..size = cardSize
          ..position = Vector2(0,400);
        final cardBack = Card(1, 3)
          ..size = cardSize
          ..position = Vector2(180,400);
        addAll([
          cardFront,
          cardBack,
        ]
        );
        cardFront.flip();
        //print(card.toString());
    //removve till here

  }

}