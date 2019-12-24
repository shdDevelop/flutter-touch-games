import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import '../../flame_Langaw_Game.dart';
import 'flame_hit_effect.dart';
import 'flame_hit_effect_fx.dart';

//点击丢失特效
class HitEffectMiss {
  final Offset touchPoint;
  HitEffectItem hitFXItem; //打击效果
  final LangawGame game;
  HitEffectFX curHitEffectFx;
  bool isHitFx=false;
  double get speed => game.tileSize * 5; //速度单位
   int duration=300;
  HitEffectMiss({this.game,this.touchPoint}) {
     var width=game.tileSize*1.5;
 // var rect=Rect.fromCenter(center:touchPoint,width:game.tileSize*1,height:game.tileSize*1);
    var rect=Rect.fromLTWH(touchPoint.dx-width/2, touchPoint.dy-width/2, width, width);
    hitFXItem = new HitEffectItem(rect,
          new Sprite("game/fx_hit_miss.png"), null);
  }
  void render(Canvas c) {
    if (hitFXItem == null) {
    
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
