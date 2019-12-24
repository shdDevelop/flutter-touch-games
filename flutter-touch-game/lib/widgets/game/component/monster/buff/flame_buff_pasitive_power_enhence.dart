import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';
import 'flame_debuff_pasitive.dart';

//buff 提升或者下降根据目前只应用在用户身上
class GameSkillBuffPowerEnhence extends GameSkillDebuff {
  final LangawGame game;
  final Monster monster;
  double skillCD = 10; //10秒执行一次
  double unavaiableAfterCD = -1; //n秒后删除
  int skillDuration = -1; //2持续3秒 3秒后恢复
  int avaiableTimes = 1; //可执行的次数
  double powerEnhence = 1;
  double maxPowerEnhence = 1; //最大可增加
  bool isImmediate=true;
  GameBuffType gameBuffType = GameBuffType.buff_power_up_forever;
  GameSkillBuffPowerEnhence(this.game, this.monster,
      {Function skillConditon, double duration})
      : super(game, monster, skillConditon: skillConditon) {
    if (duration != null) {
      unavaiableAfterCD = duration;
      skillDuration = unavaiableAfterCD.toInt();
    }
  }

  ///10秒执行一次，是否执行RunshSKill
  @override
  bool checkSkillAvaiable(t) {
    return super.checkSkillAvaiable(t);
  }

  //开始
  @override
  void onSkillExecing() {
    if (maxPowerEnhence >= 0) {
      game.att += powerEnhence.toInt() *( Game_Att_Unit*0.2).toInt();
      maxPowerEnhence -= powerEnhence;
    }
  }

  //恢复
  @override
  void onSkillExeced() {}
}
