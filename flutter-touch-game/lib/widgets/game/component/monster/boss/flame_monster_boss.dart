import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/elit/flame_monster_elit.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill_monster_watcher.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill_positive_narrow.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill_positive_rush.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_combo_hits.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_entrance_warning.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_effect_finish.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_tip_qte.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_tip_warning.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hp_effect_boss.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_monster_emoticon.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

//具有击杀条件默认连击 life数
//QTE触发后点击后触发子弹时间
//拥有更强的属性，掉落特殊道具
//
class BossMonster extends ElitMonster {
  BossMonster({this.game, ItemRare monsterRare}) : super(game: game) {
    flyingSprite = new List<Sprite>();
    // var sex = game.rnd.nextInt(2);
    // var type = game.rnd.nextInt(10);
    // var mood = game.rnd.nextInt(2) - 1;
    // flyingSprite.add(new Sprite('map/${sex}_${type}_$mood.png'));
    // deadSprite = new Sprite('map/${sex}_${type}_2.png');
    var bossUiIndex =
        game.rnd.nextInt(game.resourceManager.monsterSpriteList.length);
    var bossSprite = game.resourceManager.monsterSpriteList[bossUiIndex];
    flyingSprite.add(bossSprite);
    deadSprite = bossSprite;
    flyRect =
        Rect.fromLTWH(x, y, game.tileSize * rectSize, game.tileSize * rectSize);
    rare = monsterRare;
    curSKill = new GameSkill(game, this); //基础技能
    skills.add(new SkillRush(game, this)); //lives剩下2条的时候触发
    skills.add(new SkillNarrow(game, this,
        skillConditon: (skill) => lives <= 1)); //lives剩下2条的时候触发

    skillPossiveWatcher =
        new MonsterSkillWatcher(this); //主动技能调度器，需要考虑多个技能呢防止一直触发
    //被动调度器，用于不用考虑各个技能时间间隔问题，有就触发
    //skillPassiveWatcher = new MonsterBuffWatcher(this);
    comboHitsEffect = new MonsterComboHitsEffect(this);
    monsterEmoi = new MonsterEmoticon(this);
    bossHpEffect = new BossHPEffect(this);
  }
  double monsterSpeedEnhence = 4.0;
  double get speed => game.tileSize * monsterSpeedEnhence * speedEnhence*game.towerlevelEnhence; //移动速度
  double rectSize = 1.5;

  int get initHp =>  (150 * Game_HP_Unit*game.towerlevelEnhence).toInt(); //100
  int hits = 0;
  int lives = 2; //阶段次数 每次阶段可能出现不同技能 3次QTE
  bool canKill = false; //是否可击杀
  bool isQTEMode = false;
  final LangawGame game;
  bool hasCallout = false; //不会超时
  EntranceWarning enterWarning; //boss入场动画
  bool isEnterWarningComplete = false; //是否展示入场动画
  bool isShowFinishStage = false; //是否展示终结动画
  bool hasEmoi = true;
  HitEffectFinish finishStage; //终结动画
  HitTipQTE hitTipQte; //Qte提示；
  HitTipWarning hitTipWarning; //boss技能提示
  bool isTipWarning = false;
  MonsterSkillWatcher skillPossiveWatcher; //主动技能检测
  // MonsterBuffWatcher skillPassiveWatcher; //被动技能检测
  MonsterComboHitsEffect comboHitsEffect; //连打特效
  MonsterEmoticon monsterEmoi;
  BossHPEffect bossHpEffect; //boss中间血条
  //击杀后特效
  @override
  void onHitEffect() async {
    isShowFinishStage = false; //终结结束
    game.monsterKilled(this);
  }

  //击杀后特效
  @override
  bool isMatchDefeatCondition() {
    return canKill;
  }

  //获取基础得分
  @override
  getScore() {
    return 50;
  }

  @override
  void render(Canvas canvas) {
    if (isDead == false) {
      bossHpEffect?.render(canvas);
    }
    super.render(canvas);
    if (hasEmoi) {
      monsterEmoi.render(canvas);
    }
    if (isEnterWarningComplete == false) {
      if (enterWarning == null) {
        enterWarning = new EntranceWarning(this);
      }
      enterWarning?.render(canvas);
    }

    if (game.activeView == View.playing) {
      ///展示提示点击感叹号
      if (triggerQTEMode() && hitTipQte != null) {
        hitTipQte.render(canvas);
      }
    }
    if (isDead == false) {
      if (isTipWarning && hitTipWarning != null) {
        hitTipWarning?.render(canvas);
      }
      if (comboHits > 0) {
        comboHitsEffect.render(canvas);
      }
      if (isShowFinishStage && finishStage == null) {
        finishStage = new HitEffectFinish(this, callback: () {
          canKill = true;
          isShowFinishStage = false;
          onTapDown();
        });
      }
      if (isShowFinishStage) {
        finishStage?.render(canvas);
      }
    }
  }

