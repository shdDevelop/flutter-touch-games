
import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../../flame_Langaw_Game.dart';
import '../flame_monster.dart';
import 'flame_debuff_pasitive.dart';

//dubuff 被动性
class GameSkillDebuffPoison extends GameSkillDebuff {
  final LangawGame game;
  final Monster monster;
  double skillCD =3 ; //10秒执行一次
  double unavaiableAfterCD = 20; //n秒后失效
  int attactPower = 1; //毒伤害，1后续根据其他buff进行攻击毒加成
  GameBuffType gameBuffType = GameBuffType.debuff_poison;
  GameSkillDebuffPoison(this.game, this.monster,
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
      if (monster.curHp > 1) {
        monster.underAttacked(damage:attackDamage(),color:color_game_icon4);
        game.audioplayers.poison();
      }
      //monster.onTapDown();
    } 
  }
  int attackDamage()
  {
    var damage=(0.05*monster.initHp).toInt();
    if(damage<=0)
    {
      damage=attactPower;
    }
    return damage;
  }
}
