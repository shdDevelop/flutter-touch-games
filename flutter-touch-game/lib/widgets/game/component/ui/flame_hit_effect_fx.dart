import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import '../../flame_Langaw_Game.dart';
import 'flame_hit_effect.dart';

//物体被打击特效,实现n个特效星星往外扩散
class HitEffectFX {
  final Monster fly;
  final String effectImgPath;
  LangawGame game;
  List<Sprite> effectSpriteList = new List<Sprite>(); //动画对象
  List<HitEffectItem> hitEffectItemList;
  HitEffectItem hitFXItem; //打击效果
  bool isHitFx = false; //打击效果存在时间
  double get speed => game.tileSize * 5; //速度单位
  final int duration;
  HitEffectFX(this.fly, {this.effectImgPath, this.duration}) {
    game = fly.game;
  }
  Rect initRectTemplate({bool isCopyFormFly = false}) {
    var width = game.tileSize * .75;
    var height = game.tileSize * .75;
    if (isCopyFormFly) {
      width = game.tileSize * 1.5;
      height = game.tileSize * 1.5;
      return Rect.fromLTWH(
        fly.flyRect.left + fly.flyRect.width / 2 - width / 2,
        fly.flyRect.top + fly.flyRect.height / 2 - height / 2,
        width,
        height,
      );
    } else {
      var rect = Rect.fromLTWH(
        fly.flyRect.left - height / 2,
        fly.flyRect.top - height / 2,
        width,
        height,
      );
      return rect;
    }
  }

  //初始化举行以及即将移动的位置
  void initRect() {
    //参数传入的打击效果
    if (effectImgPath != null) {
      hitFXItem = new HitEffectItem(initRectTemplate(isCopyFormFly: true),
          new Sprite(effectImgPath), null);
    } else {
      //打击效果
      var hitEffectSpritIndex =
          game.rnd.nextInt(game.resourceManager.hitEffectSpriteList.length);
      if (fly.comboHits > 0) {
        hitEffectSpritIndex =
            game.resourceManager.hitEffectSpriteList.length - 1; //最后一个为连打效果
      }
      var hitEffectSprite =
          game.resourceManager.hitEffectSpriteList[hitEffectSpritIndex];

      hitFXItem = new HitEffectItem(initRectTemplate(isCopyFormFly: true),
          new Sprite(hitEffectSprite), null);
    }
  }

  void render(Canvas c) {
    if (hitFXItem == null) {
      initRect();
    }
    //点击就会触发
    if (hitFXItem != null && isHitFx == false) {
      hitFXItem.sprite.renderRect(c, hitFXItem.rect); //当前图片
    }
  }

  void update(double t) {
    if (hitFXItem != null && isHitFx == false) {
      var curDuration = 100;
      if (duration != null) {
        curDuration = duration;
      }
      Future.delayed(new Duration(milliseconds: curDuration)).then((_) {
        isHitFx = true;
      });
    }
  }
}
