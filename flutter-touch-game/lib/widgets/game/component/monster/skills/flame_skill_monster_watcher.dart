import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';
import 'flame_skill.dart';

//monster技能检测基类用于检测当前哪个 主动技能检测
class MonsterSkillWatcher {
  LangawGame game;
  final Monster monster;
  final double initialCheckCD; //初始化cd 5秒查看一次是否有已经准备好的技能
  double checkCD; //1秒执行一次
  final GameActiveType activeType;
  MonsterSkillWatcher(this.monster,
      {this.activeType = GameActiveType.Positive, this.initialCheckCD = 5}) {
    game = monster.game;
    checkCD = initialCheckCD / 10;
  }

  ///1秒执行一次，获取可用的
  void update(t) {
    checkCD = checkCD - .1 * t;
    if (checkCD <= 0) {
      if(monster.canUserPositiveSkill==false)//是否可以使用主动技能；
      {
        return;
      }
      var hitSkillQuery =
          monster.skills.where((c) => c.activeType == activeType);
      if (hitSkillQuery.length <= 0) {
        return;
      }

      checkCD = initialCheckCD / 10;
      var readySkills =
          hitSkillQuery.where((c) => c.isCDReady == true).toList();
      if (readySkills.length > 0) {
        monster.curSKill = readySkills[game.rnd.nextInt(readySkills.length)];
        monster.curSKill.execSkill();
      } else {
        monster.curSKill = null;
      }
    }
    //删除过期技能
    monster.skills.removeWhere((c) => c.isSkillAvaiable == false); //删除过期技能
  }
}