  @override
  void update(double t) {
    if (isEnterWarningComplete == false) {
      enterWarning?.update(t);
      Future.delayed(Duration(seconds: 3)).then((_) {
        isEnterWarningComplete = true;
      });
    }
    super.update(t);
    if (hasEmoi) {
      monsterEmoi.update(t);
    }
    if (isShowFinishStage) {
      finishStage?.update(t);
    }
    if (game.activeView == View.playing) {
      //展示QTE
      if (triggerQTEMode()) {
        if (hitTipQte == null) {
          hitTipQte = new HitTipQTE(this);
        }
        hitTipQte.update(t);
      }
    }
    if (isTipWarning) {
      if (hitTipWarning == null) {
        hitTipWarning = new HitTipWarning(this);
      }
      hitTipWarning?.update(t);
    }
    if (isTipWarning == false) {
      skillPossiveWatcher?.update(t);
      // skillPassiveWatcher?.update(t);
    }
    if (comboHits > 0) {
      comboHitsEffect?.update(t);
    }
    if (isDead == false) {
      bossHpEffect?.update(t);
    }
  }

  //随机移动
  @override
  void flyRandom(double t) {
    //终结阶段不移动
    if (isShowFinishStage) {
      canMove = false;
    }
    super.flyRandom(t);
  }

  //触发子弹时间,特效，怪物放大,遮罩特效
  @override
  void onTapStart() {
    if (isQTEMode) {
      execComboHitQTE();
    } else {
      monsterDefeatCheck();
    }
    game.audioplayers.successHit();
  }

  void monsterDefeatCheck() {
    if (curHp <= 0) {
      if (lives <= 1) {
        comboHits = 0;
        //canKill = true;//可以删除
        isShowFinishStage = true; //展示终结动画
        canMove = false;
        game.nextLevel();
      } else {
        if (comboHits == 0) {
          bossChangeNextStage();
        }
      }
    }
  }

  ///触发连打QTE
  void execComboHitQTE() {
    if (comboHits <= 0) {
      game.audioplayers.shieldCrash();
      //子弹时间减速
      game.bulletTime(seconds: 2, speedPercent: -0.999).then((_) {
        flyRect = flyRect.inflate(-comboHits * 2.0); //恢复大小
        if (comboHits >= 5) {
          //展示成功QTE动画后扣血
          showHitFx(isFinish: true); //终结特效
          game.audioplayers.bleeding();
          //大量伤害
          underAttacked(damage: qteAttackDamage(), color: color_game_icon4);
          game.combo++;
          //Qte动画效果
          game.bulletTime(seconds: 1, speedPercent: -0.999).then((_) {
            comboHits = 0;
            hits = 0;
            isQTEMode = false;
            monsterDefeatCheck();
          });
        } else {
          comboHits = 0;
          hits = 0;
        }
      });
    } else {
      if (isQTEMode) {
        flyRect = flyRect.inflate(2.0);
        //game.audioplayers.successHit(); //连打音效
      }
    }
    comboHits++;
    game.combo++;
  }

  //是否QTE模式 尽量少的QTE，减少用户反馈，格挡，打断，debuff
  bool triggerQTEMode() {
    var hasHpHitConditon = false;
    var curHpPercent = curHp / initHp;
    if (isTipWarning) {
      //打断技能触发
      hasHpHitConditon = true;
    } else {
      //没来得及点击
      if (comboHits <= 0) {
        isQTEMode = false;
      }
    }
    //或者debuff状态
    if (isDead == false && hits > 10 && hasHpHitConditon) {
      isQTEMode = true;
      return true;
    }
    return false;
  }

  //qte伤害
  int qteAttackDamage() {
    var damage = (0.15 * initHp).toInt();
    if (damage <= 0) {
      damage = 1;
    }

    if ((curHp - damage) / initHp <= 0.2) {
      damage += (initHp * 0.21).toInt();
    }
    return damage;
  }

  //进入下一阶段
  void bossChangeNextStage() {
    lives--; //进入下一阶段
    comboHits = 0;
    hits = 0;
    flyRect = Rect.fromLTWH(flyRect.left, flyRect.top, game.tileSize * rectSize,
        game.tileSize * rectSize);
    hpRecovery();
    monsterSpeedEnhence += 0.2; //加速
    if (lives > 0) {
      //护盾
      game.audioplayers.shield();
      showHitFx();
    }
  }

  void hpRecovery() {
    curHp = initHp;
  }
}
