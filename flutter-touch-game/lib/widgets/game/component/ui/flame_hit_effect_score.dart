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
import 'util/flame_text_display.dart';

//点击物体后数值上升效果 可用于得分 伤害值展示，等其他
//物体被打击特效
class HitEffectScoreText {
  final LangawGame game;
  final String text;
  final Offset scorePosition;
  final double distance;
  final Color color;
   final double fontSize;
  TextDisplay scoreEffectTextDisplay; //获得的分数上升并消失动画效果；
  bool isScoreComplete = false;
  Offset scoreEffectTargetOffset;
  double get speed => game.tileSize * 2.5; //速度单位
  GameTextStyle gameTextStyle = new GameTextStyle();
  HitEffectScoreText(this.game, this.text, this.scorePosition, {this.distance,this.color,this.fontSize});

  //初始化举行以及即将移动的位置
  void initRect() {
    if (scorePosition != null) {
      //初始化得分对象
      var scoreOffset =
          new Offset(scorePosition.dx - game.tileSize * 0.2, scorePosition.dy);
      //上升移动的距离
      var targetOffset = distance == null ? game.tileSize * 1 : distance;
      scoreEffectTargetOffset =
          new Offset(scoreOffset.dx, scoreOffset.dy - targetOffset);
      scoreEffectTextDisplay = new TextDisplay("$text",
          color: color,
          fontSize: fontSize==null?20:fontSize,
          game: game,
          position: scoreOffset);
    }
  }

  void render(Canvas c) {
    //初始化rect
    if (scoreEffectTextDisplay == null) {
      initRect();
    }
    //展示得分上升画面
    if (isScoreComplete == false && scoreEffectTextDisplay != null) {
      scoreEffectTextDisplay.render(c);
    }
  }

  void update(double t) {
    if (isScoreComplete == false && scoreEffectTextDisplay != null) {
      textDisplaToTarget(scoreEffectTextDisplay, t, scoreEffectTargetOffset,
          speedEnhence: 1);
      scoreEffectTextDisplay.update(t);
    }
  }

  //得分向上移动
  void textDisplaToTarget(TextDisplay textDisplay, double t, Offset target,
      {double speedEnhence = 1}) {
    if (target == null) return;
    double stepDistance = speed * t * speedEnhence;
    Offset toTarget = target - new Offset(target.dx, textDisplay.position.dy);
    if (toTarget.distance > stepDistance) {
      textDisplay.position = new Offset(
          textDisplay.position.dx, textDisplay.position.dy - stepDistance);
    } else {
      textDisplay.position = new Offset(target.dx, target.dy);
      isScoreComplete = true;
    }
  }
}
