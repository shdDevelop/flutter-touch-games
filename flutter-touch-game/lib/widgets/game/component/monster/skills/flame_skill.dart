import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../../flame_Langaw_Game.dart';

typedef bool SkillAvaiableCondition(GameSkill skill);
typedef bool SkillFailureCondition(GameSkill skill); //失效条件

//技能基类
//需要一个定时器每1秒查看是否有cd已经好了的技能
//使用了统一CDwatcher进行CD计算每秒调用 checkSkillAvaiable 因此优化速度
class GameSkill {
  final LangawGame game;
  final Monster monster;
  double skillCD = 5; //技能CD10秒执行一次
  double unavaiableAfterCD = -1; //n秒后失效
  double curElapseTime = 0;
  double curSkillTime = 0;
  int avaiableTimes = -1; //可执行的次数
  int skillDuration = 2; //2持续2秒 未-1代表永久执行 onSkillExecing 与onSkilledz之间的间隔
  bool isCDReady = false; //CD是否准备好了
  bool isCDReadyNoticeing = false; //用于展示高亮技能buff图标标识CD已经准备好
  bool isSkillAvaiable = true; //当前技能是否还生效
  bool isImmediate = false; //是否立即生效
  double probabability = 1; //发动概率
  GameActiveMode activeMode = GameActiveMode.CD;
  GameBuffType gameBuffType;
  bool get hasBuffIcon => gameBuffType != null;
  String get buffSpriteStr => GameEnumHelper.getStringFromEnum(gameBuffType);
  GameActiveType activeType = GameActiveType.Positive;
  final SkillAvaiableCondition skillConditon; //monster 传入的条件属性
  final SkillFailureCondition skillFailureConditon; //失效条件
  GameSkill(this.game, this.monster,
      {this.skillConditon, this.skillFailureConditon}) {
    curSkillTime = skillCD;
    //用于检查CD过期时间
    if (unavaiableAfterCD != -1) {
      curElapseTime = unavaiableAfterCD;
    }
  }

  void render(Canvas c) {}

  void update(double t) {}

  ///10秒执行一次，是否执行RunshSKill
  bool checkSkillAvaiable(t) {
    //检查是否已经超时
    if (isSkillAvaiable == false || _checkSkillNeedDelete(t)) {
      isSkillAvaiable = false;
      return false;
    }
    if (skillConditon != null && skillConditon(this) == false) {
      return false;
    }
    if (isCDReady == false) {
      curSkillTime = curSkillTime - game.globalSkillCDWatcher?.initialCheckCD;
      if (curSkillTime <= 0) {
        setSkillCDReady();
        curSkillTime = skillCD;
        return true;
      }
    }
    return false;
  }

  //技能发动Rush
  void execSkill() {
    isCDReady = false;
    if (avaiableTimes == 0) {
      return; //不执行，等待cd后删除
    }
    if (activeType == GameActiveType.Positive) {
      monster.isTipWarning = true;
    }

    Future.delayed(Duration(seconds: 1)).then((_) {
      if (monster.comboHits > 0) {
        //技能打断
        monster.isTipWarning = false;
        return;
      }
      if (activeType == GameActiveType.Positive) {
        monster.isTipWarning = false;
      }
      //概率是否通过
      if (canAddSkillByProbabability() == true) {
        _avaiableTimeDecrease(); //提前减少次数
        onSkillExecing();
        //可用次数减少
        if (skillDuration >= 0) {
          Future.delayed(Duration(seconds: skillDuration)).then((_) {
            onSkillExeced();
          });
        } else {}
      }
    });
  }

  void onSkillExecing() {}

  void onSkillExeced() {}

  //技能可用次数减少
  void _avaiableTimeDecrease() {
    if (avaiableTimes != -1) {
      avaiableTimes--;
      if (avaiableTimes <= 0) {
        avaiableTimes = 0;
      }
    }
  }

  //检查当前技能buff是否需要被移除
  bool _checkSkillNeedDelete(t) {
    if (unavaiableAfterCD != -1) {
      curElapseTime = curElapseTime - game.globalSkillCDWatcher?.initialCheckCD;
      if (curElapseTime <= 0) {
        curElapseTime = unavaiableAfterCD; //重置
        return true;
      }
    }
    return false;
  }

  //通过概率计算是否可以发动技能呢
  bool canAddSkillByProbabability() {
    if (probabability >= 1) {
      return true;
    } else {
      var seed = 10000;
      var compareValue = (probabability * 10000).toInt();
      var curRndValue = game.rnd.nextInt(seed);
      if (curRndValue > compareValue) {
        return false;
      } else {
        return true;
      }
    }
  }

  void userActiveSkill(Monster monster) {}

  void setSkillCDReady() {
    isCDReady = true;
    isCDReadyNoticeing = true;
    Future.delayed(Duration(seconds: 1)).then((_) {
      isCDReadyNoticeing = false;
    });
  }
}
