import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/utils/sp_util.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_text_style.dart';

import '../../../flame_Langaw_Game.dart';

//最高分位置
class TextDisplay {
  final LangawGame game;
  TextPainter painter;
  TextStyle textStyle;
  GameTextStyle gameTextStyle;
  Offset position;
  double dx;
  double dy;
  double fontSize;
  Color color;
  TextDisplay(String text,
      {this.game,
      this.color,
      this.fontSize = 20,
      this.textStyle,
      this.position,
      this.dx,
      this.dy}) {
    gameTextStyle = new GameTextStyle();
    painter = new TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    painter.text = TextSpan(
      text: text,
      style: gameTextStyle.getColumnTextrStyle(fontSize: fontSize,textColor:color ),
    );
    if (dx != null && dy != null) {
      position = new Offset(dx, dy);
    }
    if (position == null) {
      position = Offset.zero;
    }

    painter.layout();
    position = new Offset(position.dx - painter.width/2, position.dy);
  }
  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {}

  void updateHighscore() {}

  
}
