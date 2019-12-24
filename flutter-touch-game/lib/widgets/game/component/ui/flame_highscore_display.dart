import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/utils/sp_util.dart';
import 'package:mz_flutterapp_deep/widgets/game/component/ui/util/flame_animation_display.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';

import '../../flame_Langaw_Game.dart';
//最高分位置
class HighscoreDisplay {
  final LangawGame game;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  Sprite bgSprite;
   Rect treasureRect;
  HighscoreDisplay(this.game) {
    bgSprite = new Sprite('game/TreasureChest_1.png');
    //宝箱位置
    treasureRect = Rect.fromLTWH(game.screenSize.width- (game.tileSize * 1.25),game.tileSize* .25, game.tileSize * 1, game.tileSize* 1);   
    painter = new TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    Shadow shadow = Shadow(
      blurRadius: 3,
      color: Color(0xff000000),
      offset: Offset.zero,
    );
    textStyle = new TextStyle(
        color: Color(0xffffffff),
        fontSize: 20,
        shadows: [shadow, shadow, shadow, shadow]);
    position = Offset.zero;
    updateHighscore();
  //       game, "game/TreasureChest_2.png", 5,
  //  var  highDisplay = new AnimationDisplay(
  //       offset: Offset(treasureRect.left - treasureRect.width / 6,
  //           treasureRect.top - treasureRect.height / 6),
  //       width: treasureRect.width / 2,
  //       height: treasureRect.height / 2,textureWidth: 43);
  //   game.animationDisplayList.add(highDisplay);
  }
  void render(Canvas c) {
     painter?.paint(c, position);
     bgSprite?.renderRect(c, treasureRect);
  }

  void update(double t) {}

  void updateHighscore() {
    game.isRecordRefresh=true;//打破记录
    int highscore = SPUtil.getInt('highscore') ?? 0;
    painter.text = TextSpan(
      text: 'High-score: ' + highscore.toString(),
      style: textStyle,
    );
    painter.layout();
    position = Offset(
      game.screenSize.width - (game.tileSize * .5) - painter.width-treasureRect.width,
      game.tileSize * .25,
    );
  }

  void onTapDown(TapDownDetails tapDown) {
    //game.changeView(View.rank);
  }
  
}
