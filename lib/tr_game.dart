import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:mygamejanus/components/screens/library_scene.dart';
import 'package:mygamejanus/components/screens/tutorial_scene.dart';
import 'package:mygamejanus/components/ui/utility_helpers.dart';
import 'components/screens/home_scene.dart';
import 'components/screens/battle_scene.dart';
import 'components/progress.dart';

class TRGame extends FlameGame {

  TRGame(Progress pastprogress) : progress=pastprogress, super(
    camera: CameraComponent.withFixedResolution(width: gameWidth, height: gameHeight),
  );

  Progress progress;

  double get width => size.x;
  double get height => size.y;
  
  late final RouterComponent router;

  @override
  Future<void> onLoad() async {

    //set game to fullscreen
    Flame.device.fullScreen();

    //set game orientation to landscape
    Flame.device.setLandscape();

    //set game size and make it responsive
    camera.viewfinder.position = gameSize/2;
    camera.viewfinder.anchor = Anchor.center;

    //load all required images into cache
    await Flame.images.loadAll([
      //'platic_triangles.png',
      //'card_buffs.png',
      //'button.png',
      //'base_dmg.png',
      'home_bg.png',
      'battle_bg.png',
      'player.png',
      'enemies.png',
      'card_faces.png',
      'card_back.png',
      'target_file_bg.png',
      'library_bg.png',
      'pause_panel.png',
      'you_wom.png',
      'you_lost.png', //loss in the bg
      'story_end.png',
    ]);

    /*
    //get savefile, if any
    Progress progress = Progress();
    progress.fetchAllProgress();
    

    //create a player instance with fetched progress
    Player player=Player(progress);
    */
    
    //check progress and if the list battleCompleted is empty then open tutorial screen, else open home screen
    bool savefile = progress.battlesCompleted.isNotEmpty;
    
    add(
      router = RouterComponent(
        routes: {
          'tutorial':Route(TutorialScreen.new), //if savefile does not exist, then initial route is this
          'home': Route(HomeScreen.new),
          'library':Route(Library.new),
          //settings screen
          //'targets': Route();
          //dialogue screen
          'fight':Route(FightScreen.new)
          //result screen - you won/lost

        },
        initialRoute: savefile?'home':'tutorial',
      ),
    );
  }
}
