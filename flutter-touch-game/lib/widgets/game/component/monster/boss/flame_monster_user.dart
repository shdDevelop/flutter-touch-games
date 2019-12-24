import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill.dart';

import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill_user_watcher.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hp_effect.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_mp_effect.dart';

import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

//将用户这个对象作为一个唯一对象用于通用buff化
//不加入fly列表
class UserMonster extends ElitMonster {
  UserMonster(this.game) : super(game: game) {
    flyingSprite = new List<Sprite>();

    // flyRect = Rect.fromLTWH(game.screenSize.width - game.tileSize * rectSize-game.tileSize*1,
    //     game.tileSize * 2, game.tileSize * rectSize, game.tileSize * 1);
    var curWidth=game.tileSize * rectSize*0.8;
    flyRect = Rect.fromLTWH(game.screenSize.width- curWidth-game.tileSize * 1.5,
        game.tileSize *1.5,curWidth, game.tileSize * 1.3);
    //被动调度器，用于不用考虑各个技能时间间隔问题，有就触发
    //skillPassiveWatcher = new MonsterBuffWatcher(this);
    userSkillWatcher = new UserSkillWatcher(game);
    //减少显示声明条数
    hpEffect=new MonsterHPEffect(this,height: game.tileSize*0.2,hasLifeCount: false);
    mpEffect=new MonsterMPEffect(this,height: game.tileSize*0.2);
  }
  double monsterSpeedEnhence = 1.0;
  double get speed => 0; //移动速度
  double rectSize = 3;
  UserSkillWatcher userSkillWatcher;
  MonsterHPEffect hpEffect;
  MonsterMPEffect mpEffect;
  int initHp = 1 * Game_HP_Unit; //100
  int initMp = 100;
  int curMp = 0;
  int hits = 0;
  int lives = 3; //阶段次数 每次阶段可能出现不同技能 3次QTE
  int initLife = 3;
  bool canKill = false; //是否可击杀
  bool isQTEMode = false;
  bool canMove = false;

  final LangawGame game;

  @override
  void render(Canvas canvas) {
    buffDisplay?.render(canvas);
    hitEffectDamage?.render(canvas); //伤害值展示
  
    if (curHp > 0 && hasHp) {
      hpEffect?.render(canvas); //血条
      hitEffectDamage?.render(canvas);
      mpEffect?.render(canvas);
    }
  }

  @override
  void update(double t) {
    userSkillWatcher.update(t);
    buffDisplay?.update(t); //buff
    hitEffectDamage?.update(t); //伤害值展示
    if (curHp > 0 && hasHp) {
      hpEffect?.update(t); //血条
      hitEffectDamage?.update(t);
       mpEffect?.update(t);
    }
  }

  @override
  void onTapDown({int damage, Color color}) {}

  @override
  //增加技能或者buff
  Future addSkillOrBuff(GameSkill skill) async {
    var hitSkillList =
        skills.where((c) => c.gameBuffType == skill.gameBuffType).toList();

    if (hitSkillList != null) {
      hitSkillList.forEach((hitSkill) {
        hitSkill.isSkillAvaiable = false;
      }); //无效等待删除

    }
    skills.add(skill); //增加新的技能
    //马上执行buff；
  }
}
