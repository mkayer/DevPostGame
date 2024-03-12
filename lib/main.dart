import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:mygamejanus/components/progress.dart';
import 'tr_game.dart';
import 'components/ui/utility_helpers.dart';

void main() {
  
  //get savefile, if any
  Progress progress = Progress();
  progress.fetchAllProgress();
  //findBlockSize(screenSize);

  final game = TRGame(progress);
  runApp(GameWidget(game: game));

  //game size will be 1920 x 1080 ie 16:9 aspect ratio
  //this has been set in trgame

  //should be in landscape orientation
  //should load any existing save file and pass it to trgame
}