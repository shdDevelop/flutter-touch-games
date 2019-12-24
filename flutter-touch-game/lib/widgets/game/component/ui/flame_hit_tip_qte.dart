import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_text_style.dart';
import '../../flame_Langaw_Game.dart';
import 'util/flame_rect_display.dart';
import 'util/flame_text_display.dart';

//点击提示QTE
class HitTipQTE {
  LangawGame game;
  final Monster monster;

  List<Sprite> tipSpriteList;
  double lightSpriteIndex = 0.0;
  double changeInterval = 1;
  Rect rect;
  double get speed => 30; //速度单位
  HitTipQTE(this.monster) {
    game = monster.game;
    tipSpriteList = new List<Sprite>();
    tipSpriteList.add(new Sprite("game/ui_touchscreen_icon_01.png"));
    tipSpriteList.add(new Sprite("game/ui_touchscreen_icon_02.png"));
  }

  void render(Canvas c) {
    if (rect == null) return;
    tipSpriteList[lightSpriteIndex.toInt()].renderRect(c, rect);
  }

  void update(double t) {
    lightSpriteIndex += 30 * t / 5;
    if (lightSpriteIndex >= tipSpriteList.length) {
      lightSpriteIndex = 0;
    }
    rect = Rect.fromLTWH(
      monster.flyRect.left ,
      monster.flyRect.top,
      monster.game.tileSize * 2,
      monster.game.tileSize * 2,
    );
  }
}
