import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:mygamejanus/tr_game.dart';

class DialogueScreen extends Component with TapCallbacks, HasGameReference<TRGame> {

  //this will be very similar to tutorial
  //solid color background
  //then add to render with each tap
  //after last tap mark dialogue completed and move to battle scene
  //no skip button

  //it will also have a list of dialogue material for each battle
  //similar to list of battle data in battle scene


  //render background as solid grey OR solid grey with those same 'table lines' 
  //OR IF POSSIBLE half opacity solid color to make it look more like a conversation between the people on the battle
  //LAST OPTION WILL REQUIRE BATTLE SCENE TO BE LOADED BEFORE DIALOGUE SO ONLY TRY IF THERE IS TIME
  
}