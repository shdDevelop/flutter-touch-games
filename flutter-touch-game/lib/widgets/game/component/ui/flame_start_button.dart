import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:mz_flutterapp_deep/widgets/game/enum/flame_enum.dart';
import 'package:flutter/material.dart';
import '../../flame_Langaw_Game.dart';

class StartButtonView {
  final LangawGame game;
  Rect rect;
  Sprite sprite;
  TextStyle textStyle;
  TextPainter painter;
  Offset position;

  StartButtonView(this.game) {
    rect = Rect.fromLTWH(
      game.screenSize.width * 0.5 - game.tileSize * 2,
      (game.screenSize.height * 0.5-game.tileSize * 1.5/2),
      game.tileSize * 4,
      game.tileSize * 1.5,
    );
    sprite = Sprite('game/start-button.png');
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w900,
      fontSize: 30,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );
    position = Offset.zero;
  }
  void render(Canvas c) {
    sprite.renderRect(c, rect);
    painter.text = new TextSpan(text: "开始", style: textStyle);
    painter.layout();
    position = Offset(rect.left + rect.width/2- game.tileSize*0.8, rect.top+ game.tileSize*0.1);
    painter.paint(c, position);
  }

  void update(double t) {}

  Future onTapDown(TapDownDetails tapDown) async{
    game.audioplayers.buttonComfirm();
    game.changeView(View.playing);
    //进入playing
    game.initialStart();
  }
}
