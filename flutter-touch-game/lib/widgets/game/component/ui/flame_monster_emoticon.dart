import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_text_style.dart';
import '../../flame_Langaw_Game.dart';
import 'util/flame_rect_display.dart';
import 'util/flame_text_display.dart';

//随机表情
class MonsterEmoticon {
  LangawGame game;
  final Monster monster;
  RectDisplay bgRectDisplay;
  RectDisplay emotiRectDisplay;
  Sprite bgSprite;
  Sprite emoticonSprite;
  double changeTime = 0.5; //10秒变换一次
  double interval = 1; //间隔展示10秒
  int emoiIndex;
  bool hasEmoi = false;
  MonsterEmoticon(this.monster) {
    game = monster.game;
    bgSprite = new Sprite("game/emoticon.png");
    //随机表情
  }

  void render(Canvas c) {
    if (!hasEmoi) {
      return;
    }
    if (bgRectDisplay == null || emotiRectDisplay == null) return;
    bgRectDisplay?.render(c);
    emotiRectDisplay?.render(c);
  }

  void update(double t) {
    var rect = Rect.fromLTWH(
      monster.flyRect.right +
          (monster.flyRect.width / 2) -
          monster.game.tileSize* 1.5,
      monster.flyRect.top - monster.game.tileSize * 2,
      monster.game.tileSize * 1.5,
      monster.game.tileSize * 1.5,
    );
    var spriteRect = Rect.fromLTWH(
      rect.left+monster.game.tileSize/4,
      rect.top+monster.game.tileSize/4,
      monster.game.tileSize * 1.5,
      monster.game.tileSize * 1.5,
    );
    changeTime = changeTime - .1 * t;
    interval = interval - .1 * t;
    if (interval <= 0) {
      if(hasEmoi==false)
      {
        interval = 0.3;
      }else{
        interval=1;
      }
      hasEmoi = !hasEmoi;
    }

    //计时器结束，
    if (changeTime <= 0) {
      changeTime = 2;
      emoiIndex = game.rnd
          .nextInt(game.resourceManager.monsterEmoticonSpriteList.length);
    }
    if (!hasEmoi) {
      return;
    }
    emoticonSprite = game.resourceManager.monsterEmoticonSpriteList[emoiIndex];
    bgRectDisplay = new RectDisplay(game, rect: rect, sprite: bgSprite);
    bgRectDisplay.update(t);

    emotiRectDisplay =
        new RectDisplay(game, rect: spriteRect, sprite: emoticonSprite);
    emotiRectDisplay.update(t);
  }
}
