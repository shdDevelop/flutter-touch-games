import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/utils/sp_util.dart';
import 'dart:math' as Math;
import '../../flame_Langaw_Game.dart';

//单个星星效果
class RectSpriteItem {
  RectSpriteItem(Rect _rect, Sprite _sprite) {
    rect = _rect;
    sprite = _sprite;
  }
  Offset targetOffset;
  Rect rect;
  Sprite sprite;
}

//combo位置，动态生成连击背景图，粒子效果，目前废弃
class HitCombo_System {
  final LangawGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  List<RectSpriteItem> bGFonterSprites; //前置背景
  List<RectSpriteItem> bGNextSprites; //后置背景
  Sprite fonterBgSprite;
  Sprite nextBgSprite;
  
  Rect comboRect;
  HitCombo_System(this.game) {
    fonterBgSprite =
        new Sprite('game/fx_combo_1.png', x: 0, y: 0, width: 90, height: 100);
    nextBgSprite =
        new Sprite('game/fx_combo_1.png', x: 90, y: 0, width: 90, height: 100);
    //combo
    comboRect = Rect.fromLTWH(game.screenSize.width / 2 - game.tileSize * 2,
        game.tileSize * 2, game.tileSize * 2, game.tileSize * 2);
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
        color: Colors.yellow,
        fontSize: 50,
        shadows: [shadow, shadow, shadow, shadow]);
    position = Offset.zero;
  }

  //获取随机位置随机不同个角度
  Offset getTargetOffset(Rect rect, {double angle, double additional = 1}) {
    var distance = (1 + game.rnd.nextDouble()) * game.tileSize * additional * 2;

    var x = (rect.left + rect.width / 2);
    var y = (rect.top + rect.height / 2);
    double offsetX = 0;
    double offsetY = 0;
    if (angle != null) {
      offsetX += distance * Math.sin(angle);
      offsetY += distance * Math.cos(angle);
      x += offsetX;
      y += offsetY;
    }
    return Offset(x, y);
  }

  //初始化单个圆形背景,根据传入位置生成背景,生成一个随机背景图片举行,中间大周边小
  RectSpriteItem initRectStriteItem(Offset p, Sprite sprite,
      {int itemCount = 1, double additional = 0.1}) {
    if (additional <= 0) {
      additional = 0.1;
    }
    var size = comboRect.width * comboRect.height / itemCount;
    var rndDouble = (game.rnd.nextDouble() * (1+additional));
    var height = (rndDouble) * Math.sqrt(size);
    var width = (rndDouble) * Math.sqrt(size);
    var rect = Rect.fromLTWH(
      p.dx,
      p.dy,
      height,
      width,
    );
    var spriteItem = new RectSpriteItem(rect, sprite);
    return spriteItem;
  }

  //初始化背景
  void initFonterBackGround() {
    var itemCount = 30;
    double angle = 0;
    var angelAbstract = 360 / itemCount;
    double additional = 0.1;
    double rectSizeAdditional =3;
    bGFonterSprites = new List<RectSpriteItem>();
    for (var i = 0; i < itemCount; i++) {
      var targetOffset =
          getTargetOffset(comboRect, angle: angle, additional: additional);
      var curRectSpriteItem = initRectStriteItem(targetOffset, fonterBgSprite,
          itemCount: itemCount,additional: rectSizeAdditional);
      bGFonterSprites.add(curRectSpriteItem);
      angle += angelAbstract;
      if (angle >= 360) {
        angle = 0;
        additional += 2/itemCount;
        rectSizeAdditional -= 3/itemCount;
      }
    }
  }
  //初始化背景
  void initNextBackGround() {
    var itemCount = 15;
    double angle = 0;
    var angelAbstract = 360 / itemCount;
    double additional = 0.1;
    double rectSizeAdditional =2;
    bGNextSprites = new List<RectSpriteItem>();
    for (var i = 0; i < itemCount; i++) {
      var targetOffset =
          getTargetOffset(comboRect, angle: angle, additional: additional);
      var curRectSpriteItem = initRectStriteItem(targetOffset, nextBgSprite,
          itemCount: itemCount,additional: rectSizeAdditional);
      bGFonterSprites.add(curRectSpriteItem);
      angle += angelAbstract;
      if (angle >= 360) {
        angle = 0;
        additional += 2/itemCount;
        rectSizeAdditional -= 3/itemCount;
      }
    }
  }

  void render(Canvas c) {
    
    if (bGNextSprites == null) {
      initNextBackGround();
    }
    if (bGFonterSprites == null) {
      initFonterBackGround();
    }
    for (var rectItem in bGFonterSprites) {
      rectItem.sprite.renderRect(c, rectItem.rect);
    }
    for (var rectItem in bGNextSprites) {
      rectItem.sprite.renderRect(c, rectItem.rect);
    }
    painter.paint(c, position);
  }

  void update(double t) {
    updateCombo();
  }

  void updateCombo() {
    painter.text = TextSpan(
      text: game.combo.toString(),
      style: textStyle,
    );
    painter.layout();
    position = Offset(
      comboRect.top + comboRect.height / 2,
      comboRect.left + comboRect.width / 2,
    );
  }
}
