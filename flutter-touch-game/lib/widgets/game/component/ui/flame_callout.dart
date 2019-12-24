import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';

import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
//对话框怪物定时器，当数值为0则失败消失
class Callout {
  final Monster fly;
  Rect rect;
  Sprite sprite;
  double value;
  TextPainter tp;
  TextStyle textStyle;
  Offset textOffset;

  Callout(this.fly) {
    sprite = Sprite('game/ui/callout.png');
    value = 2;//10秒
    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: 15,
    );
  }
  void render(Canvas c) {
    if(rect!=null){
    sprite.renderRect(c, rect);//背景图
    tp.paint(c, textOffset);
    }
    
  }

  void update(double t) {
    if (fly.game.activeView == View.playing) {
      value = value - .1 * t;
      //计时器结束，
      if (value <= 0) {
        fly.isCallout=true;
        fly.isDead=true;
        //fly.game.changeView(View.lost);
      }
    }
    //文本内容
     tp.text = new TextSpan(text: (value * 10).toInt().toString(), style: textStyle);
     //对话框位置
      rect = Rect.fromLTWH(
        fly.flyRect.left - (fly.game.tileSize * .25),
        fly.flyRect.top - (fly.game.tileSize * .5),
        fly.game.tileSize * .75,
        fly.game.tileSize * .75,
      );
      tp.layout();
      //对话框文本内容位置
      textOffset = Offset(
        rect.center.dx - (tp.width / 2),
        rect.top + (rect.height * .4) - (tp.height / 2),
      );
     
  }
}
