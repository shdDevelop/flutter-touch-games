 
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

 
 
class ScoreDisplay {
  final LangawGame game;
  Rect rect;
  TextStyle textStyle;
  TextPainter painter;
  Offset position;

  ScoreDisplay(this.game) {

  painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
   textStyle = TextStyle(
    color: color_game_text,
    fontSize: 30,
    shadows: <Shadow>[
      Shadow(
        blurRadius: 7,
        color: color_game_shadow,
        offset: Offset(3, 3),
      ),
    ],
  );
   position = Offset.zero;
  }
  void render(Canvas c) {
    painter?.paint(c, position);
  }
  void update(double t) {
    if((painter?.text?.text??'')!=game.score.toString())
    {
      painter.text=new TextSpan(text:game.score.toString(),style: textStyle);
      painter.layout();
      position = Offset(
      game.screenCenterX-game.tileSize*0.5,
      game.tileSize * 1.2,
    );
    }
  }
   
}
