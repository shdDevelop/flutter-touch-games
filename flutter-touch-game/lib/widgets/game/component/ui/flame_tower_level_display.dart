 
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/common/const.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';

 
 
class TowerLevelDisplay {
  final LangawGame game;
  Rect rect;
  TextStyle textStyle;
  TextPainter painter;
  Offset position;

  TowerLevelDisplay(this.game) {

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
    var towerInfoStr="Level ${game.curTowerLevel}";
    if((painter?.text?.text??'')!=towerInfoStr)
    {
      painter.text=new TextSpan(text:towerInfoStr,style: textStyle);
      painter.layout();
      position = Offset(
      game.tileSize *  .25,
      game.tileSize *  1,
    );
    }
  }
   
}
