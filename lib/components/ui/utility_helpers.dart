import 'package:flame/flame.dart';
import 'package:flame/components.dart';

Sprite triangleFinder(String imgsrc, double x, double y) {

  return Sprite(
    Flame.images.fromCache(imgsrc),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(870, 1080),
  );
}


//I can later just multiply these values by the correct block size to get a scene that fits calculations and is within the 16:9 aspect ratio
//block size = Vector2(x_block, y_block)
//where x_block = (width of screen)/16
//and y_block = (height of screen)/9
//so for example if the screen size i want is 1920x1080, then the block's x and y will be 1920/16 = 1080/9 = 120
//then the blocks would be 120x120

double xBlock=120.0;
double yBlock=120.0;
double paddingX = 0;
double paddingY = 0;

//run this in main.dart
void findBlockSize(Vector2 screenSize) {
  var x = screenSize.x/16;
  var y = screenSize.y/9;
  int temp = x.compareTo(y);
  switch (temp) {
    case -1:
      //x is less than y
      paddingY = (y-x)/2;
      xBlock = x;
      yBlock = y-x;
      break;
    case 0:
      //x and y are equal
      xBlock = x;
      yBlock = y;
      break;
    case 1:
      //x is greater than y
      paddingX = (x-y)/2;
      xBlock = x;
      yBlock = x-y;
      break;
    default:
  }
}

//---------------------------------game----------------------------------
var gameWidth = 16.0*xBlock; //1920 = 16 parts of 120
var gameHeight = 9.0*xBlock; //1080 = 9 parts of 120
var gameSize = Vector2(gameWidth, gameHeight); //a grid of 16:9 aspect ratio

//---------------------------------button----------------------------------
var buttonWidth = 2.0*xBlock; //2 blocks long
var buttonHeight = 0.5*xBlock; //half block tall
var buttonSize = Vector2(buttonWidth, buttonHeight);
var buttonBorderWidth = buttonHeight/10;
var buttonFontSize = buttonHeight/2;

//---------------------------------tutorial----------------------------------
var tutorialfontsize = gameHeight/20;
var textboxWidth = gameWidth*0.6;
var textboxHeight = gameHeight/3;
var textboxSize = Vector2(textboxWidth, textboxHeight);

//---------------------------------dialogue----------------------------------
var dialogueboxWidth = 6.0*xBlock;
var dialogueboxHeight = 1.5*xBlock;
var dialogueboxGap = 0.25*xBlock;

//---------------------------------card----------------------------------
double cardGap = 120.0;
double cardWidth = 1.5*xBlock;
double cardHeight = 2.0*xBlock;
double cardRadius = cardWidth/4;
Vector2 cardSize = Vector2(cardWidth, cardHeight);

//-------------------------------card piles--------------------------------
var deckPosition = Vector2(0, cardHeight*3.25);
var wastePosition = Vector2(cardWidth, cardHeight*3.25);
var discardPosition = Vector2(gameWidth/2, cardHeight*3.25);
var playerPosition = Vector2(cardWidth/2, cardHeight*2.25-cardHeight);

//---------------------------------enemyy----------------------------------
double enemyGap = 120.0;
double enemyWidth = 2.0*xBlock;
double enemyHeight = 4.0*xBlock;
Vector2 enemySize = Vector2(enemyWidth, enemyHeight);
