import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:mygamejanus/components/ui/utility_helpers.dart';

//----------------------------------------------------------------
//------------------------------Species Class----------------------------------
//----------------------------------------------------------------

@immutable
class Species {
  factory Species.fromInt(int index) {
    assert(
      index >= 0 && index <= 3,
      'invalid species index',
    );
    return _singletons[index];
  }

  Species._(
    this.index,
    this.label, 
    this.buff,
    this.spriteY
  ) : super(); //need to initialise with super(size) or something

  final int index;
  final String label;
  final String buff;
  final double spriteY;

  static final List<Species> _singletons = [
    Species._(0, 'random guy', 'None',0),
    Species._(1, 'exoskeleton guy', 'Physical DMG', (480*1)),
    Species._(2, 'tumor guy', 'Carcinogen', (480*2)),
    Species._(3, 'no hormone guy', 'Endocrine Disruptor', (480*3)),
  ];
}

//----------------------------------------------------------------
//------------------------------SpeciesRank Class----------------------------------
//----------------------------------------------------------------


@immutable
class SpeciesRank {
  factory SpeciesRank.fromInt(int index) {
    assert(
      index >= 0 && index <= 2,
      'invalid SpeciesRank index',
    );
    return _singletons[index];
  }

  SpeciesRank._(
    this.index,
    this.label,
    this.hp,
    this.attackdmg,
  ) : super(); //need to initialise with super(size) or something

  final int index;
  final String label;
  final double hp;
  final double attackdmg;
  //final double spriteY; specify x value to retrieve enemy sprite from spritesheet

  static final List<SpeciesRank> _singletons = [
    SpeciesRank._(0, 'normal hench', 50.0, 5.0,),
    SpeciesRank._(1, 'tough hench', 100.0, 10.0,),
    SpeciesRank._(2, 'BOSS', 500.0, 50.0,),
  ];
}

//----------------------------------------------------------------
//------------------------------Enemy Class----------------------------------
//----------------------------------------------------------------

class Enemy extends PositionComponent {

  //make enemy deal dmg to player, if there is time. it will also make the battle turn based instead of instant dmg on card placement. 
  

  Enemy(int intSpecies, int intRank) 
      : species = Species.fromInt(intSpecies),
        rank = SpeciesRank.fromInt(intRank),
        enemybuff = Species.fromInt(intRank).buff,
        hp = SpeciesRank.fromInt(intRank).hp,
        super(size: enemySize);

  final Species species;
  final SpeciesRank rank;
  final String enemybuff;
  double hp;

  void enemyHit(int dmgTaken, String cardbuff, int buffDmg) {
    double currentHp = hp;
    currentHp -= dmgTaken;
    if (cardbuff == enemybuff) {
      //add another if condition here
      //that if check whether the card buff is immunity disruptor/toxicity
      //and will add a permanent dmg booster in that case
      //maybe make a function that will keep reducing hp after it is called
      currentHp -= buffDmg;
    }
    hp = currentHp;
    //call method to re-render enemy's hp bar and to play an animation
    
    //if enemy is boss, call enemy's attack
  }

  @override
  void render(Canvas canvas){
    Sprite enemyIdle = triangleFinder('enemies.png', 0, species.spriteY);
    Sprite enemyHit = triangleFinder('enemies.png', 240, species.spriteY);
    Sprite enemyAttack = triangleFinder('enemies.png', 480, species.spriteY);
    enemyIdle.render(canvas, position: size / 2, size: enemySize, anchor: Anchor.center);
  }
}