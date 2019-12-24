import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/buff/flame_debuff_pasitive_poison.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';

import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../../flame_Langaw_Game.dart';
import 'flame_skill.dart';

//上毒技能，给与对方一个毒buff,主动，该技能可能monster也能执行，主动行用于 点击的是否触发buff，或者monster执行的技能
class SkillPoison extends GameSkill {
  final LangawGame game;
  final Monster monster;
  double skillCD = 1; //10秒执行一次
  double unavaiableAfterCD = 30; //n秒后失效
  GameActiveMode activeMode=GameActiveMode.Touch;//手动触发
  GameBuffType gameBuffType = GameBuffType.buff_poison;
  SkillPoison(this.game, this.monster,
      {Function skillConditon, double duration, double chance})
      : super(game, monster, skillConditon: skillConditon) {
    if (duration != null) {
      unavaiableAfterCD = duration;
    }
    if (chance != null) {
      probabability = chance;
    }
  }

  ///10秒执行一次，是否执行RunshSKill 后续检查为何无法较慢执行
  @override
  bool checkSkillAvaiable(t) {
    return super.checkSkillAvaiable(t);
  }

  @override
  void onSkillExecing() {}
  //自动型上毒状态（monster定时发动）几率
  @override
  void onSkillExeced() {
    // game.addSkillOrBuff(new GameSkillDebuffPoison(game, null));
  }

  //给对方上毒状态（用户手动触发发动）几率
  @override
  void userActiveSkill(Monster monster) {
    monster.addSkillOrBuff(new GameSkillDebuffPoison(game, monster));
  }

}
