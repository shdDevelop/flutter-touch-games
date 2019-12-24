import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';
import 'flame_debuff_pasitive.dart';

//dubuff 被动性 束缚 只执行1次 5秒后失效
class GameSkillDebuffImprisonment extends GameSkillDebuff {
  final LangawGame game;
  final Monster monster;
  double skillCD = 10; //10秒执行一次
  double unavaiableAfterCD =4; //n秒后失效
  int skillDuration =4; //2持续3秒 3秒后恢复
  int avaiableTimes = 1; //可执行的次数
  bool isImmediate=true;
 
  GameBuffType gameBuffType = GameBuffType.debuff_imprisonment;
  GameSkillDebuffImprisonment(this.game, this.monster,
      {Function skillConditon, double duration})
      : super(game, monster, skillConditon: skillConditon) {
    if (duration != null) {
      unavaiableAfterCD = duration;
      skillDuration=unavaiableAfterCD.toInt();
    }
  }

  ///10秒执行一次，是否执行RunshSKill
  @override
  bool checkSkillAvaiable(t) {
    return super.checkSkillAvaiable(t);
  }
  
  @override
  void onSkillExecing() {
    monster?.canMove = false;
  }

  //自动型
  @override
  void onSkillExeced() {
    monster?.canMove = true;
   }
}
