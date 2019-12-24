import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

import 'flame_monster.dart';

//血爆技能
class BloodRushSkillMonster extends Monster {
  BloodRushSkillMonster({this.game, ItemRare monsterRare}) : super(game: game) {
    flyingSprite = new List<Sprite>();
    flyingSprite.add(new Sprite('game/item_bloodrush_skill.png'));
    deadSprite = new Sprite('game/item_bloodrush_skill.png');
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    rare = monsterRare;
  }
  double get speed => game.tileSize * 3.0;
  bool isItem = true; //是否物品
  final LangawGame game;
  //3倍率全攻击
  @override
  void onHitEffect() async {
    Future.delayed(new Duration(milliseconds: 200)).then((_) {
      for (var fly in game.flies) {
       fly.underAttacked(damage: 5 * game.att,color: Colors.red);
        Future.delayed(Duration(milliseconds: 100)).then((_) {
          fly.underAttacked(damage: 10 * game.att,color: Colors.red);
          Future.delayed(Duration(milliseconds: 100)).then((_) {
            fly.onTapDown(damage: 15 * game.att,color: Colors.red); //被点击操作
          });
        });
      }
    });
  }
}
