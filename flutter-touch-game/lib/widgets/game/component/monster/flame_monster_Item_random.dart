import 'dart:math';
import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

import 'buff/flame_buff_pasitive_speed_enhence.dart';
import 'buff/flame_debuff_pasitive.dart';
import 'buff/flame_debuff_pasitive_bleeding.dart';
import 'buff/flame_debuff_pasitive_imprisonment.dart';
import 'buff/flame_debuff_pasitive_silence.dart';
import 'buff/flame_debuff_pasitive_sleep.dart';
import 'flame_monster.dart';
import 'skills/flame_skill.dart';

class RandomMonster extends Monster {
  RandomMonster({this.game, ItemRare monsterRare}) : super(game: game) {
    flyingSprite = new List<Sprite>();
    flyingSprite.add(new Sprite('game/item_random.png'));
    deadSprite = new Sprite('game/item_random.png');
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    rare = monsterRare;
  }
  double get speed => game.tileSize * 4;
  bool isItem = true; //是否物品
  final LangawGame game;
  //给所有的monster生成一个随机buff
  @override
  void onHitEffect() async {
    var skillIndexRnd = game.rnd.nextInt(5);
    game.flies.where((monster)=>monster.isItem == false).forEach((monster) {
      if (monster.isItem) return;
      var debuffSkill = randomDebuff(
          skillIndexRnd, monster, (skill) => monster.isItem == false);
      if (debuffSkill != null) {
        monster.addSkillOrBuff(debuffSkill); //增加新的技能
      }
    });
  }

  GameSkill randomDebuff(int rnd, Monster monster, Function condition) {
    try {
      switch (rnd) {
        case 0:
          return GameSkillDebuffBleeding(game, monster,
              skillConditon: condition);
          break;
        case 1:
          return GameSkillDebuffImprisonment(game, monster,
              skillConditon: condition);
          break;
        case 2:
          return GameSkillDebuffSilence(game, monster,
              skillConditon: condition);
          break;
        case 3:
          return GameSkillDebuffSleep(game, monster, skillConditon: condition);
          break;
        case 4:
        default:
          return GameSkillBuffSpeedEnhence(game, monster,
              skillConditon: condition, speedEnhenceP: -0.7);
          break;
      }
    } catch (ex) {
      print('$ex');
    }
    return null;
  }
}
