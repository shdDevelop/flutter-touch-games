import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/utils/sp_util.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/skills/flame_skill.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_buff_display.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_callout.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_effect.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_effect_finish.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_effect_fx.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_effect_fx_flash.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hit_effect_score.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_hp_effect.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/flame_monster_emoticon.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';
import 'buff/flame_buff_monster_watcher.dart';

///怪物基类随机运动
class Monster {
  Monster({this.game}) {
    // flyRect=new Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    if (game.isDebugMode) {
      hasCallout = false;
    }
    flyPaint = Paint();
    flyPaint.color = Color(0xff6ab04c);
    var flyRectLoc = getRndLocation();
    x = flyRectLoc.dx;
    y = flyRectLoc.dy;
    targetLocation = getRndLocation();
    if (hasCallout) {
      callout = new Callout(this);
    }
    getItemLocation =
        new Offset(game.screenSize.width - game.tileSize * 1.0, 0);

    boundSprite = new List<Sprite>();
    for (var spritePath in game.resourceManager.boundSpriteList) {
      boundSprite.add(new Sprite(spritePath));
    }
    hitEffect = new HitEffect(this); //点击特效
    hpEffect = new MonsterHPEffect(this);
    buffWatcher = new MonsterBuffWatcher(this);
    buffDisplay = new MonsterBuffDisplay(this);
    curHp = initHp;
  }
  double x; //所在位置
  double y;
  double width; //宽高
  double heigh;

  int initHp = 1;
  int curHp = 0;
  int initMp = 0;
  int curMp = 0;
  int hits = 0;
  int lives = 1;
  int get score => getScore(); //得分
  int comboHits = 0; //连击效果
  Rect flyRect; //所在区域
  Paint flyPaint; //画笔
  bool isDead = false; //是否存活
  bool isOffScreen = false; //是否超出屏幕
  bool isCallout = false; //是否超时
  bool hasCallout = true; //是否具有超时属性
  bool isHitStart = false;
  bool isItem = false; //是否物品
  bool canMove = true; //是否可以移动
  bool canUserPositiveSkill = true; //是否可以使用主动技能
  bool isTipWarning = false; //是否有主动技能提醒
  bool hasHp = false;
  final LangawGame game; //主game对象
  List<Sprite> flyingSprite; //动画对象
  List<Sprite> boundSprite;
  Sprite deadSprite; //被点击后对象
  double flyingSpriteIndex = 0; //怪物当前动画帧
  double boundSpriteIndex = 0;
  double monsterSpeedEnhence = 3.5;
  double get speed => game.tileSize * monsterSpeedEnhence; //速度单位
  Offset targetLocation;
  Offset getItemLocation;
  Callout callout;
  ItemRare rare;
  HitEffect hitEffect;
  HitEffectFX hitFX; //打击效果
  MonsterHPEffect hpEffect;
  MonsterBuffWatcher buffWatcher;
  MonsterBuffDisplay buffDisplay;
  HitEffectScoreText hitEffectDamage; //伤害

  List<GameSkill> skills = new List<GameSkill>();
  GameSkill curSKill;

  //ElitMosnter属性

  //获取随机位置
  Offset getRndLocation() {
    var rndX = game.rnd.nextDouble();
    var rndY = game.rnd.nextDouble();
    if (rndX <= 0) {
      rndX = 0.1;
    }
    if (rndY <= 0) {
      rndY = 0.1;
    }
    x = rndX * (game.screenSize.width - (game.tileSize * 2.025));
    y = rndY * (game.screenSize.height - (game.tileSize * 2.025));
    return Offset(x, y);
  }

  bool checkErrorLocation() {
    return checkErrorLocationRect(flyRect);
  }

  bool checkErrorLocationRect(Rect rect) {
    return checkErrorLocationOffset(Offset(rect.left, rect.top));
  }

  bool checkErrorLocationOffset(Offset offset) {
    if (offset.dx <= -1 ||
        offset.dx > game.screenSize.width ||
        offset.dy <= -1 && offset.dy > game.screenSize.height) {
      return true;
    }
    return false;
  }

