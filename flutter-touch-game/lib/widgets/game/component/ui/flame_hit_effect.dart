import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_text_style.dart';
import 'dart:math' as Math;
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../flame_Langaw_Game.dart';
import 'flame_hit_effect_score.dart';
import 'util/flame_text_display.dart';

//单个星星效果
class HitEffectItem {
  HitEffectItem(Rect _rect, Sprite _sprite, Offset _targetOffset) {
    rect = _rect;
    sprite = _sprite;
    targetOffset = _targetOffset;
  }
  Offset targetOffset;
  Rect rect;
  Sprite sprite;
}

//物体被打击特效,实现n个特效星星往外扩散
class HitEffect {
  final Monster fly;
  LangawGame game;
  // List<Rect> rectList;
  // List<Offset>targetOffSetList=new List<Offset>();
  int effectHitCount; //星星个数
  List<Sprite> effectSpriteList = new List<Sprite>(); //动画对象
  List<HitEffectItem> hitEffectItemList;
  HitEffectItem flyEffectItem; //获得的物品；
  HitEffectScoreText hitEffectScore;
 
  bool isCompleted = false;
  bool isItemComplete = false;
  bool isHitFx = false; //打击效果存在时间
  double get speed => game.tileSize * 5; //速度单位
  GameTextStyle gameTextStyle = new GameTextStyle();
  HitEffect(this.fly) {
    game = fly.game;
    //初始化星星sprite
    for (var spritePath in game.resourceManager.boundSpriteList) {
      effectSpriteList.add(Sprite(spritePath));
    }
    effectHitCount = game.rnd.nextInt(15);
    if (effectHitCount < 5) {
      effectHitCount = 5;
    }
  }
  Rect initRectTemplate({bool isCopyFormFly = false}) {
    if (isCopyFormFly) {
      return Rect.fromLTWH(
        fly.flyRect.left,
        fly.flyRect.top,
        fly.flyRect.width,
        fly.flyRect.height,
      );
    } else {
      var rect = Rect.fromLTWH(
        fly.flyRect.left,
        fly.flyRect.top,
        game.tileSize * .75,
        game.tileSize * .75,
      );
      return rect;
    }
  }

  //初始化举行以及即将移动的位置
  void initRect() {
    hitEffectItemList = new List<HitEffectItem>();
    double angleAbstract = 360.0 / effectHitCount; //角度方差
    double angle = 0;
    for (var index = 0; index <= effectHitCount - 1; index++) {
      var rectTemplate = initRectTemplate();
      var targetOffset = getTargetLocation(rectTemplate, angle: angle); //角度偏移
      var spriteIndex = game.rnd.nextInt(effectSpriteList.length);
      var sprite = effectSpriteList[spriteIndex];
      var newHitEffectItem =
          new HitEffectItem(rectTemplate, sprite, targetOffset);
      hitEffectItemList.add(newHitEffectItem);
      angle += angleAbstract;
    }
    var flyRectTemplate = initRectTemplate(isCopyFormFly: true);

    if (fly != null &&
        fly.flyingSprite.length > 0 &&
        fly.rare != ItemRare.normal) {
      flyEffectItem = new HitEffectItem(flyRectTemplate, fly.flyingSprite[0],
          getTargetLocation(flyRectTemplate));
    }
    if (fly != null) {
      //初始化得分对象
      hitEffectScore = new HitEffectScoreText(
          game,
          '+${fly.getFinalScore().toString()}',
          new Offset(flyRectTemplate.left + flyRectTemplate.width / 2,
              flyRectTemplate.top + flyRectTemplate.height / 2));
  
    }
  }

  void render(Canvas c) {
    //初始化rect
    if (hitEffectItemList == null) {
      initRect();
    }
    if (fly.isDead) {
      //显示在界面上
      if (hitEffectItemList != null && isCompleted == false) {
        var index = 0;
        for (var effectItem in hitEffectItemList) {
          index++;
          effectItem.sprite.renderRect(c, effectItem.rect); //背景图
        }
      }
      //展示得分上升画面
      if (hitEffectScore != null) {
        hitEffectScore.render(c);
      }
      
    }
    // if (flyEffectItem != null && isItemComplete == false && isHitFx == true) {
    //   flyEffectItem.sprite.renderRect(c, flyEffectItem.rect); //当前获得物品
    // }
  }

  //获取随机位置随机不同个角度
  Offset getTargetLocation(Rect rect, {double angle}) {
    var game = fly.game;
    var offset_distinct = (1 + game.rnd.nextDouble()) * game.tileSize * 2;
    var x = (rect.left + rect.width / 2);
    var y = (rect.top + rect.height / 2);
    double offsetX = 0;
    double offsetY = 0;
    if (angle != null) {
      offsetX += offset_distinct * Math.sin(angle);
      offsetY += offset_distinct * Math.cos(angle);
      x += offsetX;
      y += offsetY;
    }
    return Offset(x, y);
  }

  void update(double t) {
    if (hitEffectItemList == null) return;

    if (isCompleted == false) {
      var index = 0;
      for (var hitEffectItem in hitEffectItemList) {
        flyToTarget(hitEffectItem, t, hitEffectItem.targetOffset,
            speedEnhence: 1);
        index++;
        hitEffectItem.rect = hitEffectItem.rect.inflate(-0.3); //越来越小
      }
    }

    //展示得分上升画面
    hitEffectScore?.update(t);
  }

  //移动到指定位置
  void flyToTarget(HitEffectItem effectItem, double t, Offset target,
      {Function nextTarget, double speedEnhence = 1}) {
    if (target == null) return;

    double stepDistance = speed * t * speedEnhence;
    Offset toTarget =
        target - new Offset(effectItem.rect.left, effectItem.rect.top);
    if (toTarget.distance > stepDistance) {
      Offset stepToTarget =
          Offset.fromDirection(toTarget.direction, stepDistance);
      effectItem.rect = effectItem.rect.shift(stepToTarget);
    } else {
      effectItem.rect = effectItem.rect.shift(toTarget);
      isCompleted = true;
      Future.delayed(new Duration(seconds: 2)).then((_) {
        isItemComplete = true;
      });
    }
  }
}
