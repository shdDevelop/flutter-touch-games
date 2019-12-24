import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:mz_flutterapp_deep/widgets/game/component/monster/boss/flame_monster_boss.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';

import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

//血条特效置于 上方的boss 血条，boss出现才有的血条
class BossHPEffect {
  final Monster monster;
  Rect rectBg1;
  Rect rectBg2;
  Rect rectBg3;
  Rect rectBossUI;
  Sprite spriteBg1;
  Sprite spriteBg2;
  Sprite spriteBg3;
  Sprite bossUI;
  double hpHeight;
  bool hasLife;
  TextPainter tp;
  TextStyle textStyle;
  Offset textOffset;

  BossHPEffect(this.monster,{double height,bool hasLifeCount=true}) {
    hpHeight = height!=null?height:monster.game.tileSize * 0.8;
    spriteBg1 = Sprite('game/expert_bar_bg.png'); //背景
    spriteBg3 = Sprite('game/hp_yellow_small.png');//最外层
    spriteBg2 = Sprite('game/hp_red_small.png'); //中间曾
    bossUI = Sprite('game/ui_boss.png');
    hasLife=hasLifeCount;
    // spriteYellow = Sprite('game/hp_yellow_small.png');
    tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: 20,
    );
  }

  //rect模板
  Rect rectTemplate({double widthDeflate = 1}) {
    if (widthDeflate <= 0) {
      widthDeflate = 0;
    }
    var hpWidth = monster.game.screenSize.width*0.8;
    var rect = Rect.fromLTWH(
        (monster.game.tileSize * 1),
       monster.game.tileSize *1.8,
      hpWidth * widthDeflate,
      hpHeight,
    );
    return rect;
  }

  Rect rectTemplateByWidth(double width) {
    var rect = Rect.fromLTWH(
       (monster.game.tileSize * 1),
       monster.game.tileSize *1.8,
      width,
      hpHeight,
    );
    return rect;
  }

  void render(Canvas c) {
    if (monster.game.activeView != View.playing || monster.flyRect == null) {
      return;
    }

    if (rectBg1 != null) {
      spriteBg1.renderRect(c, rectBg1); //背景图1

    }
     
    if (hasLife&&textOffset != null && monster.lives > 1) {
      tp.paint(c, textOffset);
    }
    if (rectBg2 != null) {
      spriteBg2.renderRect(c, rectBg2); //背景图3
    }
    if (rectBg3 != null) {
      spriteBg3.renderRect(c, rectBg3); //背景图3
    }
    if (rectBossUI != null&&monster is BossMonster) {
      bossUI.renderRect(c, rectBossUI); //boss头像
    }
  }

  void update(double t) {
    if (monster.game.activeView != View.playing || monster.flyRect == null) {
      return;
    }

    //血条位置
    //对话框位置
    rectBg1 = rectTemplate();
    var bossUIWidth = monster.game.tileSize * 1;
    rectBossUI = Rect.fromLTWH(
        rectBg1.left -monster.game.tileSize, rectBg1.top+rectBg1.height/8-bossUIWidth/4, bossUIWidth, bossUIWidth);

    var loseHpPercent = (monster.initHp - monster.curHp) /
        monster.initHp; //monster.hits*monster.game.att / monster.hp
    rectBg3 = rectTemplate(widthDeflate: (1 - loseHpPercent)); //最终宽度
    if (rectBg2 == null) {
      rectBg2 = rectTemplateByWidth(rectBg3.width); //宽度慢慢减少
    } else {
      var width = rectBg2.width;
      if (width > rectBg3.width) {
        width -= 0.005 * width;
        rectBg2 = rectTemplateByWidth(width); //宽度慢慢减少
      } else {
        rectBg2 = rectTemplateByWidth(rectBg3.width); //宽度慢慢减少
      }
    }
    if (hasLife&&monster.lives > 1 && rectBg1 != null) {
      //剩余生命位置
      tp.text = new TextSpan(text: 'X${monster.lives}', style: textStyle);
      tp.layout();
      //对话框文本内容位置
      textOffset = Offset(
        rectBg1.left + rectBg1.width +monster.game.tileSize*0.1,
        rectBg1.top + rectBg1.height/12,
      );
    }
  }
}
