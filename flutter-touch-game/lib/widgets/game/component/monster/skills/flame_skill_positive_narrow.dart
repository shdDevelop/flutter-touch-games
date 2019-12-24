import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../../flame_Langaw_Game.dart';
import 'flame_skill.dart';

//形状变小技能
class SkillNarrow extends GameSkill {
 final LangawGame game;
  final Monster monster;
  double skillCD = 12; //10秒执行一次
  GameActiveType activeType=GameActiveType.Positive;
  int skillDuration = 3; //2持续2秒 未-1代表永久执行
  SkillNarrow(this.game,this.monster, {Function skillConditon})
      : super(game,monster, skillConditon: skillConditon) {
  
  }

  ///10秒执行一次，是否执行RunshSKill
  @override
  bool checkSkillAvaiable(t) {
    return super.checkSkillAvaiable(t);
  }

  @override
  void onSkillExecing() {
    monster.flyRect=monster.flyRect.inflate(-10.0);
  }

  @override
  void onSkillExeced() {
   monster.flyRect=monster.flyRect.inflate(10.0);
  }
}
