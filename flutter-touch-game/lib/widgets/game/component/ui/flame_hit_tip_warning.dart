import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_text_style.dart';
import '../../flame_Langaw_Game.dart';
import 'util/flame_rect_display.dart';
import 'util/flame_text_display.dart';

//点击提示QTE
class HitTipWarning {
  LangawGame game;
  final Monster monster;
  RectDisplay rectDisplay; //获得的分数上升并消失动画效果；
  List<Sprite> tipSpriteList;
  double curTipSpriteIndex = 0.0;
  double get speed => 3; //速度单位

  HitTipWarning(this.monster) {
    game = monster.game;
    tipSpriteList = new List<Sprite>();
    tipSpriteList.add(new Sprite("game/ui_tip_01.png"));
    tipSpriteList.add(new Sprite("game/ui_tip_02.png"));
  }

  void render(Canvas c) {
    if (rectDisplay == null) return;
    rectDisplay?.render(c);
  }

  void update(double t) {
    curTipSpriteIndex += 30 * t / 5;
    if (curTipSpriteIndex >= tipSpriteList.length) {
      curTipSpriteIndex = 0;
    }
    var rect = Rect.fromLTWH(
      monster.flyRect.left + ( monster.flyRect.width/2)- monster.game.tileSize/2,
      monster.flyRect.top - monster.game.tileSize * 1.3,
      monster.game.tileSize * 1,
      monster.game.tileSize * 1,
    );
    rectDisplay = new RectDisplay(game,
        rect: rect, sprite: tipSpriteList[curTipSpriteIndex.toInt()]);
    rectDisplay.update(t);
  }
}
