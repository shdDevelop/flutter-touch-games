import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';

import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import 'util/flame_text_display.dart';

//boss连打特效
class MonsterComboHitsEffect {
  final Monster fly;
  TextDisplay textDisplay;
  Offset position;
  Sprite sprite;
  Rect rect;
  MonsterComboHitsEffect(this.fly) {
    sprite = Sprite('game/HitsBase.png');
  }

  void render(Canvas c) {
    if (fly.isDead || fly.flyRect == null) {
      return;
    }

    if (position == null && rect != null) {
      position = Offset(rect.left + rect.width / 2,
          rect.top + rect.height / 2 - fly.game.tileSize * 0.5);
    }
    //连打模式
    if (rect != null) {
      sprite.renderRect(c, rect); //背景图
    }
    if (textDisplay != null) {
      textDisplay.render(c);
    }
  }

  void update(double t) {
    if (fly.isDead) {
      return;
    }
    if (fly.flyRect == null) {
      return;
    }
    textDisplay = new TextDisplay(fly.comboHits.toString(),
        game: fly.game, position: position, fontSize: 24);
    textDisplay?.update(t);
    if (fly.comboHits == 0) {
      if (rect != null) {
        rect = null;
      }
      if (position != null) {
        position = null;
      }
    } else {
      //对话框位置
      rect = Rect.fromLTWH(
        fly.flyRect.left - (fly.game.tileSize * 1),
        fly.flyRect.top - (fly.game.tileSize * 3),
        fly.game.tileSize * 1.5 * (1 + fly.comboHits / 20),
        fly.game.tileSize * 1.5 * (1 + fly.comboHits / 20),
      );
      position = Offset(rect.left + rect.width / 2,
          rect.top + rect.height / 2 - fly.game.tileSize * 0.5);
    }
  }
}
