import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';
import 'flame_debuff_pasitive.dart';

//buff 移动速度提升或者下降
class GameSkillBuffSpeedEnhence extends GameSkillDebuff {
  final LangawGame game;
  final Monster monster;
  double skillCD = 10; //10秒执行一次
  double unavaiableAfterCD =10; //n秒后删除
  int skillDuration = 5; //2持续3秒 3秒后恢复
  int avaiableTimes = 1; //可执行的次数
  double initMonsterSpeedEnhence = 0;
  double speedEnhencePercent = 0.5;
  bool isImmediate=true;
  GameBuffType gameBuffType = GameBuffType.buff_speed_up;
  GameSkillBuffSpeedEnhence(this.game, this.monster,
      {Function skillConditon, double duration, double speedEnhenceP})
      : super(game, monster, skillConditon: skillConditon) {
    if (duration != null) {
      unavaiableAfterCD = duration;
      skillDuration = unavaiableAfterCD.toInt();
    }
    initMonsterSpeedEnhence = monster?.monsterSpeedEnhence;
    if (speedEnhenceP != null) {
      speedEnhencePercent = speedEnhenceP;
    }
    if (speedEnhenceP < 0) {
      gameBuffType = GameBuffType.debuff_speed_down;
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
    monster?.monsterSpeedEnhence =
        monster.monsterSpeedEnhence * (1 + speedEnhencePercent);
  }

  //恢复
  @override
  void onSkillExeced() {
    monster?.monsterSpeedEnhence = initMonsterSpeedEnhence;
  }
}