//检查位置
  Offset checkocation() {
    y = game.rnd.nextDouble() *
        (game.screenSize.height - (game.tileSize * 2.025));
    return Offset(x, y);
  }

  void update(double t) {
    if (flyRect == null) return;
    //轮询动画帧
    // flyingSpriteIndex += 30 * t;
    // if (flyingSpriteIndex >= flyingSprite.length) {
    //   flyingSpriteIndex = 0;
    // }
    boundSpriteIndex += 30 * t;
    if (boundSpriteIndex >= game.resourceManager.boundSpriteList.length - 1) {
      boundSpriteIndex = 0;
    }
    // TODO: implement update
    if (isDead == true) {
      if (isCallout) {
        //根据时间流逝往下掉
        flyFail(t);
      } else {
        //点击monster
        hitEffect.update(t); //点击特效
        if (isNormal() == false) {
          flyToTarget(t, getItemLocation,
              speedEnhence: 2, getItemSpeed: game.tileSize*5);
          if (flyRect.top == 0) {
            isOffScreen = true;
            getItem(t);
          }
        } else {
          Future.delayed(new Duration(milliseconds: 1000)).then((_) {
            isOffScreen = true;
          });
        }
      }
    } else {
      flyRandom(t);
      callout?.update(t);
      if (curHp > 0 && hasHp) {
        hpEffect?.update(t); //血条
      }
      buffWatcher?.update(t); //buff 轮询
      buffDisplay?.update(t); //buff
    }
    if (game.activeView == View.playing) {
      hitFX?.update(t);
      hitEffectDamage?.update(t); //伤害值展示
    }
  }

  //获得当前物品
  void getItem(double t) {
    game.audioplayers.getItem(itemType: ItemRare.legend);
  }

  //随机移动
  void flyRandom(double t) {
    if (canMove == false) return;

    flyToTarget(t, targetLocation,
        nextTarget: getRndLocation,
        speedEnhence: (1 + game.monsterSpeedPercent));
    if (checkErrorLocation()) {
      targetLocation = getRndLocation();
    }
  }

  //移动到指定位置
  void flyToTarget(double t, Offset target,
      {Function nextTarget, double speedEnhence = 1, double getItemSpeed}) {
    if (target == null) return;
    double stepDistance = speed * t * speedEnhence; //速度衰减,增加当前怪物的速度加成
    if (getItemSpeed != null) {
      stepDistance = getItemSpeed * t * speedEnhence; //速度衰减,增加当前怪物的速度加成
    }
    Offset toTarget = target - new Offset(flyRect.left, flyRect.top);
    if (toTarget.distance > stepDistance) {
      Offset stepToTarget =
          Offset.fromDirection(toTarget.direction, stepDistance);

      flyRect = flyRect.shift(stepToTarget);
    } else {
      flyRect = flyRect.shift(toTarget);
      if (nextTarget != null) {
        targetLocation = nextTarget();
      }
    }
  }

  //往下掉；
  void flyFail(double t) {
    flyRect = flyRect.translate(0, game.tileSize * 12 * t);
    //超出批评木
    if (flyRect.top > game.screenSize.height) {
      isOffScreen = true;
    }
  }

  void render(Canvas canvas) {
    // canvas.drawRect(flyRect, flyPaint);
    if (flyRect == null)
      flyRect = new Rect.fromLTWH(x, y, game.tileSize * 3, game.tileSize * 3);
    //被点击状态
    if (isDead) {
      if (isCallout) {
        onCalOut(canvas);
      } else {
        //获得物品
        if (isNormal() == false) {
          boundSprite[boundSpriteIndex.toInt()]
              .renderRect(canvas, flyRect.inflate(2));
          flyRect = flyRect.inflate(-0.2);
        }
        hitEffect.render(canvas); //点击特效一直触发
      }
    } else {
      flyingSprite[flyingSpriteIndex.toInt()]
          .renderRect(canvas, flyRect.inflate(3));
      if (game.activeView == View.playing) {
        callout?.render(canvas);
        if (curHp > 0 && hasHp) {
          hpEffect?.render(canvas);
        }
        buffDisplay?.render(canvas);
      }
    }
    if (game.activeView == View.playing) {
      hitEffectDamage?.render(canvas); //伤害值展示
    }
    hitFX?.render(canvas);
  }

  void onCalOut(Canvas canvas) {
    game.audioplayers.monsterFail();
    game.combo = 0; //连击数清空
    isOffScreen=true;
    game.loseLife();
    if (deadSprite != null) {
      deadSprite.renderRect(canvas, flyRect.inflate(2));
    }
  }

  void onTapDown({int damage, Color color}) {
    if(isDead){return;}
    buffAttactDetect(); //buff攻击检测
    showHitFx();
    underAttacked(damage:damage,color:color);
    onTapStart();
    //flyPaint.color = Color(0xffff4757);
    if (isDead == false && isMatchDefeatCondition()) {
      isDead = true;
      if (onHitEffect != null) {
        onHitEffect();
      }
    }
  }

  //展示打击特效
  void showHitFx({bool isFinish = false}) {
    //是否终结
    if (isFinish) {
      var flashEffect = HitEffectFXFlash(
        this,
      );
      hitFX = flashEffect.curHitEffectFx;
    } else {
      hitFX = new HitEffectFX(this);
    }
    game.userIncreaseMp();
    
  }
  
  ///初始化分数
  int getScore() {
    switch (rare) {
      case ItemRare.legend:
        return 5;
        break;
      case ItemRare.normal:
      default:
        return 1;
        break;
    }
  }

  ///根据连击数获取得分
  int getFinalScore() {
    //连击加成算法 10 以上增加 每10连击增加10%
    double finalScore = score * (1 + game.combo / 100.0)*game.towerlevelEnhence;
    return finalScore.toInt();
  }

  bool isNormal() {
    return rare == null || rare == ItemRare.normal;
  }

  //当前点击特效
  void onHitEffect() {
    game.monsterKilled(this);
  }

  ///是否匹配击杀条件
  bool isMatchDefeatCondition() {
    return true;
  }

  //点击触发开始
  void onTapStart() {}

  //收到攻击
  void underAttacked({int damage, Color color}) {
    if (isDead) {
      return;
    }
    hits++;
    if (damage == null) {
      //10%浮动
      var isAdd = game.rnd.nextBool();
      var percent = 1;
      if (isAdd == false) {
        percent = -1;
      }
      var curRndAbs = game.rnd.nextInt((game.att * 0.1).toInt());
      damage = game.att + curRndAbs * percent;
    }
    curHp = curHp - damage;
    if (curHp <= 0) {
      curHp = 0;
    }
    if (isItem == false) {
      //伤害点击
      hitEffectDamage = new HitEffectScoreText(
          game,
          '-${damage.toString()}',
          new Offset(flyRect.left + flyRect.width / 2,
              flyRect.top - flyRect.height / 2),
          distance: game.tileSize * 1.0,
          color: color != null ? color : Colors.yellowAccent,fontSize: 30);
    }
  }

  void buffAttactDetect() {
    //判断当前用户拥有的技能buff并给上技能；
    if (game.userSkills.length > 0) {
      game.userMonster?.userSkillWatcher?.activeSkill(this);
    }
    //状态检测,睡眠中被打击可恢复
    if (canMove == false &&
        skills.any((c) => c.gameBuffType == GameBuffType.debuff_sleep)) {
      canMove = true;
      skills.removeWhere((c) => c.gameBuffType == GameBuffType.debuff_sleep);
    }
  }

  //增加技能或者buff
  Future addSkillOrBuff(GameSkill skill) async {
    if (isItem == true) return;
    //精英怪才有技能；
    var hitSkillCout =
        skills.where((c) => c.gameBuffType == skill.gameBuffType).length;
    //删除已有的技能；
    if (hitSkillCout >0) {
        skills.removeWhere((c) => c.gameBuffType == skill.gameBuffType);
    }
    
    skills.add(skill); //增加新的技能
    //buffWatcher.checkBuff(onlyImmediateSkill: true); //快速执行金额能够,只有立即执行的技能
    //立即执行技能呢
    if (skill.isImmediate && skill.isCDReady) {
      skill?.execSkill();
    }
  }

   
 
}
