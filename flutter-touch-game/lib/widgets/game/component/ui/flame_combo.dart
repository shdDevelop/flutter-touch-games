import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/utils/sp_util.dart';
import 'dart:math' as Math;
import '../../flame_Langaw_Game.dart';

//combo位置，多个圆圈背景作为背景
class HitCombo {
  final LangawGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  double comboSpriteIndex = 0;
  List<Sprite> redComboSpriteList;
  List<Sprite> blueComboSpriteList;
  final int maxSpawnInterval = 300;
  final int minSpawnInterval = 200; //默认250
  final int intervalChange = 3;
  int currentInterval;
  int nextSpawn;

  Rect comboRect;
  HitCombo(this.game) {
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;

    initialSprite();
    //combo
    comboRect = Rect.fromLTWH(game.screenSize.width / 2 - game.tileSize * 3/2,
        game.tileSize * 2.4, game.tileSize * 3, game.tileSize * 3);
    //文字
    painter = new TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    Shadow shadow = Shadow(
      blurRadius: 3,
      color: Color(0xff000000),
      offset: Offset.zero,
    );
    textStyle = new TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w900,
        color: Colors.yellow[300],
        fontSize: 30,
        shadows: [shadow, shadow, shadow, shadow]);
    position = Offset.zero;
  }
  //初始化sprite
  void initialSprite() {
    redComboSpriteList = new List<Sprite>();
    for (var spritePath in game.resourceManager.comboRedSpriteList) {
      redComboSpriteList.add(new Sprite(spritePath));
    }
    blueComboSpriteList = new List<Sprite>();
    for (var spritePath in game.resourceManager.comboBlueSpriteList) {
      blueComboSpriteList.add(new Sprite(spritePath));
    }
  }

  void render(Canvas c) {
    if (game.combo > 50) {
      redComboSpriteList[comboSpriteIndex.toInt()].renderRect(c, comboRect);
    } else {
      blueComboSpriteList[comboSpriteIndex.toInt()].renderRect(c, comboRect);
    }

    painter.paint(c, position);
  }

  void update(double t) {
    //轮询帧动画
    //  comboSpriteIndex += 30 * t;
    // if (comboSpriteIndex >= comboSpriteList.length) {
    //   comboSpriteIndex = 0;
    // }
    changeNextSprite();
    updateCombo();
  }

  //每n秒执行一次
  void changeNextSprite() {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp > nextSpawn) {
      comboSpriteIndex = (comboSpriteIndex + 1) % redComboSpriteList.length;

      //时间判定每5秒生成一只
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = nowTimestamp + currentInterval;
    }
  }

  void updateCombo() {
    var comboText =
        game.combo < 10 ? "0" + game.combo.toString() : game.combo.toString();
    painter.text = TextSpan(
      text: comboText,
      style: textStyle,
    );
    painter.layout();
    position = Offset(
      comboRect.left + comboRect.width / 2 - game.tileSize * 0.6,
      comboRect.top + comboRect.height / 2 - game.tileSize * 0.6,
    );
  }
}
