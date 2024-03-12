
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:mygamejanus/components/progress.dart';
import 'package:mygamejanus/components/ui/backgrounf.dart';
import 'package:mygamejanus/tr_game.dart';

class TargetFile extends Component with HasGameReference<TRGame>{

  //  it will hae a background
  // it will check progress and return data about next battle
  //it will use pfps.png
  //have a button that will go to the babttle

  Background targetfilebg = Background(Flame.images.fromCache('targets_file_bg.png'));
  Progress currentProgress = Progress();

  @override
  Future<void> onLoad() async {
    currentProgress.fetchAllProgress();
  }


}