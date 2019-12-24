import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';

//用户触发技能，在用户点击对象buff的时候触发是否给buff上buff
class UserSkillWatcher {
  LangawGame game;
  final double initialCheckCD; //初始化cd 5秒查看一次是否有已经准备好的技能
  double checkCD; //1秒执行一次
  UserSkillWatcher(this.game, {this.initialCheckCD = 5}) {
    checkCD = initialCheckCD / 10;
  }

  ///1秒执行一次，获取可用的,被动型触发
  void update(t) {
    checkCD = checkCD - .1 * t;
    if (checkCD <= 0) {
      var hitSkillQuery = game.userSkills;
      if (hitSkillQuery.length <= 0) {
        return;
      }
      checkCD = initialCheckCD / 10;
      var readySkills = hitSkillQuery
          .where((c) =>
              c.isCDReady == true && c.activeMode != GameActiveMode.Touch)
          .toList();
      if (readySkills.length > 0) {
        game.curSKill = readySkills[game.rnd.nextInt(readySkills.length)];
        game.curSKill.execSkill();
      } else {
        game.curSKill = null;
      }
    }
    //删除过期技能
    game.userSkills.removeWhere((c) => c.isSkillAvaiable == false); //删除过期技能
  }

  //1秒执行一次，获取可用的
  void activeSkill(Monster monster) {
    if (monster == null) return;
    checkCD = initialCheckCD / 10;
    var readySkills = game.userSkills
        .where((c) =>
            c.isCDReady == true &&
            c.activeType == GameActiveType.Positive &&
            c.activeMode == GameActiveMode.Touch) //c.isCDReady == true
        .toList();
    if (readySkills.length > 0) {
      for (var readySkill in readySkills) {
        readySkill.userActiveSkill(monster);
      }
    }
  }
}
