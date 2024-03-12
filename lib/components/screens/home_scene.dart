import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:mygamejanus/components/player.dart';
import 'package:mygamejanus/components/progress.dart';
import 'package:mygamejanus/components/ui/backgrounf.dart';
import 'package:mygamejanus/components/ui/utility_helpers.dart';
import 'package:mygamejanus/tr_game.dart';
import '../ui/button.dart';



class HomeScreen extends Component with HasGameReference<TRGame> {

  late Progress currentProgress;
  Background homeBg = Background(Flame.images.fromCache('home_bg.png'));
  late Cutton playButton;
  late Cutton libraryButton;
  late Cutton settingsButton;
  List<Component> childrentoremove=[];

  @override
  Future<void> onLoad() async {
    currentProgress = game.progress;
    currentProgress.fetchAllProgress();
    var text = (currentProgress.battlesCompleted.length > 1) ? 'c o n t i n u e' : 's t a r t'; 
    playButton = Cutton(text, playaction, position: Vector2(gameWidth/2,gameHeight*0.35));
    libraryButton = Cutton('l i b r a r y', libraryaction, position: Vector2(gameWidth/2,gameHeight*0.45));
    settingsButton = Cutton('s e t t i n g s', settingsaction, position: Vector2(gameWidth/2,gameHeight*0.55));
    game.world.addAll([homeBg, playButton, libraryButton, settingsButton]);
    childrentoremove.addAll([homeBg, playButton, libraryButton, settingsButton]);
  }

  void playaction() {
    game.world.removeAll(childrentoremove);
    game.router.pushNamed('targets');
  }

  void libraryaction() {
    game.world.removeAll(childrentoremove);
    game.router.pushNamed('library');
  }

  void settingsaction() {
    game.world.removeAll(childrentoremove);
    game.router.pushNamed('settings');
  }

    //IN THE END DO ADDALL for background and all buttons
    //make three buttons - one for start/continue mission, one for library, one for settings
    //give them position a bit to the right of the screen
    //and then put them here to add all buttons to world
    // use currentPlayer.playerProgress.battlesCompleted; to pick "start" or "continue" text for first button
    // use currentPlayer.playerProgress.dialoguesCompleted; to see if dialogue for current battle is completed or not
    //if not completed, then first go to dialogue
    //if completed, then go directly to battle

}
