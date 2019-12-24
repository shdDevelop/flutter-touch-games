import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';

import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../../flame_Langaw_Game.dart';

//dubuff 被动性
class GameSkillDebuff extends GameSkill {
  final LangawGame game;
  final Monster monster;
  double skillCD = 2; //10秒执行一次
  double unavaiableAfterCD =20; //n秒后失效
  int avaiableTimes = 20; //可执行的次数
  bool isCDReady = true;
  GameActiveType activeType = GameActiveType.Pasitive;
  GameSkillDebuff(this.game,this.monster, {Function skillConditon})
      : super(game,monster, skillConditon: skillConditon) {
   
  }
  ///10秒执行一次，是否执行RunshSKill
  @override
  bool checkSkillAvaiable(t) {
    return super.checkSkillAvaiable(t);
  }
  
  @override
  void onSkillExecing() {
   
  }
  @override
  void onSkillExeced() {
   
  }
  
}
