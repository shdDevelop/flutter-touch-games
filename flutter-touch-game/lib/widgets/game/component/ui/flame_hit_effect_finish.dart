import 'dart:ui';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import '../../flame_Langaw_Game.dart';
import 'util/flame_animation_display.dart';

///实现终结画面，怪物慢慢变大然后爆炸
class HitEffectFinish {
  final Monster fly;
  final Function callback;
  LangawGame game;
  List<Sprite> effectSpriteList = new List<Sprite>(); //动画对象
  double inflateValue = -10; //增加两倍后爆炸
  double curInflateValue = -0.3;
  SpriteComponent boomEffect;
  AnimationDisplay boomDisplay; //sprite 动画，需要再最外层否则可能出现折叠情况

  bool isfinished = false;
  HitEffectFinish(this.fly, {this.callback}) {
    game = fly.game;
    boomDisplay = new AnimationDisplay(
        game, game.resourceManager.finishEffectSpriteList[0], 5,
        offset: Offset(fly.flyRect.left - fly.flyRect.width / 6,
            fly.flyRect.top - fly.flyRect.height / 6),
        width: fly.flyRect.width / 2,
        height: fly.flyRect.height / 2,textureWidth: 43);
    game.animationDisplayList.add(boomDisplay);
  }

  void render(Canvas c) {
    //boomDisplay?.render(c);
  }

  void update(double t) {
    // boomDisplay?.update(t);
    curInflateValue += curInflateValue * (game.rnd.nextInt(3));
    //fly.flyRect = fly.flyRect.inflate(curInflateValue);
    if (curInflateValue <= inflateValue && isfinished == false) {
      isfinished = true;
      Future.delayed(Duration(milliseconds: 1000)).then((_) {
        if (callback != null) {
          boomDisplay.destory();
         callback();
        }
      });
    }
  }
}
