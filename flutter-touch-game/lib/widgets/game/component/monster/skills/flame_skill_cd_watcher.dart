import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';

//统一抽象出来每秒对CD进行判断，不用每一帧都判断优化速度
class GlobalSkillCDWatcher {
  final LangawGame game;
  double initialCheckCD = 1; //初始化cd 5秒查看一次是否有已经准备好的技能
  double checkCD; //1秒执行一次
  GlobalSkillCDWatcher(this.game) {
    checkCD = initialCheckCD / 10;
  }

  ///1秒执行一次，获取可用的
  void update(t) {
    checkCD = checkCD - .1 * t;
    if (checkCD <= 0) {
      checkCD = initialCheckCD / 10;
      //更新用户技能CD
      var allUserSkills = game.userSkills;
      if (allUserSkills != null) {
        for (var skill in allUserSkills) {
          skill.checkSkillAvaiable(t);
        }
      }
      if (game.flies != null && game.flies.length > 0) {
        //更新monsterCD

        var hitMonsters = game.flies.where((c) => c.skills.length > 0).toList();
        for (var monster in hitMonsters) {
          monster.skills.forEach((c) {
            c.checkSkillAvaiable(t);
          });
        }
      }
    }
    //删除过期技能
  }
}
