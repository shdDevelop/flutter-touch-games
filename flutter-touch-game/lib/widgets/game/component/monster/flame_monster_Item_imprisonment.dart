import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

import 'buff/flame_debuff_pasitive_imprisonment.dart';
import 'flame_monster.dart';
import 'skills/flame_skill_positive_poison.dart';

//imprisonment 原地束缚
class ImprisonmentItemMonster extends Monster {
  ImprisonmentItemMonster({this.game, ItemRare monsterRare})
      : super(game: game) {
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
  //给所有的飞行物上束缚buff 所有的随机聚集
  @override
  void onHitEffect() async {
    await game.audioplayers.shield();
    Offset curRndOffset;
    game.flies.where((monster)=>monster.isItem == false).forEach((monster) {
      monster.addSkillOrBuff(GameSkillDebuffImprisonment(game, monster,
          skillConditon: () => monster.isItem == false, duration: 3)); //增加新的技能
      if (curRndOffset != null) {
        monster.flyRect = Rect.fromLTWH(curRndOffset.dx, curRndOffset.dy,
            monster.flyRect.width, monster.flyRect.height);
      } else {
        curRndOffset = new Offset(monster.flyRect.left, monster.flyRect.top);
      }
    });
  }
}
