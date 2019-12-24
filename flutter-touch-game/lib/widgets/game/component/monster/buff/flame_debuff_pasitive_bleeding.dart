import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';
import 'flame_debuff_pasitive.dart';

//流血效果
class GameSkillDebuffBleeding extends GameSkillDebuff {
  final LangawGame game;
  final Monster monster;
  double skillCD = 1; //10秒执行一次
  double unavaiableAfterCD = 10; //n秒后失效
  int attactPower = 5; //流血伤害，1后续根据其他buff进行攻击毒加成
  GameBuffType gameBuffType = GameBuffType.debuff_bleeding;
  GameSkillDebuffBleeding(this.game, this.monster,
      {Function skillConditon, double duration})
      : super(game, monster, skillConditon: skillConditon) {
    if (monster == null) {
      skillCD = 10; //给用户上毒；
    }
    if (duration != null) {
      unavaiableAfterCD = duration;
    }
  }

  ///10秒执行一次，是否执行RunshSKill
  @override
  bool checkSkillAvaiable(t) {
    return super.checkSkillAvaiable(t);
  }

  @override
  void onSkillExecing() {}
  //自动型上毒状态判断
  @override
  void onSkillExeced() {
    if (monster != null) {
     // monster.curHp -= attackDamage();
      monster.underAttacked(damage:attackDamage(),color: color_game_icon3);
      //流血伤害特效直接死亡
      if (monster.curHp <= 0) {
        monster.onTapDown();
      } 
      //monster.onTapDown();
    } else {
      game.loseLife();
    }
    game.audioplayers.bleeding();
  }

  int attackDamage() {
    var damage = (0.01 * monster.initHp).toInt();
    if (damage <= 0) {
      damage = attactPower;
    }
    return damage;
  }
}
