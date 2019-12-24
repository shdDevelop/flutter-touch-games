import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_text_style.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import '../../flame_Langaw_Game.dart';
import 'util/flame_rect_display.dart';
import 'util/flame_text_display.dart';

//boss入场警告,背景
class EntranceWarning {
  final Monster monster;
   LangawGame game;
  RectDisplay warningTop; //top警告
  RectDisplay warningBottom; //bottom警告
  RectDisplay centerBBg; //魔
  RectDisplay centerOBg; //王
  RectDisplay monsterProfile; //获得的分数上升并消失动画效果；
  bool isComplete = false;
  int showWarningElapse = 1; //显示一秒
  Offset topRectTargetOffst;
  Offset bottomRectTargetOffst;
  double get speedEnhence => 2; //速度单位
  double margin;
  double warningHeight;
  double warningWidth;
  Sprite warningSprite = new Sprite('game/ui_boss_warning_cn.png');
  Sprite centerSpriteB = new Sprite('game/ui_bosstxt_B.png');
  Sprite centerSpriteO = new Sprite('game/ui_bosstxt_O.png');
  EntranceWarning(this.monster) {
    game=monster.game;
    initRect();
    game.audioplayers.warning();
  }
  void initTopRectDispay() {
    //顶部warning
    var topRect = Rect.fromLTWH(0, margin, warningWidth, warningHeight);
    warningTop = new RectDisplay(game, rect: topRect, sprite: warningSprite);
    topRectTargetOffst = getTopNextTarget(topRect);
  }

  void initBottomRectDispay() {
    //底部warning
    var bottomRect = Rect.fromLTWH(
        game.screenSize.width - warningWidth,
        game.screenSize.height - warningHeight - margin,
        warningWidth,
        warningHeight);
    warningBottom =
        new RectDisplay(game, rect: bottomRect, sprite: warningSprite);
    bottomRectTargetOffst = getBottomNextTarget(bottomRect);
  }
   void initMonsterRectDispay() {
    //底部warning
    var monsterRect = Rect.fromLTWH(
        game.screenSize.width/2-monster.flyRect.width/2,
        game.screenSize.height/4 - monster.flyRect.height/2,
        monster.flyRect.width,
         monster.flyRect.height);
    monsterProfile =
        new RectDisplay(game, rect: monsterRect, sprite: monster.flyingSprite[0]);
   }

  //初始化举行以及即将移动的位置
  void initRect() {
    margin = game.tileSize * 2;
    warningHeight = game.tileSize;
    warningWidth = game.tileSize * 4; //game.screenSize.width;
    initTopRectDispay();
    initBottomRectDispay();
    initMonsterRectDispay();
    //中间壁纸
    // var cemterRectHeight =
    //     game.screenSize.height - 2 * (margin + warningHeight);
    var centerRectHeight =game.tileSize*1;
    var centerRectWidth=game.tileSize*1;
    var centerRectB = Rect.fromLTWH(game.tileSize*2, game.screenCenterY/2 - centerRectHeight / 2,
        centerRectWidth, centerRectHeight);
    centerBBg = new RectDisplay(game, rect: centerRectB, sprite: centerSpriteB);


    
    var centerRectO = Rect.fromLTWH(game.screenSize.width-game.tileSize*2-centerRectWidth, game.screenCenterY/2 - centerRectHeight / 2,
        centerRectWidth, centerRectHeight);
    centerOBg = new RectDisplay(game, rect: centerRectO, sprite: centerSpriteO);

  }

  void render(Canvas c) {
    if (game.activeView != View.playing) {
      return;
    }
    if (isComplete == false) {
      centerBBg?.render(c);
      centerOBg?.render(c);
      warningTop?.render(c);
      warningBottom?.render(c);
      monsterProfile?.render(c);
    }
  }

  Offset getTopNextTarget(Rect rect) {
    return new Offset(game.screenSize.width, rect.top);
  }

  Offset getBottomNextTarget(Rect rect) {
    return new Offset(-warningWidth, rect.top);
  }

  void update(double t) {
    if (game.activeView != View.playing) {
      return;
    }
    if (isComplete == false) {
      warningTop?.update(t);
      warningBottom?.update(t);
      monsterProfile?.update(t);
      warningTop.moveToTarget(t, topRectTargetOffst, speedEnhence: speedEnhence,
          onArrived: () {
        initTopRectDispay();
      });
      warningBottom.moveToTarget(t, bottomRectTargetOffst,
          speedEnhence: speedEnhence, onArrived: () {
        initBottomRectDispay();
      });
    }
  }
}
