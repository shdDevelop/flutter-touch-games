import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

import 'flame_monster.dart';
import 'skills/flame_skill_positive_poison.dart';

class PoisonItemMonster extends Monster {
  PoisonItemMonster({this.game, ItemRare monsterRare}) : super(game: game) {
    flyingSprite = new List<Sprite>();
    flyingSprite.add(new Sprite('game/item_poison.png'));
    deadSprite = new Sprite('game/item_poison.png');
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    rare = monsterRare;
  }
  double get speed => game.tileSize * 4;
  final LangawGame game;
  bool hasCallout = false; //是否具有超时属性
  bool isItem = true; //是否物品
  //全灭特效
  @override
  void onHitEffect() async {
    await game.audioplayers.poison();
    game.userMonster?.addSkillOrBuff(SkillPoison(game, null,duration: 20)); //增加新的技能
  }
}
