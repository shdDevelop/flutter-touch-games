import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_buff_display.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';

//用于怪兽技能检测基类用于检测当前哪个buff技能
class MonsterBuffWatcher {
  LangawGame game;
  final Monster monster;
  final double initialCheckCD; //初始化cd 5秒查看一次是否有已经准备好的技能

  double checkCD = 0; //10秒执行一次
  MonsterBuffWatcher(this.monster, {this.initialCheckCD = 1}) {
    game = monster.game;
    checkCD = initialCheckCD / 10;
  }

  ///1秒执行一次，获取可用的，速度优化每一秒执行一次而非一直执行
  void update(t, {bool isImmediately = false}) {
    checkCD = checkCD - .1 * t;
    if (checkCD <= 0 || isImmediately) {
      checkCD = initialCheckCD / 10;
      checkBuff();
    }
    //删除过期buff技能可能为次数到达，可能为cd时间到达
    monster.skills.removeWhere((c) => c.isSkillAvaiable == false); //删除过期技能
  }

  //用户使用道具的时候，只有立即执行的如禁锢，冰冻等技能才会立即执行，否则按照skillwatcherCD进行
  void checkBuff({bool onlyImmediateSkill}) {
    var hitSkillQuery = monster.skills
        .where((c) => c.activeType == GameActiveType.Pasitive); //被动
    if (hitSkillQuery.length <= 0) {
      return;
    }
    var readySkills = hitSkillQuery
        .where((c) => c.isCDReady == true && c.isSkillAvaiable == true)
        .toList();
    if (readySkills.length > 0) {
      for (var readkySkill in readySkills) {
        if (onlyImmediateSkill != null &&
            onlyImmediateSkill == true &&
            readkySkill.isImmediate == false) {
          continue;
        }
        readkySkill?.execSkill();
      }
    }
  }
}
