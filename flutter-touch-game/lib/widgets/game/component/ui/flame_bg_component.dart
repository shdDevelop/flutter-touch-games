import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:mz_flutterapp_deep/widgets/game/flame_Langaw_Game.dart';


class Backyard {
  Backyard({this.game}) {
    bgSprite = new Sprite('game/backyard.png');
    bgRect=new Rect.fromLTWH(0,game.screenSize.height-game.tileSize*23,9*game.tileSize,game.tileSize*23);
  }
  Sprite bgSprite;
  Rect bgRect;
  final LangawGame game;

  void update(double t) {}

  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }
}
