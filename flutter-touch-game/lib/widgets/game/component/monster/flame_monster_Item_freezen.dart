import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

import 'flame_monster.dart';
//减缓速度
class FreezenMonster extends Monster {
  FreezenMonster({this.game,ItemRare monsterRare}):super(game:game)
  {
   
    flyingSprite=new List<Sprite>();
    flyingSprite.add(new Sprite('game/item_freezen.png'));
    deadSprite=new Sprite('game/item_freezen.png');
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);   
    rare=monsterRare;
     
   }
  double get speed => game.tileSize * 4; 
  final LangawGame game;
  bool isItem = true; //是否物品
  bool hasCallout = false; //是否具有超时属性
  //全灭特效
  @override
  void onHitEffect(){
 
  game.audioplayers.freezen();
  game.monsterSpeedPercent=-0.8;//减速80%
   //10秒后恢复
   Future.delayed(new Duration(seconds: 10)).then((_) {
       game.monsterSpeedPercent=0;
     });
  }
}
