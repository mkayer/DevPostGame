import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';
import 'package:mygamejanus/components/card/card.dart';
import 'package:mygamejanus/components/card/deck.dart';
import 'package:mygamejanus/components/card/discard.dart';
import 'package:mygamejanus/components/enemy.dart';
import 'package:mygamejanus/components/player.dart';
import 'package:mygamejanus/components/progress.dart';
import 'package:mygamejanus/components/ui/backgrounf.dart';
import 'package:mygamejanus/components/ui/button.dart';
import 'package:mygamejanus/components/ui/utility_helpers.dart';
import 'package:mygamejanus/tr_game.dart';

class TutorialScreen extends PositionComponent with TapCallbacks, HasGameReference<TRGame> {

  TutorialScreen() : super(anchor: Anchor.center, size: gameSize);

  Progress currentProgress = Progress();

  late Player currentPlayer;
  late Cutton skipButton;
  var bgimage = Flame.images.fromCache('battle_bg.png');
  late Background tutorialbg;
  int tutorialStep = 0;  

  TextBoxComponent steptext = TextBoxComponent(
    text: '',
    align: Anchor.center,
    size: textboxSize,
    position: gameSize/2,
    anchor: Anchor.center,
  );
  
  
  var enemlist = [Enemy(0, 0), Enemy(0, 0)];
  late var discard = List.generate(
      enemlist.length,
      (i) => Discard(enemlist[i])
        ..size = cardSize
        ..position = Vector2(discardPosition.x * i, discardPosition.y),
    );
  
  var deck = Deck(position: deckPosition);
  final cards = [Card(3, 0),Card(4, 1),Card(4, 1),Card(3, 0),];
  List<Component> childrentoremove=[];

  @override
  Future<void> onLoad() async {

    currentProgress.fetchAllProgress();
    currentPlayer = Player(currentProgress);
    skipButton = Cutton('skip >', _savetutorialandquit, position: gameSize/15);
    tutorialbg = Background(bgimage);
    cards.forEach(deck.acquireCard);
    steptext.priority=100;

    game.world.add(steptext);
    childrentoremove.add(steptext);
  }

  void _savetutorialandquit() {
    game.world.removeAll(childrentoremove);
    currentProgress.updateBattleProgress(['tutorial']);
    currentProgress.saveAllProgress();
    game.router.pushReplacementNamed('home');
  }

  
  void _renderblankbg(
    Canvas canvas,
    ) {
      final bgPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0);
      final rrect = RRect.fromLTRBR(0, 0, game.canvasSize.x, game.canvasSize.y, Radius.circular(gameSize.y / 2));
      canvas.drawRRect(rrect, bgPaint);
  }

  /*
  void _renderstepbg(
    Canvas canvas,
    ) {
      final bgPaint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0);
      final rrect = RRect.fromLTRBR(0, 0, gameSize.x, gameSize.y, Radius.circular(gameSize.y / 2));
      canvas.drawRRect(rrect, bgPaint);
      Sprite(bgimage).render(canvas, position: gameSize/2, size: gameSize, anchor: Anchor.center);
  }
  */

  final textstyle = TextPaint(
    style: TextStyle(
      fontSize: tutorialfontsize,
      color: const Color.fromARGB(255, 216, 216, 216),
    )
  );

  @override
  void render(Canvas canvas) {
    switch (tutorialStep) {
      case 0:
        //background black, render text : The year is 3048 and you are an assassin
        _renderblankbg(canvas);
        steptext.text = 'The year is 3048 and you are an assassin';
        steptext.textRenderer = textstyle;
        break;
      case 1:
        //background black, render text : Plastic is your obvvious weapon of choice, since there is so much of it and most of it leaches toxins
        //_renderblankbg(canvas);
        steptext.text = 'Plastic is your obvious weapon of choice, since there is so much of it and most of it leaches toxins';
        //steptext.textRenderer = textstyle;
        break;
      case 2:
        //background black, render text : Plastic is your obvvious weapon of choice, since there is so much of it and most of it leaches toxins
        //_renderblankbg(canvas);
        steptext.text = 'but first';
        //steptext.textRenderer = textstyle;
        break;
      case 3:
        //background images fades in, skip button fades in, render text : but first, the tutorial
        game.world.add(tutorialbg);
        childrentoremove.add(tutorialbg);
        game.world.add(skipButton);
        childrentoremove.add(skipButton);
        steptext.text = 'the tutorial';
        //steptext.textRenderer = textstyle;
        break;
      case 4:
        //enemies fade in, render text : they are your targets
        //_renderstepbg(canvas);
        game.world.addAll(enemlist);
        childrentoremove.addAll(enemlist);
        steptext.text = 'they are your targets';
        //steptext.textRenderer = textstyle;
        steptext.position = Vector2(gameHeight/2, gameHeight/3);
        break;
      case 5:
        //deck fades in, render text : this deck is your attacks
        game.world.addAll(cards);
        childrentoremove.addAll(cards);
        game.world.add(deck);
        childrentoremove.add(deck);
        steptext.text = 'this deck is your attacks';
        //steptext.textRenderer = textstyle;
        steptext.position = Vector2(0, gameHeight/3);
        break;
      case 6:
        //discard fades in, render text : this is where you place your attacks
        game.world.addAll(discard);
        childrentoremove.addAll(discard);
        steptext.text = 'this is where you place your attacks';
        //steptext.textRenderer = textstyle;
        steptext.position = Vector2(gameWidth/2, gameHeight*0.9);
        break;
      case 7:
        //player fades in, render text : and finally, this is you
        game.world.add(currentPlayer);
        childrentoremove.add(currentPlayer);
        steptext.text = 'and finally, this is you';
        //steptext.textRenderer = textstyle;
        steptext.position = Vector2(gameWidth/3, gameHeight*0.3);
        break;
      case 8:
        //waste pile animation plays, render text : click on the deck to place cards
        steptext.text = 'click on the deck to place cards';
        //steptext.textRenderer = textstyle;
        steptext.position = gameSize/2;
        break;
      case 9:
        //drag animation plays and simultaneous attack animation plays, render text : drag your chosen attack to play it
        steptext.text = 'drag your chosen attack to play it';
        //steptext.textRenderer = textstyle;
        //steptext.position = gameSize/2;
        break;
      case 10:
        //another drag and attack animation plays as second card from open waste pile is played, render text : only the cards on top can be played
        steptext.text = 'only the cards on top can be played';
        //steptext.textRenderer = textstyle;
        //steptext.position = gameSize/2;
        break;
      case 11:
        //enemy fades out (dies) and discard returns to deck, render text : the cards return once your target dies
        steptext.text = 'the cards return once your target dies';
        //steptext.textRenderer = textstyle;
        //steptext.position = gameSize/2;
        break;
      case 12:
        //idle screen with player standing and waste as is from last step, render text : check the library to get more intel
        steptext.text = 'check the library to get more intel';
        break;
      case 13:
        //return to background black, render text : now, let's begin
        _renderblankbg(canvas);
        steptext.text = 'now, let\'s begin';
        break;
      //when step num turns to 14, mark tutorial as done on player progress and push it to prefs
      //then go to home screen
      default:
      //in case 14 tries to render
        _renderblankbg(canvas);
        break;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    tutorialStep++;
    if (tutorialStep>13){
      _savetutorialandquit();
    }
  }
}