import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:mygamejanus/components/card/card.dart';
import 'package:mygamejanus/components/enemy.dart';
import 'package:mygamejanus/components/progress.dart';
import 'package:mygamejanus/components/ui/backgrounf.dart';
import 'package:mygamejanus/components/ui/button.dart';
import 'package:mygamejanus/components/ui/utility_helpers.dart';
import 'package:mygamejanus/tr_game.dart';

class Library extends Component with HasGameReference<TRGame> {

  Progress currentProgress = Progress();
  Background librarybg = Background(Flame.images.fromCache('library_bg.png'));
  late List<Card> cards;
  late List<Enemy> enemies;
  late Cutton backbutton;
  late Cutton cardlibrary;
  late Cutton enemylibrary;
  bool iscardlib=true;
  List<Component> childrentoremove = [];

  @override 
  Future<void> onLoad() async {
    currentProgress.fetchAllProgress();
    generateCards();
    generateEnemies();
    backbutton = Cutton('< back', backaction, position: gameSize/14);
    cardlibrary = Cutton('Card Library', toggleLibrary, position: Vector2(gameWidth*0.4,gameHeight*0.15));
    enemylibrary = Cutton('Enemy Library', toggleLibrary, position: Vector2(gameWidth*0.6,gameHeight*0.15));
    game.world.add(librarybg);
    game.world.addAll(cards);
    game.world.addAll([backbutton, cardlibrary,enemylibrary]);
    childrentoremove.add(librarybg);
    childrentoremove.addAll(cards);
    childrentoremove.addAll([backbutton, cardlibrary,enemylibrary]);
    
  }


  void backaction() {
    print('go back');
    game.world.removeAll(childrentoremove);
    game.router.pushReplacementNamed('home');
  }

  void toggleLibrary() {
    if (iscardlib) {
      //check if an any enemies are in world
      //if yes then remove them
      for (var element in enemies) {
        if (game.world.contains(element)){
          game.world.remove(element);
          childrentoremove.remove(element);
        }
      }
      //now add the cards to the world
      game.world.addAll(cards);
      childrentoremove.addAll(cards);
    } else {
      //check if an any cards are in world
      //if yes then remove them
      for (var element in cards) {
        if (game.world.contains(element)){
          game.world.remove(element);
          childrentoremove.remove(element);
        }
      }
      //now add the cards to the world
      game.world.addAll(enemies);
      childrentoremove.addAll(enemies);
    }
  }

  void generateCards() {
    cards = [
      Card(0, 1),
      Card(1, 2),
      Card(2, 3),
      Card(3, 0),
      Card(4, 1),
      Card(5, 2),
      Card(6, 2),
      Card(7, 3),
    ];
    for (var element in cards) {
      if (currentProgress.cardsUnlocked.contains(element.triangle.typeindex)){
        element.flip();
      }
    }

    for (var i = 0; i < 4; i++) {
      var x = (gameWidth/9)*(i+2);
      cards[i].position = Vector2(x, gameHeight/3);
    }
    for (var i = 4; i < 8; i++) {
      var x = (gameWidth/9)*(i-2);
      cards[i].position = Vector2(x, gameHeight*2/3);
    }
  }

  void generateEnemies() {
    enemies = [
      Enemy(0, 0),
      Enemy(1, 0),
      Enemy(2, 0),
      Enemy(3, 0),
    ];
    for (var i = 0; i < 4; i++) {
      var x = (gameWidth/9)*(i+2);
      enemies[i].position = Vector2(x, gameHeight/2);
    }
  }
}
