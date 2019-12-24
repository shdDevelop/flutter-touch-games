import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/boss/flame_monster_boss.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/monster/flame_monster.dart';

import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

//血条特效
class MonsterMPEffect {
  final Monster monster;
  Rect rectBg1;
  Rect rectBg2;

  Rect rectSkillUI;
  Sprite spriteBg1;
  Sprite spriteBg2;
  Sprite spriteFever;

  Sprite skillUI;
  double hpHeight;
  bool isFever = false;

  MonsterMPEffect(this.monster, {double height}) {
    hpHeight = height != null ? height : monster.game.tileSize * 0.1;
    spriteBg1 = Sprite('game/expert_bar_bg.png'); //背景
    spriteBg2 = Sprite('game/loading_bar.png');
    skillUI = Sprite('game/Fever.png');
    spriteFever = Sprite('game/loading_bar_fever.png');
  }

   //rect模板
  Rect rectTemplate({double widthDeflate = 1}) {
    if (widthDeflate <= 0) {
      widthDeflate = 0;
    }
    var hpWidth = monster.flyRect.width ;
    var rect = Rect.fromLTWH(
      monster.flyRect.left + (monster.game.tileSize * .05),
      monster.hpEffect.rectBg1.top- monster.hpEffect.rectBg1.height,
      hpWidth * widthDeflate,
      hpHeight,
    );
    return rect;
  }

  Rect rectTemplateByWidth(double width) {
    var rect = Rect.fromLTWH(
      monster.flyRect.left + (monster.game.tileSize * .05),
      monster.hpEffect.rectBg1.top- monster.hpEffect.rectBg1.height,
      width,
      hpHeight,
    );
    return rect;
  }

  void render(Canvas c) {
    if (monster.game.activeView != View.playing || monster.flyRect == null||monster.hpEffect==null) {
      return;
    }

    if (rectBg1 != null) {
      spriteBg1.renderRect(c, rectBg1); //背景图1

    }

    if (rectBg2 != null) {
      if (isFever) {
        spriteFever.renderRect(c, rectBg2); //背景图3
      } else {
        spriteBg2.renderRect(c, rectBg2); //背景图3
      }
    }

    if (rectSkillUI != null && monster is BossMonster) {
      skillUI.renderRect(c, rectSkillUI); //boss头像
    }
  }

  void update(double t) {
    if (monster.game.activeView != View.playing || monster.flyRect == null||monster.hpEffect==null) {
      return;
    }
    //血条位置
    //对话框位置
    rectBg1 = rectTemplate(widthDeflate: 1);
    var bossUIWidth = monster.game.tileSize * 0.5;
    rectSkillUI = Rect.fromLTWH(rectBg1.right + monster.game.tileSize * 0.5,
        rectBg1.top - rectBg1.height * 2, bossUIWidth, bossUIWidth);
    var mpPercent = (monster.curMp) /
        monster.initMp; //monster.hits*monster.game.att / monster.hp
    if (mpPercent >= 1) {
      isFever = true;
      mpPercent = 1;
    }

    rectBg2 = rectTemplate(widthDeflate: mpPercent); //最终宽度
  }
}
